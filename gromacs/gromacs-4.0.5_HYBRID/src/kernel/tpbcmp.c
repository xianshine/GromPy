/*
 * $Id: tpbcmp.c,v 1.92.2.1 2008/12/01 15:07:01 hess Exp $
 * 
 *                This source code is part of
 * 
 *                 G   R   O   M   A   C   S
 * 
 *          GROningen MAchine for Chemical Simulations
 * 
 *                        VERSION 3.2.0
 * Written by David van der Spoel, Erik Lindahl, Berk Hess, and others.
 * Copyright (c) 1991-2000, University of Groningen, The Netherlands.
 * Copyright (c) 2001-2004, The GROMACS development team,
 * check out http://www.gromacs.org for more information.

 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * If you want to redistribute modifications, please consider that
 * scientific software is very special. Version control is crucial -
 * bugs must be traceable. We will be happy to consider code for
 * inclusion in the official distribution, but derived work must not
 * be called official GROMACS. Details are found in the README & COPYING
 * files - if they are missing, get the official version at www.gromacs.org.
 * 
 * To help us fund GROMACS development, we humbly ask that you cite
 * the papers on the package - you can find them in the top README file.
 * 
 * For more info, check our website at http://www.gromacs.org
 * 
 * And Hey:
 * Gallium Rubidium Oxygen Manganese Argon Carbon Silicon
 */
/* This file is completely threadsafe - keep it that way! */
#ifdef HAVE_CONFIG_H
#include <config.h>
#endif

#include <math.h>
#include <stdio.h>
#include <string.h>
#include "main.h"
#include "macros.h"
#include "smalloc.h"
#include "futil.h"
#include "statutil.h"
#include "sysstuff.h"
#include "txtdump.h"
#include "gmx_fatal.h"
#include "names.h"
#include "tpxio.h"
#include "enxio.h"
#include "mtop_util.h"

static void cmp_int(FILE *fp,char *s,int index,int i1,int i2)
{
  if (i1 != i2) {
    if (index != -1)
      fprintf(fp,"%s[%d] (%d - %d)\n",s,index,i1,i2);
    else
      fprintf(fp,"%s (%d - %d)\n",s,i1,i2);
  }
}

static void cmp_us(FILE *fp,char *s,int index,unsigned short i1,unsigned short i2)
{
  if (i1 != i2) {
    if (index != -1)
      fprintf(fp,"%s[%d] (%d - %d)\n",s,index,i1,i2);
    else
      fprintf(fp,"%s (%d - %d)\n",s,i1,i2);
  }
}

static void cmp_uc(FILE *fp,char *s,int index,unsigned char i1,unsigned char i2)
{
  if (i1 != i2) {
    if (index != -1)
      fprintf(fp,"%s[%d] (%d - %d)\n",s,index,i1,i2);
    else
      fprintf(fp,"%s (%d - %d)\n",s,i1,i2);
  }
}

static bool cmp_bool(FILE *fp, char *s, int index, bool b1, bool b2)
{
  b1 = b1 & TRUE;
  b2 = b2 & TRUE;
  if (b1 != b2) {
    if (index != -1)
      fprintf(fp,"%s[%d] (%s - %s)\n",s,index,
	      bool_names[b1],bool_names[b2]);
    else
      fprintf(fp,"%s (%s - %s)\n",s,
	      bool_names[b1],bool_names[b2]);
  }
  return b1 && b2;
}

static void cmp_str(FILE *fp, char *s, int index, char *s1, char *s2)
{
  if (strcmp(s1,s2) != 0) {
    if (index != -1)
      fprintf(fp,"%s[%d] (%s - %s)\n",s,index,s1,s2);
    else
      fprintf(fp,"%s (%s - %s)\n",s,s1,s2);
  }
}

static bool equal_real(real i1,real i2,real ftol)
{
  return 2*fabs(i1 - i2) <= (fabs(i1) + fabs(i2))*ftol;
}

static void cmp_real(FILE *fp,char *s,int index,real i1,real i2,real ftol)
{
  if (!equal_real(i1,i2,ftol)) {
    if (index != -1)
      fprintf(fp,"%s[%d] (%e - %e)\n",s,index,i1,i2);
    else
      fprintf(fp,"%s (%e - %e)\n",s,i1,i2);
  }
}

static void cmp_rvec(FILE *fp,char *s,int index,rvec i1,rvec i2,real ftol)
{
  if (2*fabs(i1[XX] - i2[XX]) > (fabs(i1[XX]) + fabs(i2[XX]))*ftol ||
      2*fabs(i1[YY] - i2[YY]) > (fabs(i1[YY]) + fabs(i2[YY]))*ftol ||
      2*fabs(i1[ZZ] - i2[ZZ]) > (fabs(i1[ZZ]) + fabs(i2[ZZ]))*ftol) {
    if (index != -1)
      fprintf(fp,"%s[%5d] (%12.5e %12.5e %12.5e) - (%12.5e %12.5e %12.5e)\n",
	      s,index,i1[XX],i1[YY],i1[ZZ],i2[XX],i2[YY],i2[ZZ]);
    else
      fprintf(fp,"%s (%12.5e %12.5e %12.5e) - (%12.5e %12.5e %12.5e)\n",
	      s,i1[XX],i1[YY],i1[ZZ],i2[XX],i2[YY],i2[ZZ]);
  }
}

static void cmp_ivec(FILE *fp,char *s,int index,ivec i1,ivec i2)
{
  if ((i1[XX] != i2[XX]) || (i1[YY] != i2[YY]) || (i1[ZZ] != i2[ZZ])) {
    if (index != -1)
      fprintf(fp,"%s[%5d] (%8d,%8d,%8d - %8d,%8d,%8d)\n",s,index,
	      i1[XX],i1[YY],i1[ZZ],i2[XX],i2[YY],i2[ZZ]);
    else
      fprintf(fp,"%s (%8d,%8d,%8d - %8d,%8d,%8d)\n",s,
	      i1[XX],i1[YY],i1[ZZ],i2[XX],i2[YY],i2[ZZ]);
  }
}

static void cmp_ilist(FILE *fp,int ftype,t_ilist *il1,t_ilist *il2)
{
  int i;
  char buf[256];
 
  fprintf(fp,"comparing ilist %s\n",interaction_function[ftype].name);
  sprintf(buf,"%s->nr",interaction_function[ftype].name);
  cmp_int(fp,buf,-1,il1->nr,il2->nr);
  sprintf(buf,"%s->iatoms",interaction_function[ftype].name);
  if (((il1->nr > 0) && (!il1->iatoms)) || 
      ((il2->nr > 0) && (!il2->iatoms)) ||
      ((il1->nr != il2->nr)))
    fprintf(fp,"Comparing radically different topologies - %s is different\n",
	    buf);
  else
    for(i=0; (i<il1->nr); i++) 
      cmp_int(fp,buf,i,il1->iatoms[i],il2->iatoms[i]);
}

void cmp_iparm(FILE *fp,char *s,t_functype ft,
	       t_iparams ip1,t_iparams ip2,real ftol) 
{
  int i;
  bool bDiff;
  
  bDiff=FALSE;
  for(i=0; i<MAXFORCEPARAM && !bDiff; i++)
    bDiff = !equal_real(ip1.generic.buf[i],ip2.generic.buf[i],ftol);
  if (bDiff) {
    fprintf(fp,"%s1: ",s);
    pr_iparams(fp,ft,&ip1);
    fprintf(fp,"%s2: ",s);
    pr_iparams(fp,ft,&ip2);
  }
}

void cmp_iparm_AB(FILE *fp,char *s,t_functype ft,t_iparams ip1,real ftol) 
{
  int nrfpA,nrfpB,p0,i;
  bool bDiff;
  
  /* Normally the first parameter is perturbable */
  p0 = 0;
  nrfpA = interaction_function[ft].nrfpA;
  nrfpB = interaction_function[ft].nrfpB;
  if (ft == F_PDIHS) {
    nrfpB = 2;
  } else if (interaction_function[ft].flags & IF_TABULATED) {
    /* For tabulated interactions only the second parameter is perturbable */
    p0 = 1;
    nrfpB = 1;
  }
  bDiff=FALSE;
  for(i=0; i<nrfpB && !bDiff; i++) {
    bDiff = !equal_real(ip1.generic.buf[p0+i],ip1.generic.buf[nrfpA+i],ftol);
  }
  if (bDiff) {
    fprintf(fp,"%s: ",s);
    pr_iparams(fp,ft,&ip1);
  }
}

static void cmp_idef(FILE *fp,t_idef *id1,t_idef *id2,real ftol)
{
  int i;
  char buf1[64],buf2[64];
  
  fprintf(fp,"comparing idef\n");
  if (id2) {
    cmp_int(fp,"idef->ntypes",-1,id1->ntypes,id2->ntypes);
    cmp_int(fp,"idef->atnr",  -1,id1->atnr,id2->atnr);
    for(i=0; (i<id1->ntypes); i++) {
      sprintf(buf1,"idef->functype[%d]",i);
      sprintf(buf2,"idef->iparam[%d]",i);
      cmp_int(fp,buf1,i,(int)id1->functype[i],(int)id2->functype[i]);
      cmp_iparm(fp,buf2,id1->functype[i],
		id1->iparams[i],id2->iparams[i],ftol);
    }
    cmp_real(fp,"fudgeQQ",-1,id1->fudgeQQ,id2->fudgeQQ,ftol);
    for(i=0; (i<F_NRE); i++)
      cmp_ilist(fp,i,&(id1->il[i]),&(id2->il[i]));
  } else {
    for(i=0; (i<id1->ntypes); i++)
      cmp_iparm_AB(fp,"idef->iparam",id1->functype[i],id1->iparams[i],ftol);
  }
}

static void cmp_block(FILE *fp,t_block *b1,t_block *b2,const char *s)
{
  int i,j,k;
  char buf[32];
  
  fprintf(fp,"comparing block %s\n",s);
  sprintf(buf,"%s.nr",s);
  cmp_int(fp,buf,-1,b1->nr,b2->nr);
} 

static void cmp_blocka(FILE *fp,t_blocka *b1,t_blocka *b2,const char *s)
{
  int i,j,k;
  char buf[32];
  
  fprintf(fp,"comparing blocka %s\n",s);
  sprintf(buf,"%s.nr",s);
  cmp_int(fp,buf,-1,b1->nr,b2->nr);
  sprintf(buf,"%s.nra",s);
  cmp_int(fp,buf,-1,b1->nra,b2->nra);
} 

static void cmp_atom(FILE *fp,int index,t_atom *a1,t_atom *a2,real ftol)
{
  int  i;
  char buf[256];

  if (a2) {
    cmp_us(fp,"atom.type",index,a1->type,a2->type);
    cmp_us(fp,"atom.ptype",index,a1->ptype,a2->ptype);
    cmp_int(fp,"atom.resnr",index,a1->resnr,a2->resnr);
    cmp_int(fp,"atom.atomnumber",index,a1->atomnumber,a2->atomnumber);
    cmp_real(fp,"atom.m",index,a1->m,a2->m,ftol);
    cmp_real(fp,"atom.q",index,a1->q,a2->q,ftol);
    cmp_us(fp,"atom.typeB",index,a1->typeB,a2->typeB);
    cmp_real(fp,"atom.mB",index,a1->mB,a2->mB,ftol);
    cmp_real(fp,"atom.qB",index,a1->qB,a2->qB,ftol);
  } else {
    cmp_us(fp,"atom.type",index,a1->type,a1->typeB);
    cmp_real(fp,"atom.m",index,a1->m,a1->mB,ftol);
    cmp_real(fp,"atom.q",index,a1->q,a1->qB,ftol);
  }
}

static void cmp_atoms(FILE *fp,t_atoms *a1,t_atoms *a2,real ftol)
{
  int i;
  
  fprintf(fp,"comparing atoms\n");

  if (a2) {
    cmp_int(fp,"atoms->nr",-1,a1->nr,a2->nr);
    for(i=0; (i<a1->nr); i++)
      cmp_atom(fp,i,&(a1->atom[i]),&(a2->atom[i]),ftol);
  } else {
    for(i=0; (i<a1->nr); i++)
      cmp_atom(fp,i,&(a1->atom[i]),NULL,ftol);
  }
}

static void cmp_top(FILE *fp,t_topology *t1,t_topology *t2,real ftol)
{
  int i;
  
  fprintf(fp,"comparing top\n");
  if (t2) {
    cmp_idef(fp,&(t1->idef),&(t2->idef),ftol);
    cmp_atoms(fp,&(t1->atoms),&(t2->atoms),ftol);
    cmp_block(fp,&t1->cgs,&t2->cgs,"cgs");
    cmp_block(fp,&t1->mols,&t2->mols,"mols");
    cmp_blocka(fp,&t1->excls,&t2->excls,"excls");
  } else {
    cmp_idef(fp,&(t1->idef),NULL,ftol);
    cmp_atoms(fp,&(t1->atoms),NULL,ftol);
  }
}

static void cmp_rvecs(FILE *fp,char *title,int n,rvec x1[],rvec x2[],real ftol)
{
  int i;
  
  for(i=0; (i<n); i++)
    cmp_rvec(fp,title,i,x1[i],x2[i],ftol);
}

static void cmp_grpopts(FILE *fp,t_grpopts *opt1,t_grpopts *opt2,real ftol)
{
  int i,j;
  char buf1[256],buf2[256];
  
  cmp_int(fp,"inputrec->grpopts.ngtc",-1,  opt1->ngtc,opt2->ngtc);
  cmp_int(fp,"inputrec->grpopts.ngacc",-1, opt1->ngacc,opt2->ngacc);
  cmp_int(fp,"inputrec->grpopts.ngfrz",-1, opt1->ngfrz,opt2->ngfrz);
  cmp_int(fp,"inputrec->grpopts.ngener",-1,opt1->ngener,opt2->ngener);
  for(i=0; (i<min(opt1->ngtc,opt2->ngtc)); i++) {
    cmp_real(fp,"inputrec->grpopts.nrdf",i,opt1->nrdf[i],opt2->nrdf[i],ftol);
    cmp_real(fp,"inputrec->grpopts.ref_t",i,opt1->ref_t[i],opt2->ref_t[i],ftol);
    cmp_real(fp,"inputrec->grpopts.tau_t",i,opt1->tau_t[i],opt2->tau_t[i],ftol);
    cmp_int(fp,"inputrec->grpopts.annealing",i,opt1->annealing[i],opt2->annealing[i]);
    cmp_int(fp,"inputrec->grpopts.anneal_npoints",i,
	    opt1->anneal_npoints[i],opt2->anneal_npoints[i]);
    if(opt1->anneal_npoints[i]==opt2->anneal_npoints[i]) {
      sprintf(buf1,"inputrec->grpopts.anneal_time[%d]",i);
      sprintf(buf2,"inputrec->grpopts.anneal_temp[%d]",i);
      for(j=0;j<opt1->anneal_npoints[i];j++) {
	cmp_real(fp,buf1,j,opt1->anneal_time[i][j],opt2->anneal_time[i][j],ftol);
	cmp_real(fp,buf2,j,opt1->anneal_temp[i][j],opt2->anneal_temp[i][j],ftol);
      }
    }
  }
  if (opt1->ngener == opt2->ngener) {
    for(i=0; i<opt1->ngener; i++)
      for(j=i; j<opt1->ngener; j++) {
	sprintf(buf1,"inputrec->grpopts.egp_flags[%d]",i);
	cmp_int(fp,buf1,j,
		opt1->egp_flags[opt1->ngener*i+j],
		opt2->egp_flags[opt1->ngener*i+j]);
      }
  }
  for(i=0; (i<min(opt1->ngacc,opt2->ngacc)); i++)
    cmp_rvec(fp,"inputrec->grpopts.acc",i,opt1->acc[i],opt2->acc[i],ftol);
  for(i=0; (i<min(opt1->ngfrz,opt2->ngfrz)); i++)
    cmp_ivec(fp,"inputrec->grpopts.nFreeze",i,opt1->nFreeze[i],opt2->nFreeze[i]);
}

static void cmp_cosines(FILE *fp,char *s,t_cosines c1[DIM],t_cosines c2[DIM],real ftol)
{
  int i,m;
  char buf[256];
  
  for(m=0; (m<DIM); m++) {
    sprintf(buf,"inputrec->%s[%d]",s,m);
    cmp_int(fp,buf,0,c1->n,c2->n);
    for(i=0; (i<min(c1->n,c2->n)); i++) {
      cmp_real(fp,buf,i,c1->a[i],c2->a[i],ftol);
      cmp_real(fp,buf,i,c1->phi[i],c2->phi[i],ftol);
    }
  }
}

static void cmp_pull(FILE *fp,t_pull *pull1,t_pull *pull2,real ftol)
{
  fprintf(fp,"WARNING: Both files use COM pulling, but comparing of the pull struct is not implemented (yet). The pull parameters could be the same or different.\n");
}

static void cmp_inputrec(FILE *fp,t_inputrec *ir1,t_inputrec *ir2,real ftol)
{
  fprintf(fp,"comparing inputrec\n");

  /* gcc 2.96 doesnt like these defines at all, but issues a huge list
   * of warnings. Maybe it will change in future versions, but for the
   * moment I've spelled them out instead. /EL 000820 
   * #define CIB(s) cmp_int(fp,"inputrec->"#s,0,ir1->##s,ir2->##s)
   * #define CII(s) cmp_int(fp,"inputrec->"#s,0,ir1->##s,ir2->##s)
   * #define CIR(s) cmp_real(fp,"inputrec->"#s,0,ir1->##s,ir2->##s,ftol)
   */
  cmp_int(fp,"inputrec->eI",-1,ir1->eI,ir2->eI);
  cmp_int(fp,"inputrec->nsteps",-1,ir1->nsteps,ir2->nsteps);
  cmp_int(fp,"inputrec->init_step",-1,ir1->init_step,ir2->init_step);
  cmp_int(fp,"inputrec->ePBC",-1,ir1->ePBC,ir2->ePBC);
  cmp_int(fp,"inputrec->bPeriodicMols",-1,ir1->bPeriodicMols,ir2->bPeriodicMols);
  cmp_int(fp,"inputrec->ns_type",-1,ir1->ns_type,ir2->ns_type);
  cmp_int(fp,"inputrec->nstlist",-1,ir1->nstlist,ir2->nstlist);
  cmp_int(fp,"inputrec->ndelta",-1,ir1->ndelta,ir2->ndelta);
  cmp_int(fp,"inputrec->nstcomm",-1,ir1->nstcomm,ir2->nstcomm);
  cmp_int(fp,"inputrec->comm_mode",-1,ir1->comm_mode,ir2->comm_mode);
  cmp_int(fp,"inputrec->nstcheckpoint",-1,ir1->nstcheckpoint,ir2->nstcheckpoint);
  cmp_int(fp,"inputrec->nstlog",-1,ir1->nstlog,ir2->nstlog);
  cmp_int(fp,"inputrec->nstxout",-1,ir1->nstxout,ir2->nstxout);
  cmp_int(fp,"inputrec->nstvout",-1,ir1->nstvout,ir2->nstvout);
  cmp_int(fp,"inputrec->nstfout",-1,ir1->nstfout,ir2->nstfout);
  cmp_int(fp,"inputrec->nstenergy",-1,ir1->nstenergy,ir2->nstenergy);
  cmp_int(fp,"inputrec->nstxtcout",-1,ir1->nstxtcout,ir2->nstxtcout);
  cmp_real(fp,"inputrec->init_t",-1,ir1->init_t,ir2->init_t,ftol);
  cmp_real(fp,"inputrec->delta_t",-1,ir1->delta_t,ir2->delta_t,ftol);
  cmp_real(fp,"inputrec->xtcprec",-1,ir1->xtcprec,ir2->xtcprec,ftol);
  cmp_int(fp,"inputrec->nkx",-1,ir1->nkx,ir2->nkx);
  cmp_int(fp,"inputrec->nky",-1,ir1->nky,ir2->nky);
  cmp_int(fp,"inputrec->nkz",-1,ir1->nkz,ir2->nkz);
  cmp_int(fp,"inputrec->pme_order",-1,ir1->pme_order,ir2->pme_order);
  cmp_real(fp,"inputrec->ewald_rtol",-1,ir1->ewald_rtol,ir2->ewald_rtol,ftol);
  cmp_int(fp,"inputrec->ewald_geometry",-1,ir1->ewald_geometry,ir2->ewald_geometry);
  cmp_real(fp,"inputrec->epsilon_surface",-1,ir1->epsilon_surface,ir2->epsilon_surface,ftol);
  cmp_int(fp,"inputrec->bOptFFT",-1,ir1->bOptFFT,ir2->bOptFFT);
  cmp_int(fp,"inputrec->bContinuation",-1,ir1->bContinuation,ir2->bContinuation);
  cmp_int(fp,"inputrec->bShakeSOR",-1,ir1->bShakeSOR,ir2->bShakeSOR);
  cmp_int(fp,"inputrec->etc",-1,ir1->etc,ir2->etc);
  cmp_int(fp,"inputrec->epc",-1,ir1->epc,ir2->epc);
  cmp_int(fp,"inputrec->epct",-1,ir1->epct,ir2->epct);
  cmp_real(fp,"inputrec->tau_p",-1,ir1->tau_p,ir2->tau_p,ftol);
  cmp_rvec(fp,"inputrec->ref_p(x)",-1,ir1->ref_p[XX],ir2->ref_p[XX],ftol);
  cmp_rvec(fp,"inputrec->ref_p(y)",-1,ir1->ref_p[YY],ir2->ref_p[YY],ftol);
  cmp_rvec(fp,"inputrec->ref_p(z)",-1,ir1->ref_p[ZZ],ir2->ref_p[ZZ],ftol);
  cmp_rvec(fp,"inputrec->compress(x)",-1,ir1->compress[XX],ir2->compress[XX],ftol);
  cmp_rvec(fp,"inputrec->compress(y)",-1,ir1->compress[YY],ir2->compress[YY],ftol);
  cmp_rvec(fp,"inputrec->compress(z)",-1,ir1->compress[ZZ],ir2->compress[ZZ],ftol);
  cmp_int(fp,"refcoord_scaling",-1,ir1->refcoord_scaling,ir2->refcoord_scaling);
   cmp_rvec(fp,"inputrec->posres_com",-1,ir1->posres_com,ir2->posres_com,ftol);
   cmp_rvec(fp,"inputrec->posres_comB",-1,ir1->posres_comB,ir2->posres_comB,ftol);
   cmp_int(fp,"inputrec->andersen_seed",-1,ir1->andersen_seed,ir2->andersen_seed);
  cmp_real(fp,"inputrec->rlist",-1,ir1->rlist,ir2->rlist,ftol);
  cmp_real(fp,"inputrec->rtpi",-1,ir1->rtpi,ir2->rtpi,ftol);
  cmp_int(fp,"inputrec->coulombtype",-1,ir1->coulombtype,ir2->coulombtype);
  cmp_real(fp,"inputrec->rcoulomb_switch",-1,ir1->rcoulomb_switch,ir2->rcoulomb_switch,ftol);
  cmp_real(fp,"inputrec->rcoulomb",-1,ir1->rcoulomb,ir2->rcoulomb,ftol);
  cmp_int(fp,"inputrec->vdwtype",-1,ir1->vdwtype,ir2->vdwtype);
  cmp_real(fp,"inputrec->rvdw_switch",-1,ir1->rvdw_switch,ir2->rvdw_switch,ftol);
  cmp_real(fp,"inputrec->rvdw",-1,ir1->rvdw,ir2->rvdw,ftol);
  cmp_real(fp,"inputrec->epsilon_r",-1,ir1->epsilon_r,ir2->epsilon_r,ftol);
  cmp_real(fp,"inputrec->epsilon_rf",-1,ir1->epsilon_rf,ir2->epsilon_rf,ftol);
  cmp_real(fp,"inputrec->tabext",-1,ir1->tabext,ir2->tabext,ftol);
  cmp_int(fp,"inputrec->gb_algorithm",-1,ir1->gb_algorithm,ir2->gb_algorithm);
  cmp_real(fp,"inputrec->gb_epsilon_solvent",-1,ir1->gb_epsilon_solvent,ir2->gb_epsilon_solvent,ftol);
  cmp_int(fp,"inputrec->nstgbradii",-1,ir1->nstgbradii,ir2->nstgbradii);
  cmp_real(fp,"inputrec->rgbradii",-1,ir1->rgbradii,ir2->rgbradii,ftol);
  cmp_real(fp,"inputrec->gb_saltconc",-1,ir1->gb_saltconc,ir2->gb_saltconc,ftol);
  cmp_int(fp,"inputrec->implicit_solvent",-1,ir1->implicit_solvent,ir2->implicit_solvent);
  cmp_real(fp,"inputrec->gb_obc_alpha",-1,ir1->gb_obc_alpha,ir2->gb_obc_alpha,ftol);
  cmp_real(fp,"inputrec->gb_obc_beta",-1,ir1->gb_obc_beta,ir2->gb_obc_beta,ftol);
  cmp_real(fp,"inputrec->gb_obc_gamma",-1,ir1->gb_obc_gamma,ir2->gb_obc_gamma,ftol);
  cmp_real(fp,"inputrec->sa_surface_tension",-1,ir1->sa_surface_tension,ir2->sa_surface_tension,ftol);
  	
	
  cmp_int(fp,"inputrec->eDispCorr",-1,ir1->eDispCorr,ir2->eDispCorr);
  cmp_real(fp,"inputrec->shake_tol",-1,ir1->shake_tol,ir2->shake_tol,ftol);
  cmp_int(fp,"inputrec->efep",-1,ir1->efep,ir2->efep);
  cmp_real(fp,"inputrec->init_lambda",-1,ir1->init_lambda,ir2->init_lambda,ftol);
  cmp_real(fp,"inputrec->delta_lambda",-1,ir1->delta_lambda,ir2->delta_lambda,ftol);
  cmp_real(fp,"inputrec->sc_alpha",-1,ir1->sc_alpha,ir2->sc_alpha,ftol);
  cmp_int(fp,"inputrec->sc_power",-1,ir1->sc_power,ir2->sc_power);
  cmp_real(fp,"inputrec->sc_sigma",-1,ir1->sc_sigma,ir2->sc_sigma,ftol);

  cmp_int(fp,"inputrec->nwall",-1,ir1->nwall,ir2->nwall);
  cmp_int(fp,"inputrec->wall_type",-1,ir1->wall_type,ir2->wall_type);
  cmp_int(fp,"inputrec->wall_atomtype[0]",-1,ir1->wall_atomtype[0],ir2->wall_atomtype[0]);
  cmp_int(fp,"inputrec->wall_atomtype[1]",-1,ir1->wall_atomtype[1],ir2->wall_atomtype[1]);
  cmp_real(fp,"inputrec->wall_density[0]",-1,ir1->wall_density[0],ir2->wall_density[0],ftol);
  cmp_real(fp,"inputrec->wall_density[1]",-1,ir1->wall_density[1],ir2->wall_density[1],ftol);
  cmp_real(fp,"inputrec->wall_ewald_zfac",-1,ir1->wall_ewald_zfac,ir2->wall_ewald_zfac,ftol);

  cmp_int(fp,"inputrec->ePull",-1,ir1->ePull,ir2->ePull);
  if (ir1->ePull == ir2->ePull && ir1->ePull != epullNO)
    cmp_pull(fp,ir1->pull,ir2->pull,ftol);
  
  cmp_int(fp,"inputrec->eDisre",-1,ir1->eDisre,ir2->eDisre);
  cmp_real(fp,"inputrec->dr_fc",-1,ir1->dr_fc,ir2->dr_fc,ftol);
  cmp_int(fp,"inputrec->eDisreWeighting",-1,ir1->eDisreWeighting,ir2->eDisreWeighting);
  cmp_int(fp,"inputrec->bDisreMixed",-1,ir1->bDisreMixed,ir2->bDisreMixed);
  cmp_int(fp,"inputrec->nstdisreout",-1,ir1->nstdisreout,ir2->nstdisreout);
  cmp_real(fp,"inputrec->dr_tau",-1,ir1->dr_tau,ir2->dr_tau,ftol);
  cmp_real(fp,"inputrec->orires_fc",-1,ir1->orires_fc,ir2->orires_fc,ftol);
  cmp_real(fp,"inputrec->orires_tau",-1,ir1->orires_tau,ir2->orires_tau,ftol);
  cmp_int(fp,"inputrec->nstorireout",-1,ir1->nstorireout,ir2->nstorireout);
  cmp_real(fp,"inputrec->dihre_fc",-1,ir1->dihre_fc,ir2->dihre_fc,ftol);
  cmp_real(fp,"inputrec->em_stepsize",-1,ir1->em_stepsize,ir2->em_stepsize,ftol);
  cmp_real(fp,"inputrec->em_tol",-1,ir1->em_tol,ir2->em_tol,ftol);
  cmp_int(fp,"inputrec->niter",-1,ir1->niter,ir2->niter);
  cmp_real(fp,"inputrec->fc_stepsize",-1,ir1->fc_stepsize,ir2->fc_stepsize,ftol);
  cmp_int(fp,"inputrec->nstcgsteep",-1,ir1->nstcgsteep,ir2->nstcgsteep);
  cmp_int(fp,"inputrec->nbfgscorr",0,ir1->nbfgscorr,ir2->nbfgscorr);
  cmp_int(fp,"inputrec->eConstrAlg",-1,ir1->eConstrAlg,ir2->eConstrAlg);
  cmp_int(fp,"inputrec->nProjOrder",-1,ir1->nProjOrder,ir2->nProjOrder);
  cmp_real(fp,"inputrec->LincsWarnAngle",-1,ir1->LincsWarnAngle,ir2->LincsWarnAngle,ftol);
  cmp_int(fp,"inputrec->nLincsIter",-1,ir1->nLincsIter,ir2->nLincsIter);
  cmp_real(fp,"inputrec->bd_fric",-1,ir1->bd_fric,ir2->bd_fric,ftol);
  cmp_int(fp,"inputrec->ld_seed",-1,ir1->ld_seed,ir2->ld_seed);
  cmp_real(fp,"inputrec->cos_accel",-1,ir1->cos_accel,ir2->cos_accel,ftol);
  cmp_rvec(fp,"inputrec->deform(a)",-1,ir1->deform[XX],ir2->deform[XX],ftol);
  cmp_rvec(fp,"inputrec->deform(b)",-1,ir1->deform[YY],ir2->deform[YY],ftol);
  cmp_rvec(fp,"inputrec->deform(c)",-1,ir1->deform[ZZ],ir2->deform[ZZ],ftol);
  cmp_int(fp,"inputrec->userint1",-1,ir1->userint1,ir2->userint1);
  cmp_int(fp,"inputrec->userint2",-1,ir1->userint2,ir2->userint2);
  cmp_int(fp,"inputrec->userint3",-1,ir1->userint3,ir2->userint3);
  cmp_int(fp,"inputrec->userint4",-1,ir1->userint4,ir2->userint4);
  cmp_real(fp,"inputrec->userreal1",-1,ir1->userreal1,ir2->userreal1,ftol);
  cmp_real(fp,"inputrec->userreal2",-1,ir1->userreal2,ir2->userreal2,ftol);
  cmp_real(fp,"inputrec->userreal3",-1,ir1->userreal3,ir2->userreal3,ftol);
  cmp_real(fp,"inputrec->userreal4",-1,ir1->userreal4,ir2->userreal4,ftol);
  cmp_grpopts(fp,&(ir1->opts),&(ir2->opts),ftol);
  cmp_cosines(fp,"ex",ir1->ex,ir2->ex,ftol);
  cmp_cosines(fp,"et",ir1->et,ir2->et,ftol);
}

static void comp_pull_AB(FILE *fp,t_pull *pull,real ftol)
{
  int i;

  for(i=0; i<pull->ngrp+1; i++) {
    fprintf(fp,"comparing pull group %d\n",i);
    cmp_real(fp,"pullgrp->k",-1,pull->grp[i].k,pull->grp[i].kB,ftol);
  }
}

static void comp_state(t_state *st1, t_state *st2,real ftol)
{
  int i;

  fprintf(stdout,"comparing flags\n");
  cmp_int(stdout,"flags",-1,st1->flags,st2->flags);
  fprintf(stdout,"comparing box\n");
  cmp_rvecs(stdout,"box",DIM,st1->box,st2->box,ftol);
  fprintf(stdout,"comparing box_rel\n");
  cmp_rvecs(stdout,"box_rel",DIM,st1->box_rel,st2->box_rel,ftol);
  fprintf(stdout,"comparing boxv\n");
  cmp_rvecs(stdout,"boxv",DIM,st1->boxv,st2->boxv,ftol);
  if (st1->flags & (1<<estPRES_PREV)) {
    fprintf(stdout,"comparing prev_pres\n");
    cmp_rvecs(stdout,"pres_prev",DIM,st1->pres_prev,st2->pres_prev,ftol);
  }
  cmp_int(stdout,"ngtc",-1,st1->ngtc,st2->ngtc);
  if (st1->ngtc == st2->ngtc) {
    for(i=0; i<st1->ngtc; i++)
      cmp_real(stdout,"nosehoover_xi",
	       i,st1->nosehoover_xi[i],st2->nosehoover_xi[i],ftol);
  }
  cmp_int(stdout,"natoms",-1,st1->natoms,st2->natoms);
  if (st1->natoms == st2->natoms) {
    fprintf(stdout,"comparing x\n");
    cmp_rvecs(stdout,"x",st1->natoms,st1->x,st2->x,ftol);
    fprintf(stdout,"comparing v\n");
    cmp_rvecs(stdout,"v",st1->natoms,st1->v,st2->v,ftol);
  }
}

void comp_tpx(char *fn1,char *fn2,real ftol)
{
  char        *ff[2];
  t_tpxheader sh[2];
  t_inputrec  ir[2];
  t_state     state[2];
  gmx_mtop_t  mtop[2];
  t_topology  top[2];
  int         i,step;
  real        t;

  ff[0]=fn1;
  ff[1]=fn2;
  for(i=0; i<(fn2 ? 2 : 1); i++) {
    read_tpx_state(ff[i],&step,&t,&(ir[i]),&state[i],NULL,&(mtop[i]));
  }
  if (fn2) {
    cmp_inputrec(stdout,&ir[0],&ir[1],ftol);
    /* Convert gmx_mtop_t to t_topology.
     * We should implement direct mtop comparison,
     * but it might be useful to keep t_topology comparison as an option.
     */
    top[0] = gmx_mtop_t_to_t_topology(&mtop[0]);
    top[1] = gmx_mtop_t_to_t_topology(&mtop[1]);
    cmp_top(stdout,&top[0],&top[1],ftol);
    comp_state(&state[0],&state[1],ftol);
  } else {
    if (ir[0].efep == efepNO) {
      fprintf(stdout,"inputrec->efep = %s\n",efep_names[ir[0].efep]);
    } else {
      if (ir[0].ePull != epullNO) {
	comp_pull_AB(stdout,ir->pull,ftol);
      }
      /* Convert gmx_mtop_t to t_topology.
       * We should implement direct mtop comparison,
       * but it might be useful to keep t_topology comparison as an option.
       */
      top[0] = gmx_mtop_t_to_t_topology(&mtop[0]);
      cmp_top(stdout,&top[0],NULL,ftol);
    }
  }
}

void comp_frame(FILE *fp, t_trxframe *fr1, t_trxframe *fr2, real ftol)
{
  fprintf(fp,"\n");
  cmp_int(fp,"flags",-1,fr1->flags,fr2->flags);
  cmp_int(fp,"not_ok",-1,fr1->not_ok,fr2->not_ok);
  cmp_int(fp,"natoms",-1,fr1->natoms,fr2->natoms);
  cmp_real(fp,"t0",-1,fr1->t0,fr2->t0,ftol);
  if (cmp_bool(fp,"bTitle",-1,fr1->bTitle,fr2->bTitle))
    cmp_str(fp,"title", -1, fr1->title, fr2->title);
  if (cmp_bool(fp,"bStep",-1,fr1->bStep,fr2->bStep))
    cmp_int(fp,"step",-1,fr1->step,fr2->step);
  cmp_int(fp,"step",-1,fr1->step,fr2->step);
  if (cmp_bool(fp,"bTime",-1,fr1->bTime,fr2->bTime))   
    cmp_real(fp,"time",-1,fr1->time,fr2->time,ftol);
  if (cmp_bool(fp,"bLambda",-1,fr1->bLambda,fr2->bLambda)) 
    cmp_real(fp,"lambda",-1,fr1->lambda,fr2->lambda,ftol);
  if (cmp_bool(fp,"bAtoms",-1,fr1->bAtoms,fr2->bAtoms))
    cmp_atoms(fp,fr1->atoms,fr2->atoms,ftol);
  if (cmp_bool(fp,"bPrec",-1,fr1->bPrec,fr2->bPrec))
    cmp_real(fp,"prec",-1,fr1->prec,fr2->prec,ftol);
  if (cmp_bool(fp,"bX",-1,fr1->bX,fr2->bX))
    cmp_rvecs(fp,"x",min(fr1->natoms,fr2->natoms),fr1->x,fr2->x,ftol);
  if (cmp_bool(fp,"bV",-1,fr1->bV,fr2->bV))
    cmp_rvecs(fp,"v",min(fr1->natoms,fr2->natoms),fr1->v,fr2->v,ftol);
  if (cmp_bool(fp,"bF",-1,fr1->bF,fr2->bF))
    cmp_rvecs(fp,"f",min(fr1->natoms,fr2->natoms),fr1->f,fr2->f,ftol);
  if (cmp_bool(fp,"bBox",-1,fr1->bBox,fr2->bBox))
    cmp_rvecs(fp,"box",3,fr1->box,fr2->box,ftol);
}

void comp_trx(char *fn1, char *fn2, real ftol)
{
  int i;
  char *fn[2];
  t_trxframe fr[2];
  int status[2];
  bool b[2];
  
  fn[0]=fn1;
  fn[1]=fn2;
  fprintf(stderr,"Comparing trajectory files %s and %s\n",fn1,fn2);
  for (i=0; i<2; i++)
    b[i] = read_first_frame(&status[i],fn[i],&fr[i],TRX_READ_X|TRX_READ_V|TRX_READ_F);
  
  if (b[0] && b[1]) { 
    do {
      comp_frame(stdout, &(fr[0]), &(fr[1]), ftol);
      
      for (i=0; i<2; i++)
	b[i] = read_next_frame(status[i],&fr[i]);
    } while (b[0] && b[1]);
    
    for (i=0; i<2; i++) {
      if (b[i] && !b[1-i])
	fprintf(stdout,"\nEnd of file on %s but not on %s\n",fn[i],fn[1-i]);
      close_trj(status[i]);
    }
  }
  if (!b[0] && !b[1])
    fprintf(stdout,"\nBoth files read correctly\n");
}

static void cmp_energies(FILE *fp,int step1,int step2,int nre,
			 t_energy e1[],t_energy e2[],
			 char *enm1[],char *enm2[],real ftol,
			 int maxener)
{
  int  i;
  
  for(i=0; (i<maxener); i++) {
    if (!equal_real(e1[i].e,e2[i].e,ftol))
      fprintf(fp,"%-15s  step %3d:  %12g, %s step %3d: %12g\n",
	      enm1[i],step1,e1[i].e,
	      strcmp(enm1[i],enm2[i])!=0 ? enm2[i]:"",step2,e2[i].e);
  }
}

static void cmp_disres(t_enxframe *fr1,t_enxframe *fr2,real ftol)
{
  int i;
  char bav[64],bt[64];
    
  cmp_int(stdout,"ndisre",-1,fr1->ndisre,fr2->ndisre);
  if ((fr1->ndisre == fr2->ndisre) && (fr1->ndisre > 0)) {
    sprintf(bav,"step %d: disre rav",fr1->step);
    sprintf(bt, "step %d: disre  rt",fr1->step);
    for(i=0; (i<fr1->ndisre); i++) {
      cmp_real(stdout,bav,i,fr1->disre_rm3tav[i],fr2->disre_rm3tav[i],ftol);
      cmp_real(stdout,bt ,i,fr1->disre_rt[i]    ,fr2->disre_rt[i]    ,ftol);
    }
  }
}

static void cmp_eblocks(t_enxframe *fr1,t_enxframe *fr2,real ftol)
{
  int i,j;
  char buf[64];
    
  cmp_int(stdout,"nblock",-1,fr1->nblock,fr2->nblock);  
  if ((fr1->nblock == fr2->nblock) && (fr1->nblock > 0)) {
    for(j=0; (j<fr1->nblock); j++) {
      sprintf(buf,"step %d: block[%d]",fr1->step,j);
      cmp_int(stdout,buf,-1,fr1->nr[j],fr2->nr[j]);
      if ((fr1->nr[j] == fr2->nr[j]) && (fr1->nr[j] > 0)) {
	for(i=0; (i<fr1->nr[j]); i++) {
	  cmp_real(stdout,buf,i,fr1->block[i][j],fr2->block[i][j],ftol);
	}
      }
    }
  }
}

void comp_enx(char *fn1,char *fn2,real ftol,char *lastener)
{
  int        in1,in2,nre,nre1,nre2,block;
  int        i,maxener;
  char       **enm1=NULL,**enm2=NULL,buf[256];
  t_enxframe *fr1,*fr2;
  bool       b1,b2;
  
  fprintf(stdout,"comparing energy file %s and %s\n\n",fn1,fn2);

  in1 = open_enx(fn1,"r");
  in2 = open_enx(fn2,"r");
  do_enxnms(in1,&nre1,&enm1);
  do_enxnms(in2,&nre2,&enm2);
  if (nre1 != nre2) {
    fprintf(stdout,"%s: nre=%d, %s: nre=%d\n",fn1,nre1,fn2,nre2);
    return;
  }
  nre = nre1;
  fprintf(stdout,"There are %d terms in the energy files\n\n",nre);
  
  maxener = nre;
  for(i=0; (i<nre); i++) {
    cmp_str(stdout,"enm",i,enm1[i],enm2[i]);
    if ((lastener != NULL) && (strstr(enm1[i],lastener) != NULL)) {
      maxener=i+1;
      break;
    }
  }
  fprintf(stdout,"There are %d terms to compare in the energy files\n\n",
	  maxener);
  
  snew(fr1,1);
  snew(fr2,1);
  do { 
    b1 = do_enx(in1,fr1);
    b2 = do_enx(in2,fr2);
    if (b1 && !b2)
      fprintf(stdout,"\nEnd of file on %s but not on %s\n",fn2,fn1);
    else if (!b1 && b2) 
      fprintf(stdout,"\nEnd of file on %s but not on %s\n",fn1,fn2);
    else if (!b1 && !b2)
      fprintf(stdout,"\nFiles read succesfully\n");
    else {
      cmp_real(stdout,"t",-1,fr1->t,fr2->t,ftol);
      cmp_int(stdout,"step",-1,fr1->step,fr2->step);
      cmp_int(stdout,"nre",-1,fr1->nre,fr2->nre);
      if ((fr1->nre == nre) && (fr2->nre == nre))
	cmp_energies(stdout,fr1->step,fr1->step,nre,fr1->ener,fr2->ener,
		     enm1,enm2,ftol,maxener);
      cmp_disres(fr1,fr2,ftol);
      cmp_eblocks(fr1,fr2,ftol);
    }
  } while (b1 && b2);
    
  close_enx(in1);
  close_enx(in2);
  
  free_enxframe(fr2);
  sfree(fr2);
  free_enxframe(fr1);
  sfree(fr1);
}
