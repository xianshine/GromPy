##
## $Id: nb_kernel114_x86_64_sse2.s,v 1.8 2006/09/22 08:50:25 lindahl Exp $
##
## Gromacs 4.0                         Copyright (c) 1991-2003 
## David van der Spoel, Erik Lindahl
##
## This program is free software; you can redistribute it and/or
## modify it under the terms of the GNU General Public License
## as published by the Free Software Foundation; either version 2
## of the License, or (at your option) any later version.
##
## To help us fund GROMACS development, we humbly ask that you cite
## the research papers on the package. Check out http://www.gromacs.org
## 
## And Hey:
## Gnomes, ROck Monsters And Chili Sauce
##





.globl nb_kernel114_x86_64_sse2
.globl _nb_kernel114_x86_64_sse2
nb_kernel114_x86_64_sse2:       
_nb_kernel114_x86_64_sse2:      
.set nb114_fshift, 16
.set nb114_gid, 24
.set nb114_pos, 32
.set nb114_faction, 40
.set nb114_charge, 48
.set nb114_p_facel, 56
.set nb114_argkrf, 64
.set nb114_argcrf, 72
.set nb114_Vc, 80
.set nb114_type, 88
.set nb114_p_ntype, 96
.set nb114_vdwparam, 104
.set nb114_Vvdw, 112
.set nb114_p_tabscale, 120
.set nb114_VFtab, 128
.set nb114_invsqrta, 136
.set nb114_dvda, 144
.set nb114_p_gbtabscale, 152
.set nb114_GBtab, 160
.set nb114_p_nthreads, 168
.set nb114_count, 176
.set nb114_mtx, 184
.set nb114_outeriter, 192
.set nb114_inneriter, 200
.set nb114_work, 208
        ## stack offsets for local variables  
        ## bottom of stack is cache-aligned for sse2 use 
.set nb114_ixO, 0
.set nb114_iyO, 16
.set nb114_izO, 32
.set nb114_ixH1, 48
.set nb114_iyH1, 64
.set nb114_izH1, 80
.set nb114_ixH2, 96
.set nb114_iyH2, 112
.set nb114_izH2, 128
.set nb114_ixM, 144
.set nb114_iyM, 160
.set nb114_izM, 176
.set nb114_jxO, 192
.set nb114_jyO, 208
.set nb114_jzO, 224
.set nb114_jxH1, 240
.set nb114_jyH1, 256
.set nb114_jzH1, 272
.set nb114_jxH2, 288
.set nb114_jyH2, 304
.set nb114_jzH2, 320
.set nb114_jxM, 336
.set nb114_jyM, 352
.set nb114_jzM, 368
.set nb114_dxOO, 384
.set nb114_dyOO, 400
.set nb114_dzOO, 416
.set nb114_dxH1H1, 432
.set nb114_dyH1H1, 448
.set nb114_dzH1H1, 464
.set nb114_dxH1H2, 480
.set nb114_dyH1H2, 496
.set nb114_dzH1H2, 512
.set nb114_dxH1M, 528
.set nb114_dyH1M, 544
.set nb114_dzH1M, 560
.set nb114_dxH2H1, 576
.set nb114_dyH2H1, 592
.set nb114_dzH2H1, 608
.set nb114_dxH2H2, 624
.set nb114_dyH2H2, 640
.set nb114_dzH2H2, 656
.set nb114_dxH2M, 672
.set nb114_dyH2M, 688
.set nb114_dzH2M, 704
.set nb114_dxMH1, 720
.set nb114_dyMH1, 736
.set nb114_dzMH1, 752
.set nb114_dxMH2, 768
.set nb114_dyMH2, 784
.set nb114_dzMH2, 800
.set nb114_dxMM, 816
.set nb114_dyMM, 832
.set nb114_dzMM, 848
.set nb114_qqMM, 864
.set nb114_qqMH, 880
.set nb114_qqHH, 896
.set nb114_two, 912
.set nb114_c6, 944
.set nb114_c12, 960
.set nb114_vctot, 976
.set nb114_Vvdwtot, 992
.set nb114_fixO, 1008
.set nb114_fiyO, 1024
.set nb114_fizO, 1040
.set nb114_fixH1, 1056
.set nb114_fiyH1, 1072
.set nb114_fizH1, 1088
.set nb114_fixH2, 1104
.set nb114_fiyH2, 1120
.set nb114_fizH2, 1136
.set nb114_fixM, 1152
.set nb114_fiyM, 1168
.set nb114_fizM, 1184
.set nb114_fjxO, 1200
.set nb114_fjyO, 1216
.set nb114_fjzO, 1232
.set nb114_fjxH1, 1248
.set nb114_fjyH1, 1264
.set nb114_fjzH1, 1280
.set nb114_fjxH2, 1296
.set nb114_fjyH2, 1312
.set nb114_fjzH2, 1328
.set nb114_fjxM, 1344
.set nb114_fjyM, 1360
.set nb114_fjzM, 1376
.set nb114_half, 1392
.set nb114_three, 1408
.set nb114_six, 1424
.set nb114_twelve, 1440
.set nb114_rsqOO, 1456
.set nb114_rsqH1H1, 1472
.set nb114_rsqH1H2, 1488
.set nb114_rsqH1M, 1504
.set nb114_rsqH2H1, 1520
.set nb114_rsqH2H2, 1536
.set nb114_rsqH2M, 1552
.set nb114_rsqMH1, 1568
.set nb114_rsqMH2, 1584
.set nb114_rsqMM, 1600
.set nb114_rinvsqOO, 1616
.set nb114_rinvH1H1, 1632
.set nb114_rinvH1H2, 1648
.set nb114_rinvH1M, 1664
.set nb114_rinvH2H1, 1680
.set nb114_rinvH2H2, 1696
.set nb114_rinvH2M, 1712
.set nb114_rinvMH1, 1728
.set nb114_rinvMH2, 1744
.set nb114_rinvMM, 1760
.set nb114_nri, 1776
.set nb114_iinr, 1784
.set nb114_jindex, 1792
.set nb114_jjnr, 1800
.set nb114_shift, 1808
.set nb114_shiftvec, 1816
.set nb114_facel, 1824
.set nb114_innerjjnr, 1832
.set nb114_is3, 1840
.set nb114_ii3, 1844
.set nb114_innerk, 1848
.set nb114_n, 1852
.set nb114_nn1, 1856
.set nb114_nouter, 1860
.set nb114_ninner, 1864
        push %rbp
        movq %rsp,%rbp
        push %rbx

        emms

        push %r12
        push %r13
        push %r14
        push %r15

        subq $1880,%rsp         ## local variable stack space (n*16+8)

        ## zero 32-bit iteration counters
        movl $0,%eax
        movl %eax,nb114_nouter(%rsp)
        movl %eax,nb114_ninner(%rsp)

        movl (%rdi),%edi
        movl %edi,nb114_nri(%rsp)
        movq %rsi,nb114_iinr(%rsp)
        movq %rdx,nb114_jindex(%rsp)
        movq %rcx,nb114_jjnr(%rsp)
        movq %r8,nb114_shift(%rsp)
        movq %r9,nb114_shiftvec(%rsp)
        movq nb114_p_facel(%rbp),%rsi
        movsd (%rsi),%xmm0
        movsd %xmm0,nb114_facel(%rsp)

        ## create constant floating-point factors on stack
        movl $0x00000000,%eax   ## lower half of double half IEEE (hex)
        movl $0x3fe00000,%ebx
        movl %eax,nb114_half(%rsp)
        movl %ebx,nb114_half+4(%rsp)
        movsd nb114_half(%rsp),%xmm1
        shufpd $0,%xmm1,%xmm1  ## splat to all elements
        movapd %xmm1,%xmm3
        addpd  %xmm3,%xmm3      ## one
        movapd %xmm3,%xmm2
        addpd  %xmm2,%xmm2      ## two
        addpd  %xmm2,%xmm3      ## three
        movapd %xmm3,%xmm4
        addpd  %xmm4,%xmm4      ## six
        movapd %xmm4,%xmm5
        addpd  %xmm5,%xmm5      ## twelve
        movapd %xmm1,nb114_half(%rsp)
        movapd %xmm2,nb114_two(%rsp)
        movapd %xmm3,nb114_three(%rsp)
        movapd %xmm4,nb114_six(%rsp)
        movapd %xmm5,nb114_twelve(%rsp)

        ## assume we have at least one i particle - start directly 
        movq  nb114_iinr(%rsp),%rcx         ## rcx = pointer into iinr[]        
        movl  (%rcx),%ebx           ## ebx =ii 

        movq  nb114_charge(%rbp),%rdx
        movsd 24(%rdx,%rbx,8),%xmm3
        movsd %xmm3,%xmm4
        movsd 8(%rdx,%rbx,8),%xmm5
        movq nb114_p_facel(%rbp),%rsi
        movsd (%rsi),%xmm0
        movsd nb114_facel(%rsp),%xmm6
        mulsd  %xmm3,%xmm3
        mulsd  %xmm5,%xmm4
        mulsd  %xmm5,%xmm5
        mulsd  %xmm6,%xmm3
        mulsd  %xmm6,%xmm4
        mulsd  %xmm6,%xmm5
        shufpd $0,%xmm3,%xmm3
        shufpd $0,%xmm4,%xmm4
        shufpd $0,%xmm5,%xmm5
        movapd %xmm3,nb114_qqMM(%rsp)
        movapd %xmm4,nb114_qqMH(%rsp)
        movapd %xmm5,nb114_qqHH(%rsp)

        xorpd %xmm0,%xmm0
        movq  nb114_type(%rbp),%rdx
        movl  (%rdx,%rbx,4),%ecx
        shll  %ecx
        movl  %ecx,%edx
        movq nb114_p_ntype(%rbp),%rdi
        imull (%rdi),%ecx     ## rcx = ntia = 2*ntype*type[ii0] 
        addl  %ecx,%edx
        movq  nb114_vdwparam(%rbp),%rax
        movlpd (%rax,%rdx,8),%xmm0
        movlpd 8(%rax,%rdx,8),%xmm1
        shufpd $0,%xmm0,%xmm0
        shufpd $0,%xmm1,%xmm1
        movapd %xmm0,nb114_c6(%rsp)
        movapd %xmm1,nb114_c12(%rsp)

_nb_kernel114_x86_64_sse2.nb114_threadloop: 
        movq  nb114_count(%rbp),%rsi            ## pointer to sync counter
        movl  (%rsi),%eax
_nb_kernel114_x86_64_sse2.nb114_spinlock: 
        movl  %eax,%ebx                         ## ebx=*count=nn0
        addl  $1,%ebx                          ## ebx=nn1=nn0+10
        lock 
        cmpxchgl %ebx,(%rsi)                    ## write nn1 to *counter,
                                                ## if it hasnt changed.
                                                ## or reread *counter to eax.
        pause                                   ## -> better p4 performance
        jnz _nb_kernel114_x86_64_sse2.nb114_spinlock

        ## if(nn1>nri) nn1=nri
        movl nb114_nri(%rsp),%ecx
        movl %ecx,%edx
        subl %ebx,%ecx
        cmovlel %edx,%ebx                       ## if(nn1>nri) nn1=nri
        ## Cleared the spinlock if we got here.
        ## eax contains nn0, ebx contains nn1.
        movl %eax,nb114_n(%rsp)
        movl %ebx,nb114_nn1(%rsp)
        subl %eax,%ebx                          ## calc number of outer lists
        movl %eax,%esi                          ## copy n to esi
        jg  _nb_kernel114_x86_64_sse2.nb114_outerstart
        jmp _nb_kernel114_x86_64_sse2.nb114_end

_nb_kernel114_x86_64_sse2.nb114_outerstart: 
        ## ebx contains number of outer iterations
        addl nb114_nouter(%rsp),%ebx
        movl %ebx,nb114_nouter(%rsp)

_nb_kernel114_x86_64_sse2.nb114_outer: 
        movq  nb114_shift(%rsp),%rax        ## rax = pointer into shift[] 
        movl  (%rax,%rsi,4),%ebx        ## rbx=shift[n] 

        lea  (%rbx,%rbx,2),%rbx    ## rbx=3*is 
        movl  %ebx,nb114_is3(%rsp)      ## store is3 

        movq  nb114_shiftvec(%rsp),%rax     ## rax = base of shiftvec[] 

        movsd (%rax,%rbx,8),%xmm0
        movsd 8(%rax,%rbx,8),%xmm1
        movsd 16(%rax,%rbx,8),%xmm2

        movq  nb114_iinr(%rsp),%rcx         ## rcx = pointer into iinr[]        
        movl  (%rcx,%rsi,4),%ebx    ## ebx =ii 

        movapd %xmm0,%xmm3
        movapd %xmm1,%xmm4
        movapd %xmm2,%xmm5
        movapd %xmm0,%xmm6
        movapd %xmm1,%xmm7

        lea  (%rbx,%rbx,2),%rbx        ## rbx = 3*ii=ii3 
        movq  nb114_pos(%rbp),%rax      ## rax = base of pos[]  
        movl  %ebx,nb114_ii3(%rsp)

        addsd (%rax,%rbx,8),%xmm3       ## ox
        addsd 8(%rax,%rbx,8),%xmm4      ## oy
        addsd 16(%rax,%rbx,8),%xmm5     ## oz   
        addsd 24(%rax,%rbx,8),%xmm6     ## h1x
        addsd 32(%rax,%rbx,8),%xmm7     ## h1y
        shufpd $0,%xmm3,%xmm3
        shufpd $0,%xmm4,%xmm4
        shufpd $0,%xmm5,%xmm5
        shufpd $0,%xmm6,%xmm6
        shufpd $0,%xmm7,%xmm7
        movapd %xmm3,nb114_ixO(%rsp)
        movapd %xmm4,nb114_iyO(%rsp)
        movapd %xmm5,nb114_izO(%rsp)
        movapd %xmm6,nb114_ixH1(%rsp)
        movapd %xmm7,nb114_iyH1(%rsp)

        movsd %xmm2,%xmm6
        movsd %xmm0,%xmm3
        movsd %xmm1,%xmm4
        movsd %xmm2,%xmm5
        addsd 40(%rax,%rbx,8),%xmm6    ## h1z
        addsd 48(%rax,%rbx,8),%xmm0    ## h2x
        addsd 56(%rax,%rbx,8),%xmm1    ## h2y
        addsd 64(%rax,%rbx,8),%xmm2    ## h2z
        addsd 72(%rax,%rbx,8),%xmm3    ## mx
        addsd 80(%rax,%rbx,8),%xmm4    ## my
        addsd 88(%rax,%rbx,8),%xmm5    ## mz

        shufpd $0,%xmm6,%xmm6
        shufpd $0,%xmm0,%xmm0
        shufpd $0,%xmm1,%xmm1
        shufpd $0,%xmm2,%xmm2
        shufpd $0,%xmm3,%xmm3
        shufpd $0,%xmm4,%xmm4
        shufpd $0,%xmm5,%xmm5
        movapd %xmm6,nb114_izH1(%rsp)
        movapd %xmm0,nb114_ixH2(%rsp)
        movapd %xmm1,nb114_iyH2(%rsp)
        movapd %xmm2,nb114_izH2(%rsp)
        movapd %xmm3,nb114_ixM(%rsp)
        movapd %xmm4,nb114_iyM(%rsp)
        movapd %xmm5,nb114_izM(%rsp)

        ## clear vctot and i forces 
        xorpd %xmm4,%xmm4
        movapd %xmm4,nb114_vctot(%rsp)
        movapd %xmm4,nb114_Vvdwtot(%rsp)
        movapd %xmm4,nb114_fixO(%rsp)
        movapd %xmm4,nb114_fiyO(%rsp)
        movapd %xmm4,nb114_fizO(%rsp)
        movapd %xmm4,nb114_fixH1(%rsp)
        movapd %xmm4,nb114_fiyH1(%rsp)
        movapd %xmm4,nb114_fizH1(%rsp)
        movapd %xmm4,nb114_fixH2(%rsp)
        movapd %xmm4,nb114_fiyH2(%rsp)
        movapd %xmm4,nb114_fizH2(%rsp)
        movapd %xmm4,nb114_fixM(%rsp)
        movapd %xmm4,nb114_fiyM(%rsp)
        movapd %xmm4,nb114_fizM(%rsp)

        movq  nb114_jindex(%rsp),%rax
        movl  (%rax,%rsi,4),%ecx             ## jindex[n] 
        movl  4(%rax,%rsi,4),%edx            ## jindex[n+1] 
        subl  %ecx,%edx              ## number of innerloop atoms 

        movq  nb114_pos(%rbp),%rsi
        movq  nb114_faction(%rbp),%rdi
        movq  nb114_jjnr(%rsp),%rax
        shll  $2,%ecx
        addq  %rcx,%rax
        movq  %rax,nb114_innerjjnr(%rsp)       ## pointer to jjnr[nj0] 
        movl  %edx,%ecx
        subl  $2,%edx
        addl  nb114_ninner(%rsp),%ecx
        movl  %ecx,nb114_ninner(%rsp)
        addl  $0,%edx
        movl  %edx,nb114_innerk(%rsp)      ## number of innerloop atoms 
        jge   _nb_kernel114_x86_64_sse2.nb114_unroll_loop
        jmp   _nb_kernel114_x86_64_sse2.nb114_checksingle
_nb_kernel114_x86_64_sse2.nb114_unroll_loop: 
        ## twice unrolled innerloop here 
        movq  nb114_innerjjnr(%rsp),%rdx       ## pointer to jjnr[k] 
        movl  (%rdx),%eax
        movl  4(%rdx),%ebx

        addq $8,nb114_innerjjnr(%rsp)            ## advance pointer (unrolled 2) 

        movq nb114_pos(%rbp),%rsi        ## base of pos[] 

        lea  (%rax,%rax,2),%rax     ## replace jnr with j3 
        lea  (%rbx,%rbx,2),%rbx

        ## load j O coordinates
        movlpd (%rsi,%rax,8),%xmm4
        movlpd 8(%rsi,%rax,8),%xmm5
        movlpd 16(%rsi,%rax,8),%xmm6
        movhpd (%rsi,%rbx,8),%xmm4
        movhpd 8(%rsi,%rbx,8),%xmm5
        movhpd 16(%rsi,%rbx,8),%xmm6

    ## xmm4 = Ox
    ## xmm5 = Oy
    ## xmm6 = Oz

    subpd nb114_ixO(%rsp),%xmm4
    subpd nb114_iyO(%rsp),%xmm5
    subpd nb114_izO(%rsp),%xmm6

    ## store dx/dy/dz
    movapd %xmm4,%xmm9
    movapd %xmm5,%xmm10
    movapd %xmm6,%xmm11

        ## square it 
        mulpd %xmm4,%xmm4
        mulpd %xmm5,%xmm5
        mulpd %xmm6,%xmm6
        addpd %xmm5,%xmm4
        addpd %xmm6,%xmm4       ## rsq in xmm4 

        cvtpd2ps %xmm4,%xmm6
        rcpps %xmm6,%xmm6
        cvtps2pd %xmm6,%xmm6    ## lu in low xmm6 

        ## 1/x lookup seed in xmm6 
        movapd nb114_two(%rsp),%xmm0
        movapd %xmm4,%xmm5
        mulpd %xmm6,%xmm4       ## lu*rsq 
        subpd %xmm4,%xmm0       ## 2-lu*rsq 
        mulpd %xmm0,%xmm6       ## (new lu) 

        movapd nb114_two(%rsp),%xmm0
        mulpd %xmm6,%xmm5       ## lu*rsq 
        subpd %xmm5,%xmm0       ## 2-lu*rsq 
        mulpd %xmm6,%xmm0       ## xmm0=rinvsq 

        movapd %xmm0,%xmm1
        mulpd  %xmm0,%xmm1
        mulpd  %xmm0,%xmm1      ## xmm1=rinvsix 
        movapd %xmm1,%xmm2
        mulpd  %xmm2,%xmm2      ## xmm2=rinvtwelve 

        mulpd  nb114_c6(%rsp),%xmm1     ## mult by c6
        mulpd  nb114_c12(%rsp),%xmm2     ## mult by c12
        movapd %xmm2,%xmm5
        subpd  %xmm1,%xmm5      ## Vvdw=Vvdw12-Vvdw6 
        mulpd  nb114_six(%rsp),%xmm1
        mulpd  nb114_twelve(%rsp),%xmm2
        subpd  %xmm1,%xmm2
        mulpd  %xmm2,%xmm0      ## xmm0=total fscal 

    ## increment potential
    addpd  nb114_Vvdwtot(%rsp),%xmm5
    movapd %xmm5,nb114_Vvdwtot(%rsp)

        movq   nb114_faction(%rbp),%rdi
        mulpd  %xmm0,%xmm9
        mulpd  %xmm0,%xmm10
        mulpd  %xmm0,%xmm11

    movapd nb114_fixO(%rsp),%xmm0
    movapd nb114_fiyO(%rsp),%xmm1
    movapd nb114_fizO(%rsp),%xmm2

    ## accumulate i forces
    addpd %xmm9,%xmm0
    addpd %xmm10,%xmm1
    addpd %xmm11,%xmm2
    movapd %xmm0,nb114_fixO(%rsp)
    movapd %xmm1,nb114_fiyO(%rsp)
    movapd %xmm2,nb114_fizO(%rsp)

        ## the fj's - start by accumulating forces from memory 
    movlpd (%rdi,%rax,8),%xmm3
        movlpd 8(%rdi,%rax,8),%xmm4
        movlpd 16(%rdi,%rax,8),%xmm5
        movhpd (%rdi,%rbx,8),%xmm3
        movhpd 8(%rdi,%rbx,8),%xmm4
        movhpd 16(%rdi,%rbx,8),%xmm5
        addpd %xmm9,%xmm3
        addpd %xmm10,%xmm4
        addpd %xmm11,%xmm5
        movlpd %xmm3,(%rdi,%rax,8)
        movlpd %xmm4,8(%rdi,%rax,8)
        movlpd %xmm5,16(%rdi,%rax,8)
        movhpd %xmm3,(%rdi,%rbx,8)
        movhpd %xmm4,8(%rdi,%rbx,8)
        movhpd %xmm5,16(%rdi,%rbx,8)
    ## done with OO interaction

        movq   nb114_pos(%rbp),%rsi
    ## move j H1 coordinates to local temp variables 
    movlpd 24(%rsi,%rax,8),%xmm0
    movlpd 32(%rsi,%rax,8),%xmm1
    movlpd 40(%rsi,%rax,8),%xmm2
    movhpd 24(%rsi,%rbx,8),%xmm0
    movhpd 32(%rsi,%rbx,8),%xmm1
    movhpd 40(%rsi,%rbx,8),%xmm2

    ## xmm0 = H1x
    ## xmm1 = H1y
    ## xmm2 = H1z

    movapd %xmm0,%xmm3
    movapd %xmm1,%xmm4
    movapd %xmm2,%xmm5
    movapd %xmm0,%xmm6
    movapd %xmm1,%xmm7
    movapd %xmm2,%xmm8

    subpd nb114_ixH1(%rsp),%xmm0
    subpd nb114_iyH1(%rsp),%xmm1
    subpd nb114_izH1(%rsp),%xmm2
    subpd nb114_ixH2(%rsp),%xmm3
    subpd nb114_iyH2(%rsp),%xmm4
    subpd nb114_izH2(%rsp),%xmm5
    subpd nb114_ixM(%rsp),%xmm6
    subpd nb114_iyM(%rsp),%xmm7
    subpd nb114_izM(%rsp),%xmm8

        movapd %xmm0,nb114_dxH1H1(%rsp)
        movapd %xmm1,nb114_dyH1H1(%rsp)
        movapd %xmm2,nb114_dzH1H1(%rsp)
        mulpd  %xmm0,%xmm0
        mulpd  %xmm1,%xmm1
        mulpd  %xmm2,%xmm2
        movapd %xmm3,nb114_dxH2H1(%rsp)
        movapd %xmm4,nb114_dyH2H1(%rsp)
        movapd %xmm5,nb114_dzH2H1(%rsp)
        mulpd  %xmm3,%xmm3
        mulpd  %xmm4,%xmm4
        mulpd  %xmm5,%xmm5
        movapd %xmm6,nb114_dxMH1(%rsp)
        movapd %xmm7,nb114_dyMH1(%rsp)
        movapd %xmm8,nb114_dzMH1(%rsp)
        mulpd  %xmm6,%xmm6
        mulpd  %xmm7,%xmm7
        mulpd  %xmm8,%xmm8
        addpd  %xmm1,%xmm0
        addpd  %xmm2,%xmm0
        addpd  %xmm4,%xmm3
        addpd  %xmm5,%xmm3
    addpd  %xmm7,%xmm6
    addpd  %xmm8,%xmm6

        ## start doing invsqrt for jH1 atoms
    cvtpd2ps %xmm0,%xmm1
    cvtpd2ps %xmm3,%xmm4
    cvtpd2ps %xmm6,%xmm7
        rsqrtps %xmm1,%xmm1
        rsqrtps %xmm4,%xmm4
    rsqrtps %xmm7,%xmm7
    cvtps2pd %xmm1,%xmm1
    cvtps2pd %xmm4,%xmm4
    cvtps2pd %xmm7,%xmm7

        movapd  %xmm1,%xmm2
        movapd  %xmm4,%xmm5
    movapd  %xmm7,%xmm8

        mulpd   %xmm1,%xmm1 ## lu*lu
        mulpd   %xmm4,%xmm4 ## lu*lu
    mulpd   %xmm7,%xmm7 ## lu*lu

        movapd  nb114_three(%rsp),%xmm9
        movapd  %xmm9,%xmm10
    movapd  %xmm9,%xmm11

        mulpd   %xmm0,%xmm1 ## rsq*lu*lu
        mulpd   %xmm3,%xmm4 ## rsq*lu*lu 
    mulpd   %xmm6,%xmm7 ## rsq*lu*lu

        subpd   %xmm1,%xmm9
        subpd   %xmm4,%xmm10
    subpd   %xmm7,%xmm11 ## 3-rsq*lu*lu

        mulpd   %xmm2,%xmm9
        mulpd   %xmm5,%xmm10
    mulpd   %xmm8,%xmm11 ## lu*(3-rsq*lu*lu)

        movapd  nb114_half(%rsp),%xmm15
        mulpd   %xmm15,%xmm9 ## first iteration for rinvH1H1 
        mulpd   %xmm15,%xmm10 ## first iteration for rinvH2H1
    mulpd   %xmm15,%xmm11 ## first iteration for rinvMH1 

    ## second iteration step    
        movapd  %xmm9,%xmm2
        movapd  %xmm10,%xmm5
    movapd  %xmm11,%xmm8

        mulpd   %xmm2,%xmm2 ## lu*lu
        mulpd   %xmm5,%xmm5 ## lu*lu
    mulpd   %xmm8,%xmm8 ## lu*lu

        movapd  nb114_three(%rsp),%xmm1
        movapd  %xmm1,%xmm4
    movapd  %xmm1,%xmm7

        mulpd   %xmm0,%xmm2 ## rsq*lu*lu
        mulpd   %xmm3,%xmm5 ## rsq*lu*lu 
    mulpd   %xmm6,%xmm8 ## rsq*lu*lu

        subpd   %xmm2,%xmm1
        subpd   %xmm5,%xmm4
    subpd   %xmm8,%xmm7 ## 3-rsq*lu*lu

        mulpd   %xmm1,%xmm9
        mulpd   %xmm4,%xmm10
    mulpd   %xmm7,%xmm11 ## lu*(3-rsq*lu*lu)

        movapd  nb114_half(%rsp),%xmm15
        mulpd   %xmm15,%xmm9 ##  rinvH1H1 
        mulpd   %xmm15,%xmm10 ##   rinvH2H1
    mulpd   %xmm15,%xmm11 ##   rinvMH1

        ## H1 interactions 
    movapd %xmm9,%xmm0
    movapd %xmm10,%xmm1
    movapd %xmm11,%xmm2
    mulpd  %xmm9,%xmm9
    mulpd  %xmm10,%xmm10
    mulpd  %xmm11,%xmm11
    mulpd  nb114_qqHH(%rsp),%xmm0
    mulpd  nb114_qqHH(%rsp),%xmm1
    mulpd  nb114_qqMH(%rsp),%xmm2
    mulpd  %xmm0,%xmm9
    mulpd  %xmm1,%xmm10
    mulpd  %xmm2,%xmm11

    addpd nb114_vctot(%rsp),%xmm0
    addpd %xmm2,%xmm1
    addpd %xmm1,%xmm0
    movapd %xmm0,nb114_vctot(%rsp)

    ## move j H1 forces to xmm0-xmm2
        movq   nb114_faction(%rbp),%rdi
        movlpd 24(%rdi,%rax,8),%xmm0
        movlpd 32(%rdi,%rax,8),%xmm1
        movlpd 40(%rdi,%rax,8),%xmm2
        movhpd 24(%rdi,%rbx,8),%xmm0
        movhpd 32(%rdi,%rbx,8),%xmm1
        movhpd 40(%rdi,%rbx,8),%xmm2

    movapd %xmm9,%xmm7
    movapd %xmm9,%xmm8
    movapd %xmm11,%xmm13
    movapd %xmm11,%xmm14
    movapd %xmm11,%xmm15
    movapd %xmm10,%xmm11
    movapd %xmm10,%xmm12

        mulpd nb114_dxH1H1(%rsp),%xmm7
        mulpd nb114_dyH1H1(%rsp),%xmm8
        mulpd nb114_dzH1H1(%rsp),%xmm9
        mulpd nb114_dxH2H1(%rsp),%xmm10
        mulpd nb114_dyH2H1(%rsp),%xmm11
        mulpd nb114_dzH2H1(%rsp),%xmm12
        mulpd nb114_dxMH1(%rsp),%xmm13
        mulpd nb114_dyMH1(%rsp),%xmm14
        mulpd nb114_dzMH1(%rsp),%xmm15

    addpd %xmm7,%xmm0
    addpd %xmm8,%xmm1
    addpd %xmm9,%xmm2
    addpd nb114_fixH1(%rsp),%xmm7
    addpd nb114_fiyH1(%rsp),%xmm8
    addpd nb114_fizH1(%rsp),%xmm9

    addpd %xmm10,%xmm0
    addpd %xmm11,%xmm1
    addpd %xmm12,%xmm2
    addpd nb114_fixH2(%rsp),%xmm10
    addpd nb114_fiyH2(%rsp),%xmm11
    addpd nb114_fizH2(%rsp),%xmm12

    addpd %xmm13,%xmm0
    addpd %xmm14,%xmm1
    addpd %xmm15,%xmm2
    addpd nb114_fixM(%rsp),%xmm13
    addpd nb114_fiyM(%rsp),%xmm14
    addpd nb114_fizM(%rsp),%xmm15

    movapd %xmm7,nb114_fixH1(%rsp)
    movapd %xmm8,nb114_fiyH1(%rsp)
    movapd %xmm9,nb114_fizH1(%rsp)
    movapd %xmm10,nb114_fixH2(%rsp)
    movapd %xmm11,nb114_fiyH2(%rsp)
    movapd %xmm12,nb114_fizH2(%rsp)
    movapd %xmm13,nb114_fixM(%rsp)
    movapd %xmm14,nb114_fiyM(%rsp)
    movapd %xmm15,nb114_fizM(%rsp)

    ## store back j H1 forces from xmm0-xmm2
        movlpd %xmm0,24(%rdi,%rax,8)
        movlpd %xmm1,32(%rdi,%rax,8)
        movlpd %xmm2,40(%rdi,%rax,8)
        movhpd %xmm0,24(%rdi,%rbx,8)
        movhpd %xmm1,32(%rdi,%rbx,8)
        movhpd %xmm2,40(%rdi,%rbx,8)

        ## move j H2 coordinates to local temp variables 
        movq   nb114_pos(%rbp),%rsi
    movlpd 48(%rsi,%rax,8),%xmm0
    movlpd 56(%rsi,%rax,8),%xmm1
    movlpd 64(%rsi,%rax,8),%xmm2
    movhpd 48(%rsi,%rbx,8),%xmm0
    movhpd 56(%rsi,%rbx,8),%xmm1
    movhpd 64(%rsi,%rbx,8),%xmm2

    ## xmm0 = H2x
    ## xmm1 = H2y
    ## xmm2 = H2z

    movapd %xmm0,%xmm3
    movapd %xmm1,%xmm4
    movapd %xmm2,%xmm5
    movapd %xmm0,%xmm6
    movapd %xmm1,%xmm7
    movapd %xmm2,%xmm8

    subpd nb114_ixH1(%rsp),%xmm0
    subpd nb114_iyH1(%rsp),%xmm1
    subpd nb114_izH1(%rsp),%xmm2
    subpd nb114_ixH2(%rsp),%xmm3
    subpd nb114_iyH2(%rsp),%xmm4
    subpd nb114_izH2(%rsp),%xmm5
    subpd nb114_ixM(%rsp),%xmm6
    subpd nb114_iyM(%rsp),%xmm7
    subpd nb114_izM(%rsp),%xmm8

        movapd %xmm0,nb114_dxH1H2(%rsp)
        movapd %xmm1,nb114_dyH1H2(%rsp)
        movapd %xmm2,nb114_dzH1H2(%rsp)
        mulpd  %xmm0,%xmm0
        mulpd  %xmm1,%xmm1
        mulpd  %xmm2,%xmm2
        movapd %xmm3,nb114_dxH2H2(%rsp)
        movapd %xmm4,nb114_dyH2H2(%rsp)
        movapd %xmm5,nb114_dzH2H2(%rsp)
        mulpd  %xmm3,%xmm3
        mulpd  %xmm4,%xmm4
        mulpd  %xmm5,%xmm5
        movapd %xmm6,nb114_dxMH2(%rsp)
        movapd %xmm7,nb114_dyMH2(%rsp)
        movapd %xmm8,nb114_dzMH2(%rsp)
        mulpd  %xmm6,%xmm6
        mulpd  %xmm7,%xmm7
        mulpd  %xmm8,%xmm8
        addpd  %xmm1,%xmm0
        addpd  %xmm2,%xmm0
        addpd  %xmm4,%xmm3
        addpd  %xmm5,%xmm3
    addpd  %xmm7,%xmm6
    addpd  %xmm8,%xmm6

        ## start doing invsqrt for jH2 atoms
    cvtpd2ps %xmm0,%xmm1
    cvtpd2ps %xmm3,%xmm4
    cvtpd2ps %xmm6,%xmm7
        rsqrtps %xmm1,%xmm1
        rsqrtps %xmm4,%xmm4
    rsqrtps %xmm7,%xmm7
    cvtps2pd %xmm1,%xmm1
    cvtps2pd %xmm4,%xmm4
    cvtps2pd %xmm7,%xmm7

        movapd  %xmm1,%xmm2
        movapd  %xmm4,%xmm5
    movapd  %xmm7,%xmm8

        mulpd   %xmm1,%xmm1 ## lu*lu
        mulpd   %xmm4,%xmm4 ## lu*lu
    mulpd   %xmm7,%xmm7 ## lu*lu

        movapd  nb114_three(%rsp),%xmm9
        movapd  %xmm9,%xmm10
    movapd  %xmm9,%xmm11

        mulpd   %xmm0,%xmm1 ## rsq*lu*lu
        mulpd   %xmm3,%xmm4 ## rsq*lu*lu 
    mulpd   %xmm6,%xmm7 ## rsq*lu*lu

        subpd   %xmm1,%xmm9
        subpd   %xmm4,%xmm10
    subpd   %xmm7,%xmm11 ## 3-rsq*lu*lu

        mulpd   %xmm2,%xmm9
        mulpd   %xmm5,%xmm10
    mulpd   %xmm8,%xmm11 ## lu*(3-rsq*lu*lu)

        movapd  nb114_half(%rsp),%xmm15
        mulpd   %xmm15,%xmm9 ## first iteration for rinvH1H2 
        mulpd   %xmm15,%xmm10 ## first iteration for rinvH2H2
    mulpd   %xmm15,%xmm11 ## first iteration for rinvMH1H2

    ## second iteration step    
        movapd  %xmm9,%xmm2
        movapd  %xmm10,%xmm5
    movapd  %xmm11,%xmm8

        mulpd   %xmm2,%xmm2 ## lu*lu
        mulpd   %xmm5,%xmm5 ## lu*lu
    mulpd   %xmm8,%xmm8 ## lu*lu

        movapd  nb114_three(%rsp),%xmm1
        movapd  %xmm1,%xmm4
    movapd  %xmm1,%xmm7

        mulpd   %xmm0,%xmm2 ## rsq*lu*lu
        mulpd   %xmm3,%xmm5 ## rsq*lu*lu 
    mulpd   %xmm6,%xmm8 ## rsq*lu*lu

        subpd   %xmm2,%xmm1
        subpd   %xmm5,%xmm4
    subpd   %xmm8,%xmm7 ## 3-rsq*lu*lu

        mulpd   %xmm1,%xmm9
        mulpd   %xmm4,%xmm10
    mulpd   %xmm7,%xmm11 ## lu*(3-rsq*lu*lu)

        movapd  nb114_half(%rsp),%xmm15
        mulpd   %xmm15,%xmm9 ##  rinvH1H2
        mulpd   %xmm15,%xmm10 ##   rinvH2H2
    mulpd   %xmm15,%xmm11 ##   rinvMH2

        ## H2 interactions 
    movapd %xmm9,%xmm0
    movapd %xmm10,%xmm1
    movapd %xmm11,%xmm2
    mulpd  %xmm9,%xmm9
    mulpd  %xmm10,%xmm10
    mulpd  %xmm11,%xmm11
    mulpd  nb114_qqHH(%rsp),%xmm0
    mulpd  nb114_qqHH(%rsp),%xmm1
    mulpd  nb114_qqMH(%rsp),%xmm2
    mulpd  %xmm0,%xmm9
    mulpd  %xmm1,%xmm10
    mulpd  %xmm2,%xmm11

    addpd nb114_vctot(%rsp),%xmm0
    addpd %xmm2,%xmm1
    addpd %xmm1,%xmm0
    movapd %xmm0,nb114_vctot(%rsp)

    ## move j H2 forces to xmm0-xmm2
        movq   nb114_faction(%rbp),%rdi
        movlpd 48(%rdi,%rax,8),%xmm0
        movlpd 56(%rdi,%rax,8),%xmm1
        movlpd 64(%rdi,%rax,8),%xmm2
        movhpd 48(%rdi,%rbx,8),%xmm0
        movhpd 56(%rdi,%rbx,8),%xmm1
        movhpd 64(%rdi,%rbx,8),%xmm2

    movapd %xmm9,%xmm7
    movapd %xmm9,%xmm8
    movapd %xmm11,%xmm13
    movapd %xmm11,%xmm14
    movapd %xmm11,%xmm15
    movapd %xmm10,%xmm11
    movapd %xmm10,%xmm12

        mulpd nb114_dxH1H2(%rsp),%xmm7
        mulpd nb114_dyH1H2(%rsp),%xmm8
        mulpd nb114_dzH1H2(%rsp),%xmm9
        mulpd nb114_dxH2H2(%rsp),%xmm10
        mulpd nb114_dyH2H2(%rsp),%xmm11
        mulpd nb114_dzH2H2(%rsp),%xmm12
        mulpd nb114_dxMH2(%rsp),%xmm13
        mulpd nb114_dyMH2(%rsp),%xmm14
        mulpd nb114_dzMH2(%rsp),%xmm15

    addpd %xmm7,%xmm0
    addpd %xmm8,%xmm1
    addpd %xmm9,%xmm2
    addpd nb114_fixH1(%rsp),%xmm7
    addpd nb114_fiyH1(%rsp),%xmm8
    addpd nb114_fizH1(%rsp),%xmm9

    addpd %xmm10,%xmm0
    addpd %xmm11,%xmm1
    addpd %xmm12,%xmm2
    addpd nb114_fixH2(%rsp),%xmm10
    addpd nb114_fiyH2(%rsp),%xmm11
    addpd nb114_fizH2(%rsp),%xmm12

    addpd %xmm13,%xmm0
    addpd %xmm14,%xmm1
    addpd %xmm15,%xmm2
    addpd nb114_fixM(%rsp),%xmm13
    addpd nb114_fiyM(%rsp),%xmm14
    addpd nb114_fizM(%rsp),%xmm15

    movapd %xmm7,nb114_fixH1(%rsp)
    movapd %xmm8,nb114_fiyH1(%rsp)
    movapd %xmm9,nb114_fizH1(%rsp)
    movapd %xmm10,nb114_fixH2(%rsp)
    movapd %xmm11,nb114_fiyH2(%rsp)
    movapd %xmm12,nb114_fizH2(%rsp)
    movapd %xmm13,nb114_fixM(%rsp)
    movapd %xmm14,nb114_fiyM(%rsp)
    movapd %xmm15,nb114_fizM(%rsp)

    ## store back j H2 forces from xmm0-xmm2
        movlpd %xmm0,48(%rdi,%rax,8)
        movlpd %xmm1,56(%rdi,%rax,8)
        movlpd %xmm2,64(%rdi,%rax,8)
        movhpd %xmm0,48(%rdi,%rbx,8)
        movhpd %xmm1,56(%rdi,%rbx,8)
        movhpd %xmm2,64(%rdi,%rbx,8)

        ## move j M coordinates to local temp variables 
        movq   nb114_pos(%rbp),%rsi
    movlpd 72(%rsi,%rax,8),%xmm0
    movlpd 80(%rsi,%rax,8),%xmm1
    movlpd 88(%rsi,%rax,8),%xmm2
    movhpd 72(%rsi,%rbx,8),%xmm0
    movhpd 80(%rsi,%rbx,8),%xmm1
    movhpd 88(%rsi,%rbx,8),%xmm2

    ## xmm0 = Mx
    ## xmm1 = My
    ## xmm2 = Mz

    movapd %xmm0,%xmm3
    movapd %xmm1,%xmm4
    movapd %xmm2,%xmm5
    movapd %xmm0,%xmm6
    movapd %xmm1,%xmm7
    movapd %xmm2,%xmm8

    subpd nb114_ixH1(%rsp),%xmm0
    subpd nb114_iyH1(%rsp),%xmm1
    subpd nb114_izH1(%rsp),%xmm2
    subpd nb114_ixH2(%rsp),%xmm3
    subpd nb114_iyH2(%rsp),%xmm4
    subpd nb114_izH2(%rsp),%xmm5
    subpd nb114_ixM(%rsp),%xmm6
    subpd nb114_iyM(%rsp),%xmm7
    subpd nb114_izM(%rsp),%xmm8

        movapd %xmm0,nb114_dxH1M(%rsp)
        movapd %xmm1,nb114_dyH1M(%rsp)
        movapd %xmm2,nb114_dzH1M(%rsp)
        mulpd  %xmm0,%xmm0
        mulpd  %xmm1,%xmm1
        mulpd  %xmm2,%xmm2
        movapd %xmm3,nb114_dxH2M(%rsp)
        movapd %xmm4,nb114_dyH2M(%rsp)
        movapd %xmm5,nb114_dzH2M(%rsp)
        mulpd  %xmm3,%xmm3
        mulpd  %xmm4,%xmm4
        mulpd  %xmm5,%xmm5
        movapd %xmm6,nb114_dxMM(%rsp)
        movapd %xmm7,nb114_dyMM(%rsp)
        movapd %xmm8,nb114_dzMM(%rsp)
        mulpd  %xmm6,%xmm6
        mulpd  %xmm7,%xmm7
        mulpd  %xmm8,%xmm8
        addpd  %xmm1,%xmm0
        addpd  %xmm2,%xmm0
        addpd  %xmm4,%xmm3
        addpd  %xmm5,%xmm3
    addpd  %xmm7,%xmm6
    addpd  %xmm8,%xmm6

        ## start doing invsqrt for jM atoms
    cvtpd2ps %xmm0,%xmm1
    cvtpd2ps %xmm3,%xmm4
    cvtpd2ps %xmm6,%xmm7
        rsqrtps %xmm1,%xmm1
        rsqrtps %xmm4,%xmm4
    rsqrtps %xmm7,%xmm7
    cvtps2pd %xmm1,%xmm1
    cvtps2pd %xmm4,%xmm4
    cvtps2pd %xmm7,%xmm7

        movapd  %xmm1,%xmm2
        movapd  %xmm4,%xmm5
    movapd  %xmm7,%xmm8

        mulpd   %xmm1,%xmm1 ## lu*lu
        mulpd   %xmm4,%xmm4 ## lu*lu
    mulpd   %xmm7,%xmm7 ## lu*lu

        movapd  nb114_three(%rsp),%xmm9
        movapd  %xmm9,%xmm10
    movapd  %xmm9,%xmm11

        mulpd   %xmm0,%xmm1 ## rsq*lu*lu
        mulpd   %xmm3,%xmm4 ## rsq*lu*lu 
    mulpd   %xmm6,%xmm7 ## rsq*lu*lu

        subpd   %xmm1,%xmm9
        subpd   %xmm4,%xmm10
    subpd   %xmm7,%xmm11 ## 3-rsq*lu*lu

        mulpd   %xmm2,%xmm9
        mulpd   %xmm5,%xmm10
    mulpd   %xmm8,%xmm11 ## lu*(3-rsq*lu*lu)

        movapd  nb114_half(%rsp),%xmm15
        mulpd   %xmm15,%xmm9 ## first iteration for rinvH1M 
        mulpd   %xmm15,%xmm10 ## first iteration for rinvH2M
    mulpd   %xmm15,%xmm11 ## first iteration for rinvMM

    ## second iteration step    
        movapd  %xmm9,%xmm2
        movapd  %xmm10,%xmm5
    movapd  %xmm11,%xmm8

        mulpd   %xmm2,%xmm2 ## lu*lu
        mulpd   %xmm5,%xmm5 ## lu*lu
    mulpd   %xmm8,%xmm8 ## lu*lu

        movapd  nb114_three(%rsp),%xmm1
        movapd  %xmm1,%xmm4
    movapd  %xmm1,%xmm7

        mulpd   %xmm0,%xmm2 ## rsq*lu*lu
        mulpd   %xmm3,%xmm5 ## rsq*lu*lu 
    mulpd   %xmm6,%xmm8 ## rsq*lu*lu

        subpd   %xmm2,%xmm1
        subpd   %xmm5,%xmm4
    subpd   %xmm8,%xmm7 ## 3-rsq*lu*lu

        mulpd   %xmm1,%xmm9
        mulpd   %xmm4,%xmm10
    mulpd   %xmm7,%xmm11 ## lu*(3-rsq*lu*lu)

        movapd  nb114_half(%rsp),%xmm15
        mulpd   %xmm15,%xmm9 ##  rinvH1M
        mulpd   %xmm15,%xmm10 ##   rinvH2M
    mulpd   %xmm15,%xmm11 ##   rinvMM

        ## M interactions 
    movapd %xmm9,%xmm0
    movapd %xmm10,%xmm1
    movapd %xmm11,%xmm2
    mulpd  %xmm9,%xmm9
    mulpd  %xmm10,%xmm10
    mulpd  %xmm11,%xmm11
    mulpd  nb114_qqMH(%rsp),%xmm0
    mulpd  nb114_qqMH(%rsp),%xmm1
    mulpd  nb114_qqMM(%rsp),%xmm2
    mulpd  %xmm0,%xmm9
    mulpd  %xmm1,%xmm10
    mulpd  %xmm2,%xmm11

    addpd nb114_vctot(%rsp),%xmm0
    addpd %xmm2,%xmm1
    addpd %xmm1,%xmm0
    movapd %xmm0,nb114_vctot(%rsp)

    ## move j M forces to xmm0-xmm2
        movq   nb114_faction(%rbp),%rdi
        movlpd 72(%rdi,%rax,8),%xmm0
        movlpd 80(%rdi,%rax,8),%xmm1
        movlpd 88(%rdi,%rax,8),%xmm2
        movhpd 72(%rdi,%rbx,8),%xmm0
        movhpd 80(%rdi,%rbx,8),%xmm1
        movhpd 88(%rdi,%rbx,8),%xmm2

    movapd %xmm9,%xmm7
    movapd %xmm9,%xmm8
    movapd %xmm11,%xmm13
    movapd %xmm11,%xmm14
    movapd %xmm11,%xmm15
    movapd %xmm10,%xmm11
    movapd %xmm10,%xmm12

        mulpd nb114_dxH1M(%rsp),%xmm7
        mulpd nb114_dyH1M(%rsp),%xmm8
        mulpd nb114_dzH1M(%rsp),%xmm9
        mulpd nb114_dxH2M(%rsp),%xmm10
        mulpd nb114_dyH2M(%rsp),%xmm11
        mulpd nb114_dzH2M(%rsp),%xmm12
        mulpd nb114_dxMM(%rsp),%xmm13
        mulpd nb114_dyMM(%rsp),%xmm14
        mulpd nb114_dzMM(%rsp),%xmm15

    addpd %xmm7,%xmm0
    addpd %xmm8,%xmm1
    addpd %xmm9,%xmm2
    addpd nb114_fixH1(%rsp),%xmm7
    addpd nb114_fiyH1(%rsp),%xmm8
    addpd nb114_fizH1(%rsp),%xmm9

    addpd %xmm10,%xmm0
    addpd %xmm11,%xmm1
    addpd %xmm12,%xmm2
    addpd nb114_fixH2(%rsp),%xmm10
    addpd nb114_fiyH2(%rsp),%xmm11
    addpd nb114_fizH2(%rsp),%xmm12

    addpd %xmm13,%xmm0
    addpd %xmm14,%xmm1
    addpd %xmm15,%xmm2
    addpd nb114_fixM(%rsp),%xmm13
    addpd nb114_fiyM(%rsp),%xmm14
    addpd nb114_fizM(%rsp),%xmm15

    movapd %xmm7,nb114_fixH1(%rsp)
    movapd %xmm8,nb114_fiyH1(%rsp)
    movapd %xmm9,nb114_fizH1(%rsp)
    movapd %xmm10,nb114_fixH2(%rsp)
    movapd %xmm11,nb114_fiyH2(%rsp)
    movapd %xmm12,nb114_fizH2(%rsp)
    movapd %xmm13,nb114_fixM(%rsp)
    movapd %xmm14,nb114_fiyM(%rsp)
    movapd %xmm15,nb114_fizM(%rsp)

    ## store back j M forces from xmm0-xmm2
        movlpd %xmm0,72(%rdi,%rax,8)
        movlpd %xmm1,80(%rdi,%rax,8)
        movlpd %xmm2,88(%rdi,%rax,8)
        movhpd %xmm0,72(%rdi,%rbx,8)
        movhpd %xmm1,80(%rdi,%rbx,8)
        movhpd %xmm2,88(%rdi,%rbx,8)

        ## should we do one more iteration? 
        subl $2,nb114_innerk(%rsp)
        jl    _nb_kernel114_x86_64_sse2.nb114_checksingle
        jmp   _nb_kernel114_x86_64_sse2.nb114_unroll_loop
_nb_kernel114_x86_64_sse2.nb114_checksingle: 
        movl  nb114_innerk(%rsp),%edx
        andl  $1,%edx
        jnz   _nb_kernel114_x86_64_sse2.nb114_dosingle
        jmp   _nb_kernel114_x86_64_sse2.nb114_updateouterdata
_nb_kernel114_x86_64_sse2.nb114_dosingle: 
        movq  nb114_innerjjnr(%rsp),%rdx       ## pointer to jjnr[k] 
        movl  (%rdx),%eax

        movq nb114_pos(%rbp),%rsi
        lea  (%rax,%rax,2),%rax

        ## load j O coordinates
    movsd (%rsi,%rax,8),%xmm4
    movsd 8(%rsi,%rax,8),%xmm5
    movsd 16(%rsi,%rax,8),%xmm6

    ## xmm4 = Ox
    ## xmm5 = Oy
    ## xmm6 = Oz

    subsd nb114_ixO(%rsp),%xmm4
    subsd nb114_iyO(%rsp),%xmm5
    subsd nb114_izO(%rsp),%xmm6

    ## store dx/dy/dz
    movapd %xmm4,%xmm9
    movapd %xmm5,%xmm10
    movapd %xmm6,%xmm11

        ## square it 
        mulsd %xmm4,%xmm4
        mulsd %xmm5,%xmm5
        mulsd %xmm6,%xmm6
        addsd %xmm5,%xmm4
        addsd %xmm6,%xmm4       ## rsq in xmm4 

        cvtsd2ss %xmm4,%xmm6
        rcpss %xmm6,%xmm6
        cvtss2sd %xmm6,%xmm6    ## lu in low xmm6 

        ## 1/x lookup seed in xmm6 
        movapd nb114_two(%rsp),%xmm0
        movapd %xmm4,%xmm5
        mulsd %xmm6,%xmm4       ## lu*rsq 
        subsd %xmm4,%xmm0       ## 2-lu*rsq 
        mulsd %xmm0,%xmm6       ## (new lu) 

        movapd nb114_two(%rsp),%xmm0
        mulsd %xmm6,%xmm5       ## lu*rsq 
        subsd %xmm5,%xmm0       ## 2-lu*rsq 
        mulsd %xmm6,%xmm0       ## xmm0=rinvsq 

        movapd %xmm0,%xmm1
        mulsd  %xmm0,%xmm1
        mulsd  %xmm0,%xmm1      ## xmm1=rinvsix 
        movapd %xmm1,%xmm2
        mulsd  %xmm2,%xmm2      ## xmm2=rinvtwelve 

        mulsd  nb114_c6(%rsp),%xmm1     ## mult by c6
        mulsd  nb114_c12(%rsp),%xmm2     ## mult by c12
        movapd %xmm2,%xmm5
        subsd  %xmm1,%xmm5      ## Vvdw=Vvdw12-Vvdw6 
        mulsd  nb114_six(%rsp),%xmm1
        mulsd  nb114_twelve(%rsp),%xmm2
        subsd  %xmm1,%xmm2
        mulsd  %xmm2,%xmm0      ## xmm0=total fscal 

    ## increment potential
    addsd  nb114_Vvdwtot(%rsp),%xmm5
    movsd %xmm5,nb114_Vvdwtot(%rsp)

        movq   nb114_faction(%rbp),%rdi
        mulsd  %xmm0,%xmm9
        mulsd  %xmm0,%xmm10
        mulsd  %xmm0,%xmm11

    movapd nb114_fixO(%rsp),%xmm0
    movapd nb114_fiyO(%rsp),%xmm1
    movapd nb114_fizO(%rsp),%xmm2

    ## accumulate i forces
    addsd %xmm9,%xmm0
    addsd %xmm10,%xmm1
    addsd %xmm11,%xmm2
    movsd %xmm0,nb114_fixO(%rsp)
    movsd %xmm1,nb114_fiyO(%rsp)
    movsd %xmm2,nb114_fizO(%rsp)

        addsd (%rdi,%rax,8),%xmm9
        addsd 8(%rdi,%rax,8),%xmm10
        addsd 16(%rdi,%rax,8),%xmm11
        movsd %xmm9,(%rdi,%rax,8)
        movsd %xmm10,8(%rdi,%rax,8)
        movsd %xmm11,16(%rdi,%rax,8)

    ## done with OO interaction

        ## move j H1 coordinates to local temp variables 
    movsd 24(%rsi,%rax,8),%xmm0
    movsd 32(%rsi,%rax,8),%xmm1
    movsd 40(%rsi,%rax,8),%xmm2

    ## xmm0 = H1x
    ## xmm1 = H1y
    ## xmm2 = H1z

    movsd %xmm0,%xmm3
    movsd %xmm1,%xmm4
    movsd %xmm2,%xmm5
    movsd %xmm0,%xmm6
    movsd %xmm1,%xmm7
    movsd %xmm2,%xmm8

    subsd nb114_ixH1(%rsp),%xmm0
    subsd nb114_iyH1(%rsp),%xmm1
    subsd nb114_izH1(%rsp),%xmm2
    subsd nb114_ixH2(%rsp),%xmm3
    subsd nb114_iyH2(%rsp),%xmm4
    subsd nb114_izH2(%rsp),%xmm5
    subsd nb114_ixM(%rsp),%xmm6
    subsd nb114_iyM(%rsp),%xmm7
    subsd nb114_izM(%rsp),%xmm8

        movsd %xmm0,nb114_dxH1H1(%rsp)
        movsd %xmm1,nb114_dyH1H1(%rsp)
        movsd %xmm2,nb114_dzH1H1(%rsp)
        mulsd  %xmm0,%xmm0
        mulsd  %xmm1,%xmm1
        mulsd  %xmm2,%xmm2
        movsd %xmm3,nb114_dxH2H1(%rsp)
        movsd %xmm4,nb114_dyH2H1(%rsp)
        movsd %xmm5,nb114_dzH2H1(%rsp)
        mulsd  %xmm3,%xmm3
        mulsd  %xmm4,%xmm4
        mulsd  %xmm5,%xmm5
        movsd %xmm6,nb114_dxMH1(%rsp)
        movsd %xmm7,nb114_dyMH1(%rsp)
        movsd %xmm8,nb114_dzMH1(%rsp)
        mulsd  %xmm6,%xmm6
        mulsd  %xmm7,%xmm7
        mulsd  %xmm8,%xmm8
        addsd  %xmm1,%xmm0
        addsd  %xmm2,%xmm0
        addsd  %xmm4,%xmm3
        addsd  %xmm5,%xmm3
    addsd  %xmm7,%xmm6
    addsd  %xmm8,%xmm6

        ## start doing invsqrt for jH1 atoms
    cvtsd2ss %xmm0,%xmm1
    cvtsd2ss %xmm3,%xmm4
    cvtsd2ss %xmm6,%xmm7
        rsqrtss %xmm1,%xmm1
        rsqrtss %xmm4,%xmm4
    rsqrtss %xmm7,%xmm7
    cvtss2sd %xmm1,%xmm1
    cvtss2sd %xmm4,%xmm4
    cvtss2sd %xmm7,%xmm7

        movsd  %xmm1,%xmm2
        movsd  %xmm4,%xmm5
    movsd  %xmm7,%xmm8

        mulsd   %xmm1,%xmm1 ## lu*lu
        mulsd   %xmm4,%xmm4 ## lu*lu
    mulsd   %xmm7,%xmm7 ## lu*lu

        movsd  nb114_three(%rsp),%xmm9
        movsd  %xmm9,%xmm10
    movsd  %xmm9,%xmm11

        mulsd   %xmm0,%xmm1 ## rsq*lu*lu
        mulsd   %xmm3,%xmm4 ## rsq*lu*lu 
    mulsd   %xmm6,%xmm7 ## rsq*lu*lu

        subsd   %xmm1,%xmm9
        subsd   %xmm4,%xmm10
    subsd   %xmm7,%xmm11 ## 3-rsq*lu*lu

        mulsd   %xmm2,%xmm9
        mulsd   %xmm5,%xmm10
    mulsd   %xmm8,%xmm11 ## lu*(3-rsq*lu*lu)

        movsd  nb114_half(%rsp),%xmm15
        mulsd   %xmm15,%xmm9 ## first iteration for rinvH1H1 
        mulsd   %xmm15,%xmm10 ## first iteration for rinvH2H1
    mulsd   %xmm15,%xmm11 ## first iteration for rinvMH1 

    ## second iteration step    
        movsd  %xmm9,%xmm2
        movsd  %xmm10,%xmm5
    movsd  %xmm11,%xmm8

        mulsd   %xmm2,%xmm2 ## lu*lu
        mulsd   %xmm5,%xmm5 ## lu*lu
    mulsd   %xmm8,%xmm8 ## lu*lu

        movsd  nb114_three(%rsp),%xmm1
        movsd  %xmm1,%xmm4
    movsd  %xmm1,%xmm7

        mulsd   %xmm0,%xmm2 ## rsq*lu*lu
        mulsd   %xmm3,%xmm5 ## rsq*lu*lu 
    mulsd   %xmm6,%xmm8 ## rsq*lu*lu

        subsd   %xmm2,%xmm1
        subsd   %xmm5,%xmm4
    subsd   %xmm8,%xmm7 ## 3-rsq*lu*lu

        mulsd   %xmm1,%xmm9
        mulsd   %xmm4,%xmm10
    mulsd   %xmm7,%xmm11 ## lu*(3-rsq*lu*lu)

        movsd  nb114_half(%rsp),%xmm15
        mulsd   %xmm15,%xmm9 ##  rinvH1H1 
        mulsd   %xmm15,%xmm10 ##   rinvH2H1
    mulsd   %xmm15,%xmm11 ##   rinvMH1

        ## H1 interactions 
    movsd %xmm9,%xmm0
    movsd %xmm10,%xmm1
    movsd %xmm11,%xmm2
    mulsd  %xmm9,%xmm9
    mulsd  %xmm10,%xmm10
    mulsd  %xmm11,%xmm11
    mulsd  nb114_qqHH(%rsp),%xmm0
    mulsd  nb114_qqHH(%rsp),%xmm1
    mulsd  nb114_qqMH(%rsp),%xmm2
    mulsd  %xmm0,%xmm9
    mulsd  %xmm1,%xmm10
    mulsd  %xmm2,%xmm11

    addsd nb114_vctot(%rsp),%xmm0
    addsd %xmm2,%xmm1
    addsd %xmm1,%xmm0
    movsd %xmm0,nb114_vctot(%rsp)

    ## move j H1 forces to xmm0-xmm2
        movsd 24(%rdi,%rax,8),%xmm0
        movsd 32(%rdi,%rax,8),%xmm1
        movsd 40(%rdi,%rax,8),%xmm2

    movsd %xmm9,%xmm7
    movsd %xmm9,%xmm8
    movsd %xmm11,%xmm13
    movsd %xmm11,%xmm14
    movsd %xmm11,%xmm15
    movsd %xmm10,%xmm11
    movsd %xmm10,%xmm12

        mulsd nb114_dxH1H1(%rsp),%xmm7
        mulsd nb114_dyH1H1(%rsp),%xmm8
        mulsd nb114_dzH1H1(%rsp),%xmm9
        mulsd nb114_dxH2H1(%rsp),%xmm10
        mulsd nb114_dyH2H1(%rsp),%xmm11
        mulsd nb114_dzH2H1(%rsp),%xmm12
        mulsd nb114_dxMH1(%rsp),%xmm13
        mulsd nb114_dyMH1(%rsp),%xmm14
        mulsd nb114_dzMH1(%rsp),%xmm15

    addsd %xmm7,%xmm0
    addsd %xmm8,%xmm1
    addsd %xmm9,%xmm2
    addsd nb114_fixH1(%rsp),%xmm7
    addsd nb114_fiyH1(%rsp),%xmm8
    addsd nb114_fizH1(%rsp),%xmm9

    addsd %xmm10,%xmm0
    addsd %xmm11,%xmm1
    addsd %xmm12,%xmm2
    addsd nb114_fixH2(%rsp),%xmm10
    addsd nb114_fiyH2(%rsp),%xmm11
    addsd nb114_fizH2(%rsp),%xmm12

    addsd %xmm13,%xmm0
    addsd %xmm14,%xmm1
    addsd %xmm15,%xmm2
    addsd nb114_fixM(%rsp),%xmm13
    addsd nb114_fiyM(%rsp),%xmm14
    addsd nb114_fizM(%rsp),%xmm15

    movsd %xmm7,nb114_fixH1(%rsp)
    movsd %xmm8,nb114_fiyH1(%rsp)
    movsd %xmm9,nb114_fizH1(%rsp)
    movsd %xmm10,nb114_fixH2(%rsp)
    movsd %xmm11,nb114_fiyH2(%rsp)
    movsd %xmm12,nb114_fizH2(%rsp)
    movsd %xmm13,nb114_fixM(%rsp)
    movsd %xmm14,nb114_fiyM(%rsp)
    movsd %xmm15,nb114_fizM(%rsp)

    ## store back j H1 forces from xmm0-xmm2
        movsd %xmm0,24(%rdi,%rax,8)
        movsd %xmm1,32(%rdi,%rax,8)
        movsd %xmm2,40(%rdi,%rax,8)

        ## move j H2 coordinates to local temp variables 
    movsd 48(%rsi,%rax,8),%xmm0
    movsd 56(%rsi,%rax,8),%xmm1
    movsd 64(%rsi,%rax,8),%xmm2

    ## xmm0 = H2x
    ## xmm1 = H2y
    ## xmm2 = H2z

    movsd %xmm0,%xmm3
    movsd %xmm1,%xmm4
    movsd %xmm2,%xmm5
    movsd %xmm0,%xmm6
    movsd %xmm1,%xmm7
    movsd %xmm2,%xmm8

    subsd nb114_ixH1(%rsp),%xmm0
    subsd nb114_iyH1(%rsp),%xmm1
    subsd nb114_izH1(%rsp),%xmm2
    subsd nb114_ixH2(%rsp),%xmm3
    subsd nb114_iyH2(%rsp),%xmm4
    subsd nb114_izH2(%rsp),%xmm5
    subsd nb114_ixM(%rsp),%xmm6
    subsd nb114_iyM(%rsp),%xmm7
    subsd nb114_izM(%rsp),%xmm8

        movsd %xmm0,nb114_dxH1H2(%rsp)
        movsd %xmm1,nb114_dyH1H2(%rsp)
        movsd %xmm2,nb114_dzH1H2(%rsp)
        mulsd  %xmm0,%xmm0
        mulsd  %xmm1,%xmm1
        mulsd  %xmm2,%xmm2
        movsd %xmm3,nb114_dxH2H2(%rsp)
        movsd %xmm4,nb114_dyH2H2(%rsp)
        movsd %xmm5,nb114_dzH2H2(%rsp)
        mulsd  %xmm3,%xmm3
        mulsd  %xmm4,%xmm4
        mulsd  %xmm5,%xmm5
        movsd %xmm6,nb114_dxMH2(%rsp)
        movsd %xmm7,nb114_dyMH2(%rsp)
        movsd %xmm8,nb114_dzMH2(%rsp)
        mulsd  %xmm6,%xmm6
        mulsd  %xmm7,%xmm7
        mulsd  %xmm8,%xmm8
        addsd  %xmm1,%xmm0
        addsd  %xmm2,%xmm0
        addsd  %xmm4,%xmm3
        addsd  %xmm5,%xmm3
    addsd  %xmm7,%xmm6
    addsd  %xmm8,%xmm6

        ## start doing invsqrt for jH2 atoms
    cvtsd2ss %xmm0,%xmm1
    cvtsd2ss %xmm3,%xmm4
    cvtsd2ss %xmm6,%xmm7
        rsqrtss %xmm1,%xmm1
        rsqrtss %xmm4,%xmm4
    rsqrtss %xmm7,%xmm7
    cvtss2sd %xmm1,%xmm1
    cvtss2sd %xmm4,%xmm4
    cvtss2sd %xmm7,%xmm7

        movsd  %xmm1,%xmm2
        movsd  %xmm4,%xmm5
    movsd  %xmm7,%xmm8

        mulsd   %xmm1,%xmm1 ## lu*lu
        mulsd   %xmm4,%xmm4 ## lu*lu
    mulsd   %xmm7,%xmm7 ## lu*lu

        movsd  nb114_three(%rsp),%xmm9
        movsd  %xmm9,%xmm10
    movsd  %xmm9,%xmm11

        mulsd   %xmm0,%xmm1 ## rsq*lu*lu
        mulsd   %xmm3,%xmm4 ## rsq*lu*lu 
    mulsd   %xmm6,%xmm7 ## rsq*lu*lu

        subsd   %xmm1,%xmm9
        subsd   %xmm4,%xmm10
    subsd   %xmm7,%xmm11 ## 3-rsq*lu*lu

        mulsd   %xmm2,%xmm9
        mulsd   %xmm5,%xmm10
    mulsd   %xmm8,%xmm11 ## lu*(3-rsq*lu*lu)

        movsd  nb114_half(%rsp),%xmm15
        mulsd   %xmm15,%xmm9 ## first iteration for rinvH1H2 
        mulsd   %xmm15,%xmm10 ## first iteration for rinvH2H2
    mulsd   %xmm15,%xmm11 ## first iteration for rinvMH2

    ## second iteration step    
        movsd  %xmm9,%xmm2
        movsd  %xmm10,%xmm5
    movsd  %xmm11,%xmm8

        mulsd   %xmm2,%xmm2 ## lu*lu
        mulsd   %xmm5,%xmm5 ## lu*lu
    mulsd   %xmm8,%xmm8 ## lu*lu

        movsd  nb114_three(%rsp),%xmm1
        movsd  %xmm1,%xmm4
    movsd  %xmm1,%xmm7

        mulsd   %xmm0,%xmm2 ## rsq*lu*lu
        mulsd   %xmm3,%xmm5 ## rsq*lu*lu 
    mulsd   %xmm6,%xmm8 ## rsq*lu*lu

        subsd   %xmm2,%xmm1
        subsd   %xmm5,%xmm4
    subsd   %xmm8,%xmm7 ## 3-rsq*lu*lu

        mulsd   %xmm1,%xmm9
        mulsd   %xmm4,%xmm10
    mulsd   %xmm7,%xmm11 ## lu*(3-rsq*lu*lu)

        movsd  nb114_half(%rsp),%xmm15
        mulsd   %xmm15,%xmm9 ##  rinvH1H2
        mulsd   %xmm15,%xmm10 ##   rinvH2H2
    mulsd   %xmm15,%xmm11 ##   rinvMH2

        ## H2 interactions 
    movsd %xmm9,%xmm0
    movsd %xmm10,%xmm1
    movsd %xmm11,%xmm2
    mulsd  %xmm9,%xmm9
    mulsd  %xmm10,%xmm10
    mulsd  %xmm11,%xmm11
    mulsd  nb114_qqHH(%rsp),%xmm0
    mulsd  nb114_qqHH(%rsp),%xmm1
    mulsd  nb114_qqMH(%rsp),%xmm2
    mulsd  %xmm0,%xmm9
    mulsd  %xmm1,%xmm10
    mulsd  %xmm2,%xmm11

    addsd nb114_vctot(%rsp),%xmm0
    addsd %xmm2,%xmm1
    addsd %xmm1,%xmm0
    movsd %xmm0,nb114_vctot(%rsp)

    ## move j H2 forces to xmm0-xmm2
        movsd 48(%rdi,%rax,8),%xmm0
        movsd 56(%rdi,%rax,8),%xmm1
        movsd 64(%rdi,%rax,8),%xmm2

    movsd %xmm9,%xmm7
    movsd %xmm9,%xmm8
    movsd %xmm11,%xmm13
    movsd %xmm11,%xmm14
    movsd %xmm11,%xmm15
    movsd %xmm10,%xmm11
    movsd %xmm10,%xmm12

        mulsd nb114_dxH1H2(%rsp),%xmm7
        mulsd nb114_dyH1H2(%rsp),%xmm8
        mulsd nb114_dzH1H2(%rsp),%xmm9
        mulsd nb114_dxH2H2(%rsp),%xmm10
        mulsd nb114_dyH2H2(%rsp),%xmm11
        mulsd nb114_dzH2H2(%rsp),%xmm12
        mulsd nb114_dxMH2(%rsp),%xmm13
        mulsd nb114_dyMH2(%rsp),%xmm14
        mulsd nb114_dzMH2(%rsp),%xmm15

    addsd %xmm7,%xmm0
    addsd %xmm8,%xmm1
    addsd %xmm9,%xmm2
    addsd nb114_fixH1(%rsp),%xmm7
    addsd nb114_fiyH1(%rsp),%xmm8
    addsd nb114_fizH1(%rsp),%xmm9

    addsd %xmm10,%xmm0
    addsd %xmm11,%xmm1
    addsd %xmm12,%xmm2
    addsd nb114_fixH2(%rsp),%xmm10
    addsd nb114_fiyH2(%rsp),%xmm11
    addsd nb114_fizH2(%rsp),%xmm12

    addsd %xmm13,%xmm0
    addsd %xmm14,%xmm1
    addsd %xmm15,%xmm2
    addsd nb114_fixM(%rsp),%xmm13
    addsd nb114_fiyM(%rsp),%xmm14
    addsd nb114_fizM(%rsp),%xmm15

    movsd %xmm7,nb114_fixH1(%rsp)
    movsd %xmm8,nb114_fiyH1(%rsp)
    movsd %xmm9,nb114_fizH1(%rsp)
    movsd %xmm10,nb114_fixH2(%rsp)
    movsd %xmm11,nb114_fiyH2(%rsp)
    movsd %xmm12,nb114_fizH2(%rsp)
    movsd %xmm13,nb114_fixM(%rsp)
    movsd %xmm14,nb114_fiyM(%rsp)
    movsd %xmm15,nb114_fizM(%rsp)

    ## store back j H2 forces from xmm0-xmm2
        movsd %xmm0,48(%rdi,%rax,8)
        movsd %xmm1,56(%rdi,%rax,8)
        movsd %xmm2,64(%rdi,%rax,8)

        ## move j M coordinates to local temp variables 
    movsd 72(%rsi,%rax,8),%xmm0
    movsd 80(%rsi,%rax,8),%xmm1
    movsd 88(%rsi,%rax,8),%xmm2

    ## xmm0 = Mx
    ## xmm1 = My
    ## xmm2 = Mz

    movsd %xmm0,%xmm3
    movsd %xmm1,%xmm4
    movsd %xmm2,%xmm5
    movsd %xmm0,%xmm6
    movsd %xmm1,%xmm7
    movsd %xmm2,%xmm8

    subsd nb114_ixH1(%rsp),%xmm0
    subsd nb114_iyH1(%rsp),%xmm1
    subsd nb114_izH1(%rsp),%xmm2
    subsd nb114_ixH2(%rsp),%xmm3
    subsd nb114_iyH2(%rsp),%xmm4
    subsd nb114_izH2(%rsp),%xmm5
    subsd nb114_ixM(%rsp),%xmm6
    subsd nb114_iyM(%rsp),%xmm7
    subsd nb114_izM(%rsp),%xmm8

        movsd %xmm0,nb114_dxH1M(%rsp)
        movsd %xmm1,nb114_dyH1M(%rsp)
        movsd %xmm2,nb114_dzH1M(%rsp)
        mulsd  %xmm0,%xmm0
        mulsd  %xmm1,%xmm1
        mulsd  %xmm2,%xmm2
        movsd %xmm3,nb114_dxH2M(%rsp)
        movsd %xmm4,nb114_dyH2M(%rsp)
        movsd %xmm5,nb114_dzH2M(%rsp)
        mulsd  %xmm3,%xmm3
        mulsd  %xmm4,%xmm4
        mulsd  %xmm5,%xmm5
        movsd %xmm6,nb114_dxMM(%rsp)
        movsd %xmm7,nb114_dyMM(%rsp)
        movsd %xmm8,nb114_dzMM(%rsp)
        mulsd  %xmm6,%xmm6
        mulsd  %xmm7,%xmm7
        mulsd  %xmm8,%xmm8
        addsd  %xmm1,%xmm0
        addsd  %xmm2,%xmm0
        addsd  %xmm4,%xmm3
        addsd  %xmm5,%xmm3
    addsd  %xmm7,%xmm6
    addsd  %xmm8,%xmm6

        ## start doing invsqrt for jM atoms
    cvtsd2ss %xmm0,%xmm1
    cvtsd2ss %xmm3,%xmm4
    cvtsd2ss %xmm6,%xmm7
        rsqrtss %xmm1,%xmm1
        rsqrtss %xmm4,%xmm4
    rsqrtss %xmm7,%xmm7
    cvtss2sd %xmm1,%xmm1
    cvtss2sd %xmm4,%xmm4
    cvtss2sd %xmm7,%xmm7

        movsd  %xmm1,%xmm2
        movsd  %xmm4,%xmm5
    movsd  %xmm7,%xmm8

        mulsd   %xmm1,%xmm1 ## lu*lu
        mulsd   %xmm4,%xmm4 ## lu*lu
    mulsd   %xmm7,%xmm7 ## lu*lu

        movsd  nb114_three(%rsp),%xmm9
        movsd  %xmm9,%xmm10
    movsd  %xmm9,%xmm11

        mulsd   %xmm0,%xmm1 ## rsq*lu*lu
        mulsd   %xmm3,%xmm4 ## rsq*lu*lu 
    mulsd   %xmm6,%xmm7 ## rsq*lu*lu

        subsd   %xmm1,%xmm9
        subsd   %xmm4,%xmm10
    subsd   %xmm7,%xmm11 ## 3-rsq*lu*lu

        mulsd   %xmm2,%xmm9
        mulsd   %xmm5,%xmm10
    mulsd   %xmm8,%xmm11 ## lu*(3-rsq*lu*lu)

        movsd  nb114_half(%rsp),%xmm15
        mulsd   %xmm15,%xmm9 ## first iteration for rinvH1M 
        mulsd   %xmm15,%xmm10 ## first iteration for rinvH2M
    mulsd   %xmm15,%xmm11 ## first iteration for rinvMM

    ## second iteration step    
        movsd  %xmm9,%xmm2
        movsd  %xmm10,%xmm5
    movsd  %xmm11,%xmm8

        mulsd   %xmm2,%xmm2 ## lu*lu
        mulsd   %xmm5,%xmm5 ## lu*lu
    mulsd   %xmm8,%xmm8 ## lu*lu

        movsd  nb114_three(%rsp),%xmm1
        movsd  %xmm1,%xmm4
    movsd  %xmm1,%xmm7

        mulsd   %xmm0,%xmm2 ## rsq*lu*lu
        mulsd   %xmm3,%xmm5 ## rsq*lu*lu 
    mulsd   %xmm6,%xmm8 ## rsq*lu*lu

        subsd   %xmm2,%xmm1
        subsd   %xmm5,%xmm4
    subsd   %xmm8,%xmm7 ## 3-rsq*lu*lu

        mulsd   %xmm1,%xmm9
        mulsd   %xmm4,%xmm10
    mulsd   %xmm7,%xmm11 ## lu*(3-rsq*lu*lu)

        movsd  nb114_half(%rsp),%xmm15
        mulsd   %xmm15,%xmm9 ##  rinvH1M
        mulsd   %xmm15,%xmm10 ##   rinvH2M
    mulsd   %xmm15,%xmm11 ##   rinvMM

        ## M interactions 
    movsd %xmm9,%xmm0
    movsd %xmm10,%xmm1
    movsd %xmm11,%xmm2
    mulsd  %xmm9,%xmm9
    mulsd  %xmm10,%xmm10
    mulsd  %xmm11,%xmm11
    mulsd  nb114_qqMH(%rsp),%xmm0
    mulsd  nb114_qqMH(%rsp),%xmm1
    mulsd  nb114_qqMM(%rsp),%xmm2
    mulsd  %xmm0,%xmm9
    mulsd  %xmm1,%xmm10
    mulsd  %xmm2,%xmm11

    addsd nb114_vctot(%rsp),%xmm0
    addsd %xmm2,%xmm1
    addsd %xmm1,%xmm0
    movsd %xmm0,nb114_vctot(%rsp)

    ## move j M forces to xmm0-xmm2
        movsd 72(%rdi,%rax,8),%xmm0
        movsd 80(%rdi,%rax,8),%xmm1
        movsd 88(%rdi,%rax,8),%xmm2

    movsd %xmm9,%xmm7
    movsd %xmm9,%xmm8
    movsd %xmm11,%xmm13
    movsd %xmm11,%xmm14
    movsd %xmm11,%xmm15
    movsd %xmm10,%xmm11
    movsd %xmm10,%xmm12

        mulsd nb114_dxH1M(%rsp),%xmm7
        mulsd nb114_dyH1M(%rsp),%xmm8
        mulsd nb114_dzH1M(%rsp),%xmm9
        mulsd nb114_dxH2M(%rsp),%xmm10
        mulsd nb114_dyH2M(%rsp),%xmm11
        mulsd nb114_dzH2M(%rsp),%xmm12
        mulsd nb114_dxMM(%rsp),%xmm13
        mulsd nb114_dyMM(%rsp),%xmm14
        mulsd nb114_dzMM(%rsp),%xmm15

    addsd %xmm7,%xmm0
    addsd %xmm8,%xmm1
    addsd %xmm9,%xmm2
    addsd nb114_fixH1(%rsp),%xmm7
    addsd nb114_fiyH1(%rsp),%xmm8
    addsd nb114_fizH1(%rsp),%xmm9

    addsd %xmm10,%xmm0
    addsd %xmm11,%xmm1
    addsd %xmm12,%xmm2
    addsd nb114_fixH2(%rsp),%xmm10
    addsd nb114_fiyH2(%rsp),%xmm11
    addsd nb114_fizH2(%rsp),%xmm12

    addsd %xmm13,%xmm0
    addsd %xmm14,%xmm1
    addsd %xmm15,%xmm2
    addsd nb114_fixM(%rsp),%xmm13
    addsd nb114_fiyM(%rsp),%xmm14
    addsd nb114_fizM(%rsp),%xmm15

    movsd %xmm7,nb114_fixH1(%rsp)
    movsd %xmm8,nb114_fiyH1(%rsp)
    movsd %xmm9,nb114_fizH1(%rsp)
    movsd %xmm10,nb114_fixH2(%rsp)
    movsd %xmm11,nb114_fiyH2(%rsp)
    movsd %xmm12,nb114_fizH2(%rsp)
    movsd %xmm13,nb114_fixM(%rsp)
    movsd %xmm14,nb114_fiyM(%rsp)
    movsd %xmm15,nb114_fizM(%rsp)

    ## store back j M forces from xmm0-xmm2
        movsd %xmm0,72(%rdi,%rax,8)
        movsd %xmm1,80(%rdi,%rax,8)
        movsd %xmm2,88(%rdi,%rax,8)

_nb_kernel114_x86_64_sse2.nb114_updateouterdata: 
        movl  nb114_ii3(%rsp),%ecx
        movq  nb114_faction(%rbp),%rdi
        movq  nb114_fshift(%rbp),%rsi
        movl  nb114_is3(%rsp),%edx

        ## accumulate  Oi forces in xmm0, xmm1, xmm2 
        movapd nb114_fixO(%rsp),%xmm0
        movapd nb114_fiyO(%rsp),%xmm1
        movapd nb114_fizO(%rsp),%xmm2

        movhlps %xmm0,%xmm3
        movhlps %xmm1,%xmm4
        movhlps %xmm2,%xmm5
        addsd  %xmm3,%xmm0
        addsd  %xmm4,%xmm1
        addsd  %xmm5,%xmm2 ## sum is in low xmm0-xmm2 

        movapd %xmm0,%xmm3
        movapd %xmm1,%xmm4
        movapd %xmm2,%xmm5

        ## increment i force 
        movsd  (%rdi,%rcx,8),%xmm3
        movsd  8(%rdi,%rcx,8),%xmm4
        movsd  16(%rdi,%rcx,8),%xmm5
        subsd  %xmm0,%xmm3
        subsd  %xmm1,%xmm4
        subsd  %xmm2,%xmm5
        movsd  %xmm3,(%rdi,%rcx,8)
        movsd  %xmm4,8(%rdi,%rcx,8)
        movsd  %xmm5,16(%rdi,%rcx,8)

        ## accumulate force in xmm6/xmm7 for fshift 
        movapd %xmm0,%xmm6
        movsd %xmm2,%xmm7
        unpcklpd %xmm1,%xmm6

        ## accumulate H1i forces in xmm0, xmm1, xmm2 
        movapd nb114_fixH1(%rsp),%xmm0
        movapd nb114_fiyH1(%rsp),%xmm1
        movapd nb114_fizH1(%rsp),%xmm2

        movhlps %xmm0,%xmm3
        movhlps %xmm1,%xmm4
        movhlps %xmm2,%xmm5
        addsd  %xmm3,%xmm0
        addsd  %xmm4,%xmm1
        addsd  %xmm5,%xmm2 ## sum is in low xmm0-xmm2 

        ## increment i force 
        movsd  24(%rdi,%rcx,8),%xmm3
        movsd  32(%rdi,%rcx,8),%xmm4
        movsd  40(%rdi,%rcx,8),%xmm5
        subsd  %xmm0,%xmm3
        subsd  %xmm1,%xmm4
        subsd  %xmm2,%xmm5
        movsd  %xmm3,24(%rdi,%rcx,8)
        movsd  %xmm4,32(%rdi,%rcx,8)
        movsd  %xmm5,40(%rdi,%rcx,8)

        ## accumulate force in xmm6/xmm7 for fshift 
        addsd %xmm2,%xmm7
        unpcklpd %xmm1,%xmm0
        addpd %xmm0,%xmm6

        ## accumulate H2i forces in xmm0, xmm1, xmm2 
        movapd nb114_fixH2(%rsp),%xmm0
        movapd nb114_fiyH2(%rsp),%xmm1
        movapd nb114_fizH2(%rsp),%xmm2

        movhlps %xmm0,%xmm3
        movhlps %xmm1,%xmm4
        movhlps %xmm2,%xmm5
        addsd  %xmm3,%xmm0
        addsd  %xmm4,%xmm1
        addsd  %xmm5,%xmm2 ## sum is in low xmm0-xmm2 

        movapd %xmm0,%xmm3
        movapd %xmm1,%xmm4
        movapd %xmm2,%xmm5

        ## increment i force 
        movsd  48(%rdi,%rcx,8),%xmm3
        movsd  56(%rdi,%rcx,8),%xmm4
        movsd  64(%rdi,%rcx,8),%xmm5
        subsd  %xmm0,%xmm3
        subsd  %xmm1,%xmm4
        subsd  %xmm2,%xmm5
        movsd  %xmm3,48(%rdi,%rcx,8)
        movsd  %xmm4,56(%rdi,%rcx,8)
        movsd  %xmm5,64(%rdi,%rcx,8)

        ## accumulate force in xmm6/xmm7 for fshift 
        addsd %xmm2,%xmm7
        unpcklpd %xmm1,%xmm0
        addpd %xmm0,%xmm6

        ## accumulate Mi forces in xmm0, xmm1, xmm2 
        movapd nb114_fixM(%rsp),%xmm0
        movapd nb114_fiyM(%rsp),%xmm1
        movapd nb114_fizM(%rsp),%xmm2

        movhlps %xmm0,%xmm3
        movhlps %xmm1,%xmm4
        movhlps %xmm2,%xmm5
        addsd  %xmm3,%xmm0
        addsd  %xmm4,%xmm1
        addsd  %xmm5,%xmm2 ## sum is in low xmm0-xmm2 

        movapd %xmm0,%xmm3
        movapd %xmm1,%xmm4
        movapd %xmm2,%xmm5

        ## increment i force 
        movsd  72(%rdi,%rcx,8),%xmm3
        movsd  80(%rdi,%rcx,8),%xmm4
        movsd  88(%rdi,%rcx,8),%xmm5
        subsd  %xmm0,%xmm3
        subsd  %xmm1,%xmm4
        subsd  %xmm2,%xmm5
        movsd  %xmm3,72(%rdi,%rcx,8)
        movsd  %xmm4,80(%rdi,%rcx,8)
        movsd  %xmm5,88(%rdi,%rcx,8)

        ## accumulate force in xmm6/xmm7 for fshift 
        addsd %xmm2,%xmm7
        unpcklpd %xmm1,%xmm0
        addpd %xmm0,%xmm6

        ## increment fshift force 
        movlpd (%rsi,%rdx,8),%xmm3
        movhpd 8(%rsi,%rdx,8),%xmm3
        movsd  16(%rsi,%rdx,8),%xmm4
        subpd  %xmm6,%xmm3
        subsd  %xmm7,%xmm4
        movlpd %xmm3,(%rsi,%rdx,8)
        movhpd %xmm3,8(%rsi,%rdx,8)
        movsd  %xmm4,16(%rsi,%rdx,8)

        ## get n from stack
        movl nb114_n(%rsp),%esi
        ## get group index for i particle 
        movq  nb114_gid(%rbp),%rdx              ## base of gid[]
        movl  (%rdx,%rsi,4),%edx                ## ggid=gid[n]

        ## accumulate total potential energy and update it 
        movapd nb114_vctot(%rsp),%xmm7
        ## accumulate 
        movhlps %xmm7,%xmm6
        addsd  %xmm6,%xmm7      ## low xmm7 has the sum now 

        ## add earlier value from mem 
        movq  nb114_Vc(%rbp),%rax
        addsd (%rax,%rdx,8),%xmm7
        ## move back to mem 
        movsd %xmm7,(%rax,%rdx,8)

        ## accumulate total lj energy and update it 
        movapd nb114_Vvdwtot(%rsp),%xmm7
        ## accumulate 
        movhlps %xmm7,%xmm6
        addsd  %xmm6,%xmm7      ## low xmm7 has the sum now 

        ## add earlier value from mem 
        movq  nb114_Vvdw(%rbp),%rax
        addsd (%rax,%rdx,8),%xmm7
        ## move back to mem 
        movsd %xmm7,(%rax,%rdx,8)

        ## finish if last 
        movl nb114_nn1(%rsp),%ecx
        ## esi already loaded with n
        incl %esi
        subl %esi,%ecx
        jz _nb_kernel114_x86_64_sse2.nb114_outerend

        ## not last, iterate outer loop once more!  
        movl %esi,nb114_n(%rsp)
        jmp _nb_kernel114_x86_64_sse2.nb114_outer
_nb_kernel114_x86_64_sse2.nb114_outerend: 
        ## check if more outer neighborlists remain
        movl  nb114_nri(%rsp),%ecx
        ## esi already loaded with n above
        subl  %esi,%ecx
        jz _nb_kernel114_x86_64_sse2.nb114_end
        ## non-zero, do one more workunit
        jmp   _nb_kernel114_x86_64_sse2.nb114_threadloop
_nb_kernel114_x86_64_sse2.nb114_end: 
        movl nb114_nouter(%rsp),%eax
        movl nb114_ninner(%rsp),%ebx
        movq nb114_outeriter(%rbp),%rcx
        movq nb114_inneriter(%rbp),%rdx
        movl %eax,(%rcx)
        movl %ebx,(%rdx)

        addq $1880,%rsp
        emms


        pop %r15
        pop %r14
        pop %r13
        pop %r12

        pop %rbx
        pop    %rbp
        ret







.globl nb_kernel114nf_x86_64_sse2
.globl _nb_kernel114nf_x86_64_sse2
nb_kernel114nf_x86_64_sse2:     
_nb_kernel114nf_x86_64_sse2:    
##      Room for return address and rbp (16 bytes)
.set nb114nf_fshift, 16
.set nb114nf_gid, 24
.set nb114nf_pos, 32
.set nb114nf_faction, 40
.set nb114nf_charge, 48
.set nb114nf_p_facel, 56
.set nb114nf_argkrf, 64
.set nb114nf_argcrf, 72
.set nb114nf_Vc, 80
.set nb114nf_type, 88
.set nb114nf_p_ntype, 96
.set nb114nf_vdwparam, 104
.set nb114nf_Vvdw, 112
.set nb114nf_p_tabscale, 120
.set nb114nf_VFtab, 128
.set nb114nf_invsqrta, 136
.set nb114nf_dvda, 144
.set nb114nf_p_gbtabscale, 152
.set nb114nf_GBtab, 160
.set nb114nf_p_nthreads, 168
.set nb114nf_count, 176
.set nb114nf_mtx, 184
.set nb114nf_outeriter, 192
.set nb114nf_inneriter, 200
.set nb114nf_work, 208
        ## stack offsets for local variables  
        ## bottom of stack is cache-aligned for sse2 use 
.set nb114nf_ixO, 0
.set nb114nf_iyO, 16
.set nb114nf_izO, 32
.set nb114nf_ixH1, 48
.set nb114nf_iyH1, 64
.set nb114nf_izH1, 80
.set nb114nf_ixH2, 96
.set nb114nf_iyH2, 112
.set nb114nf_izH2, 128
.set nb114nf_ixM, 144
.set nb114nf_iyM, 160
.set nb114nf_izM, 176
.set nb114nf_jxO, 192
.set nb114nf_jyO, 208
.set nb114nf_jzO, 224
.set nb114nf_jxH1, 240
.set nb114nf_jyH1, 256
.set nb114nf_jzH1, 272
.set nb114nf_jxH2, 288
.set nb114nf_jyH2, 304
.set nb114nf_jzH2, 320
.set nb114nf_jxM, 336
.set nb114nf_jyM, 352
.set nb114nf_jzM, 368
.set nb114nf_qqMM, 384
.set nb114nf_qqMH, 400
.set nb114nf_qqHH, 416
.set nb114nf_two, 432
.set nb114nf_c6, 448
.set nb114nf_c12, 464
.set nb114nf_vctot, 480
.set nb114nf_Vvdwtot, 496
.set nb114nf_half, 512
.set nb114nf_three, 528
.set nb114nf_rsqOO, 544
.set nb114nf_rsqH1H1, 560
.set nb114nf_rsqH1H2, 576
.set nb114nf_rsqH1M, 592
.set nb114nf_rsqH2H1, 608
.set nb114nf_rsqH2H2, 624
.set nb114nf_rsqH2M, 640
.set nb114nf_rsqMH1, 656
.set nb114nf_rsqMH2, 672
.set nb114nf_rsqMM, 688
.set nb114nf_rinvsqOO, 704
.set nb114nf_rinvH1H1, 720
.set nb114nf_rinvH1H2, 736
.set nb114nf_rinvH1M, 752
.set nb114nf_rinvH2H1, 768
.set nb114nf_rinvH2H2, 784
.set nb114nf_rinvH2M, 800
.set nb114nf_rinvMH1, 816
.set nb114nf_rinvMH2, 832
.set nb114nf_rinvMM, 848
.set nb114nf_nri, 864
.set nb114nf_iinr, 872
.set nb114nf_jindex, 880
.set nb114nf_jjnr, 888
.set nb114nf_shift, 896
.set nb114nf_shiftvec, 904
.set nb114nf_facel, 912
.set nb114nf_innerjjnr, 920
.set nb114nf_is3, 928
.set nb114nf_ii3, 932
.set nb114nf_innerk, 936
.set nb114nf_n, 940
.set nb114nf_nn1, 944
.set nb114nf_nouter, 948
.set nb114nf_ninner, 952
        push %rbp
        movq %rsp,%rbp
        push %rbx

        emms

        push %r12
        push %r13
        push %r14
        push %r15

        subq $968,%rsp          ## local variable stack space (n*16+8)

        ## zero 32-bit iteration counters
        movl $0,%eax
        movl %eax,nb114nf_nouter(%rsp)
        movl %eax,nb114nf_ninner(%rsp)

        movl (%rdi),%edi
        movl %edi,nb114nf_nri(%rsp)
        movq %rsi,nb114nf_iinr(%rsp)
        movq %rdx,nb114nf_jindex(%rsp)
        movq %rcx,nb114nf_jjnr(%rsp)
        movq %r8,nb114nf_shift(%rsp)
        movq %r9,nb114nf_shiftvec(%rsp)
        movq nb114nf_p_facel(%rbp),%rsi
        movsd (%rsi),%xmm0
        movsd %xmm0,nb114nf_facel(%rsp)


        ## create constant floating-point factors on stack
        movl $0x00000000,%eax   ## lower half of double half IEEE (hex)
        movl $0x3fe00000,%ebx
        movl %eax,nb114nf_half(%rsp)
        movl %ebx,nb114nf_half+4(%rsp)
        movsd nb114nf_half(%rsp),%xmm1
        shufpd $0,%xmm1,%xmm1  ## splat to all elements
        movapd %xmm1,%xmm3
        addpd  %xmm3,%xmm3      ## one
        movapd %xmm3,%xmm2
        addpd  %xmm2,%xmm2      ## two
        addpd  %xmm2,%xmm3      ## three
        movapd %xmm1,nb114nf_half(%rsp)
        movapd %xmm2,nb114nf_two(%rsp)
        movapd %xmm3,nb114nf_three(%rsp)

        ## assume we have at least one i particle - start directly 
        movq  nb114nf_iinr(%rsp),%rcx         ## rcx = pointer into iinr[]      
        movl  (%rcx),%ebx           ## ebx =ii 

        movq  nb114nf_charge(%rbp),%rdx
        movsd 24(%rdx,%rbx,8),%xmm3
        movsd %xmm3,%xmm4
        movsd 8(%rdx,%rbx,8),%xmm5
        movq nb114nf_p_facel(%rbp),%rsi
        movsd (%rsi),%xmm0
        movsd nb114nf_facel(%rsp),%xmm6
        mulsd  %xmm3,%xmm3
        mulsd  %xmm5,%xmm4
        mulsd  %xmm5,%xmm5
        mulsd  %xmm6,%xmm3
        mulsd  %xmm6,%xmm4
        mulsd  %xmm6,%xmm5
        shufpd $0,%xmm3,%xmm3
        shufpd $0,%xmm4,%xmm4
        shufpd $0,%xmm5,%xmm5
        movapd %xmm3,nb114nf_qqMM(%rsp)
        movapd %xmm4,nb114nf_qqMH(%rsp)
        movapd %xmm5,nb114nf_qqHH(%rsp)

        xorpd %xmm0,%xmm0
        movq  nb114nf_type(%rbp),%rdx
        movl  (%rdx,%rbx,4),%ecx
        shll  %ecx
        movl  %ecx,%edx
        movq nb114nf_p_ntype(%rbp),%rdi
        imull (%rdi),%ecx     ## rcx = ntia = 2*ntype*type[ii0] 
        addl  %ecx,%edx
        movq  nb114nf_vdwparam(%rbp),%rax
        movlpd (%rax,%rdx,8),%xmm0
        movlpd 8(%rax,%rdx,8),%xmm1
        shufpd $0,%xmm0,%xmm0
        shufpd $0,%xmm1,%xmm1
        movapd %xmm0,nb114nf_c6(%rsp)
        movapd %xmm1,nb114nf_c12(%rsp)

_nb_kernel114nf_x86_64_sse2.nb114nf_threadloop: 
        movq  nb114nf_count(%rbp),%rsi            ## pointer to sync counter
        movl  (%rsi),%eax
_nb_kernel114nf_x86_64_sse2.nb114nf_spinlock: 
        movl  %eax,%ebx                         ## ebx=*count=nn0
        addl  $1,%ebx                          ## ebx=nn1=nn0+10
        lock 
        cmpxchgl %ebx,(%rsi)                    ## write nn1 to *counter,
                                                ## if it hasnt changed.
                                                ## or reread *counter to eax.
        pause                                   ## -> better p4 performance
        jnz _nb_kernel114nf_x86_64_sse2.nb114nf_spinlock

        ## if(nn1>nri) nn1=nri
        movl nb114nf_nri(%rsp),%ecx
        movl %ecx,%edx
        subl %ebx,%ecx
        cmovlel %edx,%ebx                       ## if(nn1>nri) nn1=nri
        ## Cleared the spinlock if we got here.
        ## eax contains nn0, ebx contains nn1.
        movl %eax,nb114nf_n(%rsp)
        movl %ebx,nb114nf_nn1(%rsp)
        subl %eax,%ebx                          ## calc number of outer lists
        movl %eax,%esi                          ## copy n to esi
        jg  _nb_kernel114nf_x86_64_sse2.nb114nf_outerstart
        jmp _nb_kernel114nf_x86_64_sse2.nb114nf_end

_nb_kernel114nf_x86_64_sse2.nb114nf_outerstart: 
        ## ebx contains number of outer iterations
        addl nb114nf_nouter(%rsp),%ebx
        movl %ebx,nb114nf_nouter(%rsp)

_nb_kernel114nf_x86_64_sse2.nb114nf_outer: 
        movq  nb114nf_shift(%rsp),%rax        ## rax = pointer into shift[] 
        movl  (%rax,%rsi,4),%ebx        ## rbx=shift[n] 

        lea  (%rbx,%rbx,2),%rbx    ## rbx=3*is 
        movl  %ebx,nb114nf_is3(%rsp)            ## store is3 

        movq  nb114nf_shiftvec(%rsp),%rax     ## rax = base of shiftvec[] 

        movsd (%rax,%rbx,8),%xmm0
        movsd 8(%rax,%rbx,8),%xmm1
        movsd 16(%rax,%rbx,8),%xmm2

        movq  nb114nf_iinr(%rsp),%rcx         ## rcx = pointer into iinr[]      
        movl  (%rcx,%rsi,4),%ebx    ## ebx =ii 

        movapd %xmm0,%xmm3
        movapd %xmm1,%xmm4
        movapd %xmm2,%xmm5
        movapd %xmm0,%xmm6
        movapd %xmm1,%xmm7

        lea  (%rbx,%rbx,2),%rbx        ## rbx = 3*ii=ii3 
        movq  nb114nf_pos(%rbp),%rax      ## rax = base of pos[]  
        movl  %ebx,nb114nf_ii3(%rsp)

        addsd (%rax,%rbx,8),%xmm3       ## ox
        addsd 8(%rax,%rbx,8),%xmm4      ## oy
        addsd 16(%rax,%rbx,8),%xmm5     ## oz   
        addsd 24(%rax,%rbx,8),%xmm6     ## h1x
        addsd 32(%rax,%rbx,8),%xmm7     ## h1y
        shufpd $0,%xmm3,%xmm3
        shufpd $0,%xmm4,%xmm4
        shufpd $0,%xmm5,%xmm5
        shufpd $0,%xmm6,%xmm6
        shufpd $0,%xmm7,%xmm7
        movapd %xmm3,nb114nf_ixO(%rsp)
        movapd %xmm4,nb114nf_iyO(%rsp)
        movapd %xmm5,nb114nf_izO(%rsp)
        movapd %xmm6,nb114nf_ixH1(%rsp)
        movapd %xmm7,nb114nf_iyH1(%rsp)

        movsd %xmm2,%xmm6
        movsd %xmm0,%xmm3
        movsd %xmm1,%xmm4
        movsd %xmm2,%xmm5
        addsd 40(%rax,%rbx,8),%xmm6    ## h1z
        addsd 48(%rax,%rbx,8),%xmm0    ## h2x
        addsd 56(%rax,%rbx,8),%xmm1    ## h2y
        addsd 64(%rax,%rbx,8),%xmm2    ## h2z
        addsd 72(%rax,%rbx,8),%xmm3    ## mx
        addsd 80(%rax,%rbx,8),%xmm4    ## my
        addsd 88(%rax,%rbx,8),%xmm5    ## mz

        shufpd $0,%xmm6,%xmm6
        shufpd $0,%xmm0,%xmm0
        shufpd $0,%xmm1,%xmm1
        shufpd $0,%xmm2,%xmm2
        shufpd $0,%xmm3,%xmm3
        shufpd $0,%xmm4,%xmm4
        shufpd $0,%xmm5,%xmm5
        movapd %xmm6,nb114nf_izH1(%rsp)
        movapd %xmm0,nb114nf_ixH2(%rsp)
        movapd %xmm1,nb114nf_iyH2(%rsp)
        movapd %xmm2,nb114nf_izH2(%rsp)
        movapd %xmm3,nb114nf_ixM(%rsp)
        movapd %xmm4,nb114nf_iyM(%rsp)
        movapd %xmm5,nb114nf_izM(%rsp)

        ## clear vctot 
        xorpd %xmm4,%xmm4
        movapd %xmm4,nb114nf_vctot(%rsp)
        movapd %xmm4,nb114nf_Vvdwtot(%rsp)

        movq  nb114nf_jindex(%rsp),%rax
        movl  (%rax,%rsi,4),%ecx             ## jindex[n] 
        movl  4(%rax,%rsi,4),%edx            ## jindex[n+1] 
        subl  %ecx,%edx              ## number of innerloop atoms 

        movq  nb114nf_pos(%rbp),%rsi
        movq  nb114nf_faction(%rbp),%rdi
        movq  nb114nf_jjnr(%rsp),%rax
        shll  $2,%ecx
        addq  %rcx,%rax
        movq  %rax,nb114nf_innerjjnr(%rsp)       ## pointer to jjnr[nj0] 
        movl  %edx,%ecx
        subl  $2,%edx
        addl  nb114nf_ninner(%rsp),%ecx
        movl  %ecx,nb114nf_ninner(%rsp)
        addl  $0,%edx
        movl  %edx,nb114nf_innerk(%rsp)      ## number of innerloop atoms 
        jge   _nb_kernel114nf_x86_64_sse2.nb114nf_unroll_loop
        jmp   _nb_kernel114nf_x86_64_sse2.nb114nf_checksingle
_nb_kernel114nf_x86_64_sse2.nb114nf_unroll_loop: 
        ## twice unrolled innerloop here 
        movq  nb114nf_innerjjnr(%rsp),%rdx       ## pointer to jjnr[k] 
        movl  (%rdx),%eax
        movl  4(%rdx),%ebx

        addq $8,nb114nf_innerjjnr(%rsp)            ## advance pointer (unrolled 2) 

        movq nb114nf_pos(%rbp),%rsi        ## base of pos[] 

        lea  (%rax,%rax,2),%rax     ## replace jnr with j3 
        lea  (%rbx,%rbx,2),%rbx

        ## move j coordinates to local temp variables 
        ## load ox, oy, oz, h1x
        movlpd (%rsi,%rax,8),%xmm0
        movlpd (%rsi,%rbx,8),%xmm2
        movhpd 8(%rsi,%rax,8),%xmm0
        movhpd 8(%rsi,%rbx,8),%xmm2
        movlpd 16(%rsi,%rax,8),%xmm3
        movlpd 16(%rsi,%rbx,8),%xmm5
        movhpd 24(%rsi,%rax,8),%xmm3
        movhpd 24(%rsi,%rbx,8),%xmm5
        movapd %xmm0,%xmm1
        movapd %xmm3,%xmm4
        unpcklpd %xmm2,%xmm0 ## ox 
        unpckhpd %xmm2,%xmm1 ## oy
        unpcklpd %xmm5,%xmm3 ## ox 
        unpckhpd %xmm5,%xmm4 ## oy
        movapd  %xmm0,nb114nf_jxO(%rsp)
        movapd  %xmm1,nb114nf_jyO(%rsp)
        movapd  %xmm3,nb114nf_jzO(%rsp)
        movapd  %xmm4,nb114nf_jxH1(%rsp)

        ## load h1y, h1z, h2x, h2y 
        movlpd 32(%rsi,%rax,8),%xmm0
        movlpd 32(%rsi,%rbx,8),%xmm2
        movhpd 40(%rsi,%rax,8),%xmm0
        movhpd 40(%rsi,%rbx,8),%xmm2
        movlpd 48(%rsi,%rax,8),%xmm3
        movlpd 48(%rsi,%rbx,8),%xmm5
        movhpd 56(%rsi,%rax,8),%xmm3
        movhpd 56(%rsi,%rbx,8),%xmm5
        movapd %xmm0,%xmm1
        movapd %xmm3,%xmm4
        unpcklpd %xmm2,%xmm0 ## h1y
        unpckhpd %xmm2,%xmm1 ## h1z
        unpcklpd %xmm5,%xmm3 ## h2x
        unpckhpd %xmm5,%xmm4 ## h2y
        movapd  %xmm0,nb114nf_jyH1(%rsp)
        movapd  %xmm1,nb114nf_jzH1(%rsp)
        movapd  %xmm3,nb114nf_jxH2(%rsp)
        movapd  %xmm4,nb114nf_jyH2(%rsp)

        ## load h2z, mx, my, mz
        movlpd 64(%rsi,%rax,8),%xmm0
        movlpd 64(%rsi,%rbx,8),%xmm2
        movhpd 72(%rsi,%rax,8),%xmm0
        movhpd 72(%rsi,%rbx,8),%xmm2
        movlpd 80(%rsi,%rax,8),%xmm3
        movlpd 80(%rsi,%rbx,8),%xmm5
        movhpd 88(%rsi,%rax,8),%xmm3
        movhpd 88(%rsi,%rbx,8),%xmm5
        movapd %xmm0,%xmm1
        movapd %xmm3,%xmm4
        unpcklpd %xmm2,%xmm0 ## h2z
        unpckhpd %xmm2,%xmm1 ## mx
        unpcklpd %xmm5,%xmm3 ## my
        unpckhpd %xmm5,%xmm4 ## mz
        movapd  %xmm0,nb114nf_jzH2(%rsp)
        movapd  %xmm1,nb114nf_jxM(%rsp)
        movapd  %xmm3,nb114nf_jyM(%rsp)
        movapd  %xmm4,nb114nf_jzM(%rsp)

        ## start calculating pairwise distances
        movapd nb114nf_ixO(%rsp),%xmm0
        movapd nb114nf_iyO(%rsp),%xmm1
        movapd nb114nf_izO(%rsp),%xmm2
        movapd nb114nf_ixH1(%rsp),%xmm3
        movapd nb114nf_iyH1(%rsp),%xmm4
        movapd nb114nf_izH1(%rsp),%xmm5
        subpd  nb114nf_jxO(%rsp),%xmm0
        subpd  nb114nf_jyO(%rsp),%xmm1
        subpd  nb114nf_jzO(%rsp),%xmm2
        subpd  nb114nf_jxH1(%rsp),%xmm3
        subpd  nb114nf_jyH1(%rsp),%xmm4
        subpd  nb114nf_jzH1(%rsp),%xmm5
        mulpd  %xmm0,%xmm0
        mulpd  %xmm1,%xmm1
        mulpd  %xmm2,%xmm2
        mulpd  %xmm3,%xmm3
        mulpd  %xmm4,%xmm4
        mulpd  %xmm5,%xmm5
        addpd  %xmm1,%xmm0
        addpd  %xmm2,%xmm0
        addpd  %xmm4,%xmm3
        addpd  %xmm5,%xmm3
        movapd %xmm0,nb114nf_rsqOO(%rsp)
        movapd %xmm3,nb114nf_rsqH1H1(%rsp)

        movapd nb114nf_ixH1(%rsp),%xmm0
        movapd nb114nf_iyH1(%rsp),%xmm1
        movapd nb114nf_izH1(%rsp),%xmm2
        movapd %xmm0,%xmm3
        movapd %xmm1,%xmm4
        movapd %xmm2,%xmm5
        subpd  nb114nf_jxH2(%rsp),%xmm0
        subpd  nb114nf_jyH2(%rsp),%xmm1
        subpd  nb114nf_jzH2(%rsp),%xmm2
        subpd  nb114nf_jxM(%rsp),%xmm3
        subpd  nb114nf_jyM(%rsp),%xmm4
        subpd  nb114nf_jzM(%rsp),%xmm5
        mulpd  %xmm0,%xmm0
        mulpd  %xmm1,%xmm1
        mulpd  %xmm2,%xmm2
        mulpd  %xmm3,%xmm3
        mulpd  %xmm4,%xmm4
        mulpd  %xmm5,%xmm5
        addpd  %xmm1,%xmm0
        addpd  %xmm2,%xmm0
        addpd  %xmm4,%xmm3
        addpd  %xmm5,%xmm3
        movapd %xmm0,nb114nf_rsqH1H2(%rsp)
        movapd %xmm3,nb114nf_rsqH1M(%rsp)

        movapd nb114nf_ixH2(%rsp),%xmm0
        movapd nb114nf_iyH2(%rsp),%xmm1
        movapd nb114nf_izH2(%rsp),%xmm2
        movapd %xmm0,%xmm3
        movapd %xmm1,%xmm4
        movapd %xmm2,%xmm5
        subpd  nb114nf_jxH1(%rsp),%xmm0
        subpd  nb114nf_jyH1(%rsp),%xmm1
        subpd  nb114nf_jzH1(%rsp),%xmm2
        subpd  nb114nf_jxH2(%rsp),%xmm3
        subpd  nb114nf_jyH2(%rsp),%xmm4
        subpd  nb114nf_jzH2(%rsp),%xmm5
        mulpd  %xmm0,%xmm0
        mulpd  %xmm1,%xmm1
        mulpd  %xmm2,%xmm2
        mulpd  %xmm3,%xmm3
        mulpd  %xmm4,%xmm4
        mulpd  %xmm5,%xmm5
        addpd  %xmm1,%xmm0
        addpd  %xmm2,%xmm0
        addpd  %xmm4,%xmm3
        addpd  %xmm5,%xmm3
        movapd %xmm0,nb114nf_rsqH2H1(%rsp)
        movapd %xmm3,nb114nf_rsqH2H2(%rsp)

        movapd nb114nf_ixH2(%rsp),%xmm0
        movapd nb114nf_iyH2(%rsp),%xmm1
        movapd nb114nf_izH2(%rsp),%xmm2
        movapd nb114nf_ixM(%rsp),%xmm3
        movapd nb114nf_iyM(%rsp),%xmm4
        movapd nb114nf_izM(%rsp),%xmm5
        subpd  nb114nf_jxM(%rsp),%xmm0
        subpd  nb114nf_jyM(%rsp),%xmm1
        subpd  nb114nf_jzM(%rsp),%xmm2
        subpd  nb114nf_jxH1(%rsp),%xmm3
        subpd  nb114nf_jyH1(%rsp),%xmm4
        subpd  nb114nf_jzH1(%rsp),%xmm5
        mulpd  %xmm0,%xmm0
        mulpd  %xmm1,%xmm1
        mulpd  %xmm2,%xmm2
        mulpd  %xmm3,%xmm3
        mulpd  %xmm4,%xmm4
        mulpd  %xmm5,%xmm5
        addpd  %xmm1,%xmm0
        addpd  %xmm2,%xmm0
        addpd  %xmm3,%xmm4
        addpd  %xmm5,%xmm4
        movapd %xmm0,nb114nf_rsqH2M(%rsp)
        movapd %xmm4,nb114nf_rsqMH1(%rsp)

        movapd nb114nf_ixM(%rsp),%xmm0
        movapd nb114nf_iyM(%rsp),%xmm1
        movapd nb114nf_izM(%rsp),%xmm2
        movapd %xmm0,%xmm3
        movapd %xmm1,%xmm4
        movapd %xmm2,%xmm5
        subpd  nb114nf_jxH2(%rsp),%xmm0
        subpd  nb114nf_jyH2(%rsp),%xmm1
        subpd  nb114nf_jzH2(%rsp),%xmm2
        subpd  nb114nf_jxM(%rsp),%xmm3
        subpd  nb114nf_jyM(%rsp),%xmm4
        subpd  nb114nf_jzM(%rsp),%xmm5
        mulpd  %xmm0,%xmm0
        mulpd  %xmm1,%xmm1
        mulpd  %xmm2,%xmm2
        mulpd  %xmm3,%xmm3
        mulpd  %xmm4,%xmm4
        mulpd  %xmm5,%xmm5
        addpd  %xmm1,%xmm0
        addpd  %xmm2,%xmm0
        addpd  %xmm3,%xmm4
        addpd  %xmm5,%xmm4
        movapd %xmm0,nb114nf_rsqMH2(%rsp)
        movapd %xmm4,nb114nf_rsqMM(%rsp)

        ## Invsqrt form rsq M-H2 (rsq in xmm0) and MM (rsq in xmm4) 
        cvtpd2ps %xmm0,%xmm1
        cvtpd2ps %xmm4,%xmm5
        rsqrtps %xmm1,%xmm1
        rsqrtps %xmm5,%xmm5
        cvtps2pd %xmm1,%xmm1  ## luA
        cvtps2pd %xmm5,%xmm5  ## luB

        movapd  %xmm1,%xmm2     ## copy of luA 
        movapd  %xmm5,%xmm6     ## copy of luB 
        mulpd   %xmm1,%xmm1     ## luA*luA 
        mulpd   %xmm5,%xmm5     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm3
        mulpd   %xmm0,%xmm1     ## rsqA*luA*luA 
        mulpd   %xmm4,%xmm5     ## rsqB*luB*luB         
        movapd  %xmm3,%xmm7
        subpd   %xmm1,%xmm3     ## 3-rsqA*luA*luA 
        subpd   %xmm5,%xmm7     ## 3-rsqB*luB*luB 
        mulpd   %xmm2,%xmm3     ## luA*(3-rsqA*luA*luA) 
        mulpd   %xmm6,%xmm7     ## luB*(3-rsqB*luB*luB) 
        mulpd   nb114nf_half(%rsp),%xmm3   ## iter1 
        mulpd   nb114nf_half(%rsp),%xmm7   ## iter1 

        movapd  %xmm3,%xmm2     ## copy of luA 
        movapd  %xmm7,%xmm6     ## copy of luB 
        mulpd   %xmm3,%xmm3     ## luA*luA 
        mulpd   %xmm7,%xmm7     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm1
        mulpd   %xmm0,%xmm3     ## rsqA*luA*luA 
        mulpd   %xmm4,%xmm7     ## rsqB*luB*luB         
        movapd  %xmm1,%xmm5
        subpd   %xmm3,%xmm1     ## 3-rsqA*luA*luA 
        subpd   %xmm7,%xmm5     ## 3-rsqB*luB*luB 
        mulpd   %xmm2,%xmm1     ## luA*(3-rsqA*luA*luA) 
        mulpd   %xmm6,%xmm5     ## luB*(3-rsqB*luB*luB) 
        mulpd   nb114nf_half(%rsp),%xmm1   ## rinv 
        mulpd   nb114nf_half(%rsp),%xmm5   ## rinv 
        movapd %xmm1,nb114nf_rinvMH2(%rsp)
        movapd %xmm5,nb114nf_rinvMM(%rsp)

        movapd nb114nf_rsqOO(%rsp),%xmm0
        movapd nb114nf_rsqH1H1(%rsp),%xmm4
        cvtpd2ps %xmm0,%xmm1
        cvtpd2ps %xmm4,%xmm5
        rsqrtps %xmm1,%xmm1
        rsqrtps %xmm5,%xmm5
        cvtps2pd %xmm1,%xmm1
        cvtps2pd %xmm5,%xmm5

        movapd  %xmm1,%xmm2     ## copy of luA 
        movapd  %xmm5,%xmm6     ## copy of luB 
        mulpd   %xmm1,%xmm1     ## luA*luA 
        mulpd   %xmm5,%xmm5     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm3
        mulpd   %xmm0,%xmm1     ## rsqA*luA*luA 
        mulpd   %xmm4,%xmm5     ## rsqB*luB*luB         
        movapd  %xmm3,%xmm7
        subpd   %xmm1,%xmm3     ## 3-rsqA*luA*luA 
        subpd   %xmm5,%xmm7     ## 3-rsqB*luB*luB 
        mulpd   %xmm2,%xmm3     ## luA*(3-rsqA*luA*luA) 
        mulpd   %xmm6,%xmm7     ## luB*(3-rsqB*luB*luB) 
        mulpd   nb114nf_half(%rsp),%xmm3   ## iter1 of  
        mulpd   nb114nf_half(%rsp),%xmm7   ## iter1 of  

        movapd  %xmm3,%xmm2     ## copy of luA 
        movapd  %xmm7,%xmm6     ## copy of luB 
        mulpd   %xmm3,%xmm3     ## luA*luA 
        mulpd   %xmm7,%xmm7     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm1
        mulpd   %xmm0,%xmm3     ## rsqA*luA*luA 
        mulpd   %xmm4,%xmm7     ## rsqB*luB*luB         
        movapd  %xmm1,%xmm5
        subpd   %xmm3,%xmm1     ## 3-rsqA*luA*luA 
        subpd   %xmm7,%xmm5     ## 3-rsqB*luB*luB 
        mulpd   %xmm2,%xmm1     ## luA*(3-rsqA*luA*luA) 
        mulpd   %xmm6,%xmm5     ## luB*(3-rsqB*luB*luB) 
        mulpd   nb114nf_half(%rsp),%xmm1   ## rinv 
        mulpd   nb114nf_half(%rsp),%xmm5   ## rinv
        mulpd   %xmm1,%xmm1
        movapd %xmm1,nb114nf_rinvsqOO(%rsp)
        movapd %xmm5,nb114nf_rinvH1H1(%rsp)

        movapd nb114nf_rsqH1H2(%rsp),%xmm0
        movapd nb114nf_rsqH1M(%rsp),%xmm4
        cvtpd2ps %xmm0,%xmm1
        cvtpd2ps %xmm4,%xmm5
        rsqrtps %xmm1,%xmm1
        rsqrtps %xmm5,%xmm5
        cvtps2pd %xmm1,%xmm1
        cvtps2pd %xmm5,%xmm5

        movapd  %xmm1,%xmm2     ## copy of luA 
        movapd  %xmm5,%xmm6     ## copy of luB 
        mulpd   %xmm1,%xmm1     ## luA*luA 
        mulpd   %xmm5,%xmm5     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm3
        mulpd   %xmm0,%xmm1     ## rsqA*luA*luA 
        mulpd   %xmm4,%xmm5     ## rsqB*luB*luB         
        movapd  %xmm3,%xmm7
        subpd   %xmm1,%xmm3     ## 3-rsqA*luA*luA 
        subpd   %xmm5,%xmm7     ## 3-rsqB*luB*luB 
        mulpd   %xmm2,%xmm3     ## luA*(3-rsqA*luA*luA) 
        mulpd   %xmm6,%xmm7     ## luB*(3-rsqB*luB*luB) 
        mulpd   nb114nf_half(%rsp),%xmm3   ## iter1 
        mulpd   nb114nf_half(%rsp),%xmm7   ## iter1 

        movapd  %xmm3,%xmm2     ## copy of luA 
        movapd  %xmm7,%xmm6     ## copy of luB 
        mulpd   %xmm3,%xmm3     ## luA*luA 
        mulpd   %xmm7,%xmm7     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm1
        mulpd   %xmm0,%xmm3     ## rsqA*luA*luA 
        mulpd   %xmm4,%xmm7     ## rsqB*luB*luB         
        movapd  %xmm1,%xmm5
        subpd   %xmm3,%xmm1     ## 3-rsqA*luA*luA 
        subpd   %xmm7,%xmm5     ## 3-rsqB*luB*luB 
        mulpd   %xmm2,%xmm1     ## luA*(3-rsqA*luA*luA) 
        mulpd   %xmm6,%xmm5     ## luB*(3-rsqB*luB*luB) 
        mulpd   nb114nf_half(%rsp),%xmm1   ## rinv 
        mulpd   nb114nf_half(%rsp),%xmm5   ## rinv 
        movapd %xmm1,nb114nf_rinvH1H2(%rsp)
        movapd %xmm5,nb114nf_rinvH1M(%rsp)

        movapd nb114nf_rsqH2H1(%rsp),%xmm0
        movapd nb114nf_rsqH2H2(%rsp),%xmm4
        cvtpd2ps %xmm0,%xmm1
        cvtpd2ps %xmm4,%xmm5
        rsqrtps %xmm1,%xmm1
        rsqrtps %xmm5,%xmm5
        cvtps2pd %xmm1,%xmm1
        cvtps2pd %xmm5,%xmm5

        movapd  %xmm1,%xmm2     ## copy of luA 
        movapd  %xmm5,%xmm6     ## copy of luB 
        mulpd   %xmm1,%xmm1     ## luA*luA 
        mulpd   %xmm5,%xmm5     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm3
        mulpd   %xmm0,%xmm1     ## rsqA*luA*luA 
        mulpd   %xmm4,%xmm5     ## rsqB*luB*luB         
        movapd  %xmm3,%xmm7
        subpd   %xmm1,%xmm3     ## 3-rsqA*luA*luA 
        subpd   %xmm5,%xmm7     ## 3-rsqB*luB*luB 
        mulpd   %xmm2,%xmm3     ## luA*(3-rsqA*luA*luA) 
        mulpd   %xmm6,%xmm7     ## luB*(3-rsqB*luB*luB) 
        mulpd   nb114nf_half(%rsp),%xmm3   ## iter1a 
        mulpd   nb114nf_half(%rsp),%xmm7   ## iter1b 

        movapd  %xmm3,%xmm2     ## copy of luA 
        movapd  %xmm7,%xmm6     ## copy of luB 
        mulpd   %xmm3,%xmm3     ## luA*luA 
        mulpd   %xmm7,%xmm7     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm1
        mulpd   %xmm0,%xmm3     ## rsqA*luA*luA 
        mulpd   %xmm4,%xmm7     ## rsqB*luB*luB         
        movapd  %xmm1,%xmm5
        subpd   %xmm3,%xmm1     ## 3-rsqA*luA*luA 
        subpd   %xmm7,%xmm5     ## 3-rsqB*luB*luB 
        mulpd   %xmm2,%xmm1     ## luA*(3-rsqA*luA*luA) 
        mulpd   %xmm6,%xmm5     ## luB*(3-rsqB*luB*luB) 
        mulpd   nb114nf_half(%rsp),%xmm1   ## rinv 
        mulpd   nb114nf_half(%rsp),%xmm5   ## rinv 
        movapd %xmm1,nb114nf_rinvH2H1(%rsp)
        movapd %xmm5,nb114nf_rinvH2H2(%rsp)

        movapd nb114nf_rsqMH1(%rsp),%xmm0
        movapd nb114nf_rsqH2M(%rsp),%xmm4
        cvtpd2ps %xmm0,%xmm1
        cvtpd2ps %xmm4,%xmm5
        rsqrtps %xmm1,%xmm1
        rsqrtps %xmm5,%xmm5
        cvtps2pd %xmm1,%xmm1
        cvtps2pd %xmm5,%xmm5

        movapd  %xmm1,%xmm2     ## copy of luA 
        movapd  %xmm5,%xmm6     ## copy of luB 
        mulpd   %xmm1,%xmm1     ## luA*luA 
        mulpd   %xmm5,%xmm5     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm3
        mulpd   %xmm0,%xmm1     ## rsqA*luA*luA 
        mulpd   %xmm4,%xmm5     ## rsqB*luB*luB         
        movapd  %xmm3,%xmm7
        subpd   %xmm1,%xmm3     ## 3-rsqA*luA*luA 
        subpd   %xmm5,%xmm7     ## 3-rsqB*luB*luB 
        mulpd   %xmm2,%xmm3     ## luA*(3-rsqA*luA*luA) 
        mulpd   %xmm6,%xmm7     ## luB*(3-rsqB*luB*luB) 
        mulpd   nb114nf_half(%rsp),%xmm3   ## iter1a 
        mulpd   nb114nf_half(%rsp),%xmm7   ## iter1b 

        movapd  %xmm3,%xmm2     ## copy of luA 
        movapd  %xmm7,%xmm6     ## copy of luB 
        mulpd   %xmm3,%xmm3     ## luA*luA 
        mulpd   %xmm7,%xmm7     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm1
        mulpd   %xmm0,%xmm3     ## rsqA*luA*luA 
        mulpd   %xmm4,%xmm7     ## rsqB*luB*luB         
        movapd  %xmm1,%xmm5
        subpd   %xmm3,%xmm1     ## 3-rsqA*luA*luA 
        subpd   %xmm7,%xmm5     ## 3-rsqB*luB*luB 
        mulpd   %xmm2,%xmm1     ## luA*(3-rsqA*luA*luA) 
        mulpd   %xmm6,%xmm5     ## luB*(3-rsqB*luB*luB) 
        mulpd   nb114nf_half(%rsp),%xmm1   ## rinv 
        mulpd   nb114nf_half(%rsp),%xmm5   ## rinv 
        movapd %xmm1,nb114nf_rinvMH1(%rsp)
        movapd %xmm5,nb114nf_rinvH2M(%rsp)

        ## start with OO interaction 
        movapd nb114nf_rinvsqOO(%rsp),%xmm0   ## xmm0=rinvsq
        movapd  %xmm0,%xmm1
        mulpd   %xmm1,%xmm1 ## rinv4
        mulpd   %xmm0,%xmm1 ##rinvsix
        movapd  %xmm1,%xmm2
        mulpd   %xmm2,%xmm2 ## rinvtwelve
        mulpd  nb114nf_c6(%rsp),%xmm1
        mulpd  nb114nf_c12(%rsp),%xmm2
        movapd %xmm2,%xmm3
        subpd  %xmm1,%xmm3      ## Vvdw=Vvdw12-Vvdw6            
        addpd  nb114nf_Vvdwtot(%rsp),%xmm3
        movapd %xmm3,nb114nf_Vvdwtot(%rsp)

        ## Coulomb interactions.
        ## Sum rinv for H-H interactions in xmm0, H-M in xmm1.
        ## Use xmm2 for the M-M pair
        movapd nb114nf_rinvH1H1(%rsp),%xmm0
        movapd nb114nf_rinvH1M(%rsp),%xmm1
        movapd nb114nf_rinvMM(%rsp),%xmm2

        addpd  nb114nf_rinvH1H2(%rsp),%xmm0
        addpd  nb114nf_rinvH2M(%rsp),%xmm1
        addpd  nb114nf_rinvH2H1(%rsp),%xmm0
        addpd  nb114nf_rinvMH1(%rsp),%xmm1
        addpd  nb114nf_rinvH2H2(%rsp),%xmm0
        addpd  nb114nf_rinvMH2(%rsp),%xmm1
        mulpd  nb114nf_qqHH(%rsp),%xmm0
        mulpd  nb114nf_qqMH(%rsp),%xmm1
        mulpd  nb114nf_qqMM(%rsp),%xmm2
        addpd  %xmm1,%xmm0
        addpd  nb114nf_vctot(%rsp),%xmm2
        addpd  %xmm0,%xmm2
        movapd %xmm2,nb114nf_vctot(%rsp)

        ## should we do one more iteration? 
        subl $2,nb114nf_innerk(%rsp)
        jl    _nb_kernel114nf_x86_64_sse2.nb114nf_checksingle
        jmp   _nb_kernel114nf_x86_64_sse2.nb114nf_unroll_loop
_nb_kernel114nf_x86_64_sse2.nb114nf_checksingle: 
        movl  nb114nf_innerk(%rsp),%edx
        andl  $1,%edx
        jnz   _nb_kernel114nf_x86_64_sse2.nb114nf_dosingle
        jmp   _nb_kernel114nf_x86_64_sse2.nb114nf_updateouterdata
_nb_kernel114nf_x86_64_sse2.nb114nf_dosingle: 
        movq  nb114nf_innerjjnr(%rsp),%rdx       ## pointer to jjnr[k] 
        movl  (%rdx),%eax

        movq nb114nf_pos(%rbp),%rsi        ## base of pos[] 

        lea  (%rax,%rax,2),%rax     ## replace jnr with j3 

        ## move j coordinates to local temp variables 
        ## load ox, oy, oz, h1x
        movlpd (%rsi,%rax,8),%xmm0
        movhpd 8(%rsi,%rax,8),%xmm0
        movlpd 16(%rsi,%rax,8),%xmm1
        movhpd 24(%rsi,%rax,8),%xmm1
        movlpd 32(%rsi,%rax,8),%xmm2
        movhpd 40(%rsi,%rax,8),%xmm2
        movlpd 48(%rsi,%rax,8),%xmm3
        movhpd 56(%rsi,%rax,8),%xmm3
        movlpd 64(%rsi,%rax,8),%xmm4
        movhpd 72(%rsi,%rax,8),%xmm4
        movlpd 80(%rsi,%rax,8),%xmm5
        movhpd 88(%rsi,%rax,8),%xmm5
        movsd  %xmm0,nb114nf_jxO(%rsp)
        movsd  %xmm1,nb114nf_jzO(%rsp)
        movsd  %xmm2,nb114nf_jyH1(%rsp)
        movsd  %xmm3,nb114nf_jxH2(%rsp)
        movsd  %xmm4,nb114nf_jzH2(%rsp)
        movsd  %xmm5,nb114nf_jyM(%rsp)
        unpckhpd %xmm0,%xmm0
        unpckhpd %xmm1,%xmm1
        unpckhpd %xmm2,%xmm2
        unpckhpd %xmm3,%xmm3
        unpckhpd %xmm4,%xmm4
        unpckhpd %xmm5,%xmm5
        movsd  %xmm0,nb114nf_jyO(%rsp)
        movsd  %xmm1,nb114nf_jxH1(%rsp)
        movsd  %xmm2,nb114nf_jzH1(%rsp)
        movsd  %xmm3,nb114nf_jyH2(%rsp)
        movsd  %xmm4,nb114nf_jxM(%rsp)
        movsd  %xmm5,nb114nf_jzM(%rsp)

        ## start calculating pairwise distances
        movapd nb114nf_ixO(%rsp),%xmm0
        movapd nb114nf_iyO(%rsp),%xmm1
        movapd nb114nf_izO(%rsp),%xmm2
        movapd nb114nf_ixH1(%rsp),%xmm3
        movapd nb114nf_iyH1(%rsp),%xmm4
        movapd nb114nf_izH1(%rsp),%xmm5
        subsd  nb114nf_jxO(%rsp),%xmm0
        subsd  nb114nf_jyO(%rsp),%xmm1
        subsd  nb114nf_jzO(%rsp),%xmm2
        subsd  nb114nf_jxH1(%rsp),%xmm3
        subsd  nb114nf_jyH1(%rsp),%xmm4
        subsd  nb114nf_jzH1(%rsp),%xmm5
        mulsd  %xmm0,%xmm0
        mulsd  %xmm1,%xmm1
        mulsd  %xmm2,%xmm2
        mulsd  %xmm3,%xmm3
        mulsd  %xmm4,%xmm4
        mulsd  %xmm5,%xmm5
        addsd  %xmm1,%xmm0
        addsd  %xmm2,%xmm0
        addsd  %xmm4,%xmm3
        addsd  %xmm5,%xmm3
        movapd %xmm0,nb114nf_rsqOO(%rsp)
        movapd %xmm3,nb114nf_rsqH1H1(%rsp)

        movapd nb114nf_ixH1(%rsp),%xmm0
        movapd nb114nf_iyH1(%rsp),%xmm1
        movapd nb114nf_izH1(%rsp),%xmm2
        movapd %xmm0,%xmm3
        movapd %xmm1,%xmm4
        movapd %xmm2,%xmm5
        subsd  nb114nf_jxH2(%rsp),%xmm0
        subsd  nb114nf_jyH2(%rsp),%xmm1
        subsd  nb114nf_jzH2(%rsp),%xmm2
        subsd  nb114nf_jxM(%rsp),%xmm3
        subsd  nb114nf_jyM(%rsp),%xmm4
        subsd  nb114nf_jzM(%rsp),%xmm5
        mulsd  %xmm0,%xmm0
        mulsd  %xmm1,%xmm1
        mulsd  %xmm2,%xmm2
        mulsd  %xmm3,%xmm3
        mulsd  %xmm4,%xmm4
        mulsd  %xmm5,%xmm5
        addsd  %xmm1,%xmm0
        addsd  %xmm2,%xmm0
        addsd  %xmm4,%xmm3
        addsd  %xmm5,%xmm3
        movapd %xmm0,nb114nf_rsqH1H2(%rsp)
        movapd %xmm3,nb114nf_rsqH1M(%rsp)

        movapd nb114nf_ixH2(%rsp),%xmm0
        movapd nb114nf_iyH2(%rsp),%xmm1
        movapd nb114nf_izH2(%rsp),%xmm2
        movapd %xmm0,%xmm3
        movapd %xmm1,%xmm4
        movapd %xmm2,%xmm5
        subsd  nb114nf_jxH1(%rsp),%xmm0
        subsd  nb114nf_jyH1(%rsp),%xmm1
        subsd  nb114nf_jzH1(%rsp),%xmm2
        subsd  nb114nf_jxH2(%rsp),%xmm3
        subsd  nb114nf_jyH2(%rsp),%xmm4
        subsd  nb114nf_jzH2(%rsp),%xmm5
        mulsd  %xmm0,%xmm0
        mulsd  %xmm1,%xmm1
        mulsd  %xmm2,%xmm2
        mulsd  %xmm3,%xmm3
        mulsd  %xmm4,%xmm4
        mulsd  %xmm5,%xmm5
        addsd  %xmm1,%xmm0
        addsd  %xmm2,%xmm0
        addsd  %xmm4,%xmm3
        addsd  %xmm5,%xmm3
        movapd %xmm0,nb114nf_rsqH2H1(%rsp)
        movapd %xmm3,nb114nf_rsqH2H2(%rsp)

        movapd nb114nf_ixH2(%rsp),%xmm0
        movapd nb114nf_iyH2(%rsp),%xmm1
        movapd nb114nf_izH2(%rsp),%xmm2
        movapd nb114nf_ixM(%rsp),%xmm3
        movapd nb114nf_iyM(%rsp),%xmm4
        movapd nb114nf_izM(%rsp),%xmm5
        subsd  nb114nf_jxM(%rsp),%xmm0
        subsd  nb114nf_jyM(%rsp),%xmm1
        subsd  nb114nf_jzM(%rsp),%xmm2
        subsd  nb114nf_jxH1(%rsp),%xmm3
        subsd  nb114nf_jyH1(%rsp),%xmm4
        subsd  nb114nf_jzH1(%rsp),%xmm5
        mulsd  %xmm0,%xmm0
        mulsd  %xmm1,%xmm1
        mulsd  %xmm2,%xmm2
        mulsd  %xmm3,%xmm3
        mulsd  %xmm4,%xmm4
        mulsd  %xmm5,%xmm5
        addsd  %xmm1,%xmm0
        addsd  %xmm2,%xmm0
        addsd  %xmm3,%xmm4
        addsd  %xmm5,%xmm4
        movapd %xmm0,nb114nf_rsqH2M(%rsp)
        movapd %xmm4,nb114nf_rsqMH1(%rsp)

        movapd nb114nf_ixM(%rsp),%xmm0
        movapd nb114nf_iyM(%rsp),%xmm1
        movapd nb114nf_izM(%rsp),%xmm2
        movapd %xmm0,%xmm3
        movapd %xmm1,%xmm4
        movapd %xmm2,%xmm5
        subsd  nb114nf_jxH2(%rsp),%xmm0
        subsd  nb114nf_jyH2(%rsp),%xmm1
        subsd  nb114nf_jzH2(%rsp),%xmm2
        subsd  nb114nf_jxM(%rsp),%xmm3
        subsd  nb114nf_jyM(%rsp),%xmm4
        subsd  nb114nf_jzM(%rsp),%xmm5
        mulsd  %xmm0,%xmm0
        mulsd  %xmm1,%xmm1
        mulsd  %xmm2,%xmm2
        mulsd  %xmm3,%xmm3
        mulsd  %xmm4,%xmm4
        mulsd  %xmm5,%xmm5
        addsd  %xmm1,%xmm0
        addsd  %xmm2,%xmm0
        addsd  %xmm3,%xmm4
        addsd  %xmm5,%xmm4
        movapd %xmm0,nb114nf_rsqMH2(%rsp)
        movapd %xmm4,nb114nf_rsqMM(%rsp)

        ## Invsqrt form rsq M-H2 (rsq in xmm0) and MM (rsq in xmm4) 
        cvtsd2ss %xmm0,%xmm1
        cvtsd2ss %xmm4,%xmm5
        rsqrtss %xmm1,%xmm1
        rsqrtss %xmm5,%xmm5
        cvtss2sd %xmm1,%xmm1  ## luA
        cvtss2sd %xmm5,%xmm5  ## luB

        movapd  %xmm1,%xmm2     ## copy of luA 
        movapd  %xmm5,%xmm6     ## copy of luB 
        mulsd   %xmm1,%xmm1     ## luA*luA 
        mulsd   %xmm5,%xmm5     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm3
        mulsd   %xmm0,%xmm1     ## rsqA*luA*luA 
        mulsd   %xmm4,%xmm5     ## rsqB*luB*luB         
        movapd  %xmm3,%xmm7
        subsd   %xmm1,%xmm3     ## 3-rsqA*luA*luA 
        subsd   %xmm5,%xmm7     ## 3-rsqB*luB*luB 
        mulsd   %xmm2,%xmm3     ## luA*(3-rsqA*luA*luA) 
        mulsd   %xmm6,%xmm7     ## luB*(3-rsqB*luB*luB) 
        mulsd   nb114nf_half(%rsp),%xmm3   ## iter1 
        mulsd   nb114nf_half(%rsp),%xmm7   ## iter1 

        movapd  %xmm3,%xmm2     ## copy of luA 
        movapd  %xmm7,%xmm6     ## copy of luB 
        mulsd   %xmm3,%xmm3     ## luA*luA 
        mulsd   %xmm7,%xmm7     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm1
        mulsd   %xmm0,%xmm3     ## rsqA*luA*luA 
        mulsd   %xmm4,%xmm7     ## rsqB*luB*luB         
        movapd  %xmm1,%xmm5
        subsd   %xmm3,%xmm1     ## 3-rsqA*luA*luA 
        subsd   %xmm7,%xmm5     ## 3-rsqB*luB*luB 
        mulsd   %xmm2,%xmm1     ## luA*(3-rsqA*luA*luA) 
        mulsd   %xmm6,%xmm5     ## luB*(3-rsqB*luB*luB) 
        mulsd   nb114nf_half(%rsp),%xmm1   ## rinv 
        mulsd   nb114nf_half(%rsp),%xmm5   ## rinv 
        movapd %xmm1,nb114nf_rinvMH2(%rsp)
        movapd %xmm5,nb114nf_rinvMM(%rsp)

        movapd nb114nf_rsqOO(%rsp),%xmm0
        movapd nb114nf_rsqH1H1(%rsp),%xmm4
        cvtsd2ss %xmm0,%xmm1
        cvtsd2ss %xmm4,%xmm5
        rsqrtss %xmm1,%xmm1
        rsqrtss %xmm5,%xmm5
        cvtss2sd %xmm1,%xmm1
        cvtss2sd %xmm5,%xmm5

        movapd  %xmm1,%xmm2     ## copy of luA 
        movapd  %xmm5,%xmm6     ## copy of luB 
        mulsd   %xmm1,%xmm1     ## luA*luA 
        mulsd   %xmm5,%xmm5     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm3
        mulsd   %xmm0,%xmm1     ## rsqA*luA*luA 
        mulsd   %xmm4,%xmm5     ## rsqB*luB*luB         
        movapd  %xmm3,%xmm7
        subsd   %xmm1,%xmm3     ## 3-rsqA*luA*luA 
        subsd   %xmm5,%xmm7     ## 3-rsqB*luB*luB 
        mulsd   %xmm2,%xmm3     ## luA*(3-rsqA*luA*luA) 
        mulsd   %xmm6,%xmm7     ## luB*(3-rsqB*luB*luB) 
        mulsd   nb114nf_half(%rsp),%xmm3   ## iter1 of  
        mulsd   nb114nf_half(%rsp),%xmm7   ## iter1 of  

        movapd  %xmm3,%xmm2     ## copy of luA 
        movapd  %xmm7,%xmm6     ## copy of luB 
        mulsd   %xmm3,%xmm3     ## luA*luA 
        mulsd   %xmm7,%xmm7     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm1
        mulsd   %xmm0,%xmm3     ## rsqA*luA*luA 
        mulsd   %xmm4,%xmm7     ## rsqB*luB*luB         
        movapd  %xmm1,%xmm5
        subsd   %xmm3,%xmm1     ## 3-rsqA*luA*luA 
        subsd   %xmm7,%xmm5     ## 3-rsqB*luB*luB 
        mulsd   %xmm2,%xmm1     ## luA*(3-rsqA*luA*luA) 
        mulsd   %xmm6,%xmm5     ## luB*(3-rsqB*luB*luB) 
        mulsd   nb114nf_half(%rsp),%xmm1   ## rinv 
        mulsd   nb114nf_half(%rsp),%xmm5   ## rinv
        mulpd   %xmm1,%xmm1
        movapd %xmm1,nb114nf_rinvsqOO(%rsp)
        movapd %xmm5,nb114nf_rinvH1H1(%rsp)

        movapd nb114nf_rsqH1H2(%rsp),%xmm0
        movapd nb114nf_rsqH1M(%rsp),%xmm4
        cvtsd2ss %xmm0,%xmm1
        cvtsd2ss %xmm4,%xmm5
        rsqrtss %xmm1,%xmm1
        rsqrtss %xmm5,%xmm5
        cvtss2sd %xmm1,%xmm1
        cvtss2sd %xmm5,%xmm5

        movapd  %xmm1,%xmm2     ## copy of luA 
        movapd  %xmm5,%xmm6     ## copy of luB 
        mulsd   %xmm1,%xmm1     ## luA*luA 
        mulsd   %xmm5,%xmm5     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm3
        mulsd   %xmm0,%xmm1     ## rsqA*luA*luA 
        mulsd   %xmm4,%xmm5     ## rsqB*luB*luB         
        movapd  %xmm3,%xmm7
        subsd   %xmm1,%xmm3     ## 3-rsqA*luA*luA 
        subsd   %xmm5,%xmm7     ## 3-rsqB*luB*luB 
        mulsd   %xmm2,%xmm3     ## luA*(3-rsqA*luA*luA) 
        mulsd   %xmm6,%xmm7     ## luB*(3-rsqB*luB*luB) 
        mulsd   nb114nf_half(%rsp),%xmm3   ## iter1 
        mulsd   nb114nf_half(%rsp),%xmm7   ## iter1 

        movapd  %xmm3,%xmm2     ## copy of luA 
        movapd  %xmm7,%xmm6     ## copy of luB 
        mulsd   %xmm3,%xmm3     ## luA*luA 
        mulsd   %xmm7,%xmm7     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm1
        mulsd   %xmm0,%xmm3     ## rsqA*luA*luA 
        mulsd   %xmm4,%xmm7     ## rsqB*luB*luB         
        movapd  %xmm1,%xmm5
        subsd   %xmm3,%xmm1     ## 3-rsqA*luA*luA 
        subsd   %xmm7,%xmm5     ## 3-rsqB*luB*luB 
        mulsd   %xmm2,%xmm1     ## luA*(3-rsqA*luA*luA) 
        mulsd   %xmm6,%xmm5     ## luB*(3-rsqB*luB*luB) 
        mulsd   nb114nf_half(%rsp),%xmm1   ## rinv 
        mulsd   nb114nf_half(%rsp),%xmm5   ## rinv 
        movapd %xmm1,nb114nf_rinvH1H2(%rsp)
        movapd %xmm5,nb114nf_rinvH1M(%rsp)

        movapd nb114nf_rsqH2H1(%rsp),%xmm0
        movapd nb114nf_rsqH2H2(%rsp),%xmm4
        cvtsd2ss %xmm0,%xmm1
        cvtsd2ss %xmm4,%xmm5
        rsqrtss %xmm1,%xmm1
        rsqrtss %xmm5,%xmm5
        cvtss2sd %xmm1,%xmm1
        cvtss2sd %xmm5,%xmm5

        movapd  %xmm1,%xmm2     ## copy of luA 
        movapd  %xmm5,%xmm6     ## copy of luB 
        mulsd   %xmm1,%xmm1     ## luA*luA 
        mulsd   %xmm5,%xmm5     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm3
        mulsd   %xmm0,%xmm1     ## rsqA*luA*luA 
        mulsd   %xmm4,%xmm5     ## rsqB*luB*luB         
        movapd  %xmm3,%xmm7
        subsd   %xmm1,%xmm3     ## 3-rsqA*luA*luA 
        subsd   %xmm5,%xmm7     ## 3-rsqB*luB*luB 
        mulsd   %xmm2,%xmm3     ## luA*(3-rsqA*luA*luA) 
        mulsd   %xmm6,%xmm7     ## luB*(3-rsqB*luB*luB) 
        mulsd   nb114nf_half(%rsp),%xmm3   ## iter1a 
        mulsd   nb114nf_half(%rsp),%xmm7   ## iter1b 

        movapd  %xmm3,%xmm2     ## copy of luA 
        movapd  %xmm7,%xmm6     ## copy of luB 
        mulsd   %xmm3,%xmm3     ## luA*luA 
        mulsd   %xmm7,%xmm7     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm1
        mulsd   %xmm0,%xmm3     ## rsqA*luA*luA 
        mulsd   %xmm4,%xmm7     ## rsqB*luB*luB         
        movapd  %xmm1,%xmm5
        subsd   %xmm3,%xmm1     ## 3-rsqA*luA*luA 
        subsd   %xmm7,%xmm5     ## 3-rsqB*luB*luB 
        mulsd   %xmm2,%xmm1     ## luA*(3-rsqA*luA*luA) 
        mulsd   %xmm6,%xmm5     ## luB*(3-rsqB*luB*luB) 
        mulsd   nb114nf_half(%rsp),%xmm1   ## rinv 
        mulsd   nb114nf_half(%rsp),%xmm5   ## rinv 
        movapd %xmm1,nb114nf_rinvH2H1(%rsp)
        movapd %xmm5,nb114nf_rinvH2H2(%rsp)

        movapd nb114nf_rsqMH1(%rsp),%xmm0
        movapd nb114nf_rsqH2M(%rsp),%xmm4
        cvtsd2ss %xmm0,%xmm1
        cvtsd2ss %xmm4,%xmm5
        rsqrtss %xmm1,%xmm1
        rsqrtss %xmm5,%xmm5
        cvtss2sd %xmm1,%xmm1
        cvtss2sd %xmm5,%xmm5

        movapd  %xmm1,%xmm2     ## copy of luA 
        movapd  %xmm5,%xmm6     ## copy of luB 
        mulsd   %xmm1,%xmm1     ## luA*luA 
        mulsd   %xmm5,%xmm5     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm3
        mulsd   %xmm0,%xmm1     ## rsqA*luA*luA 
        mulsd   %xmm4,%xmm5     ## rsqB*luB*luB         
        movapd  %xmm3,%xmm7
        subsd   %xmm1,%xmm3     ## 3-rsqA*luA*luA 
        subsd   %xmm5,%xmm7     ## 3-rsqB*luB*luB 
        mulsd   %xmm2,%xmm3     ## luA*(3-rsqA*luA*luA) 
        mulsd   %xmm6,%xmm7     ## luB*(3-rsqB*luB*luB) 
        mulsd   nb114nf_half(%rsp),%xmm3   ## iter1a 
        mulsd   nb114nf_half(%rsp),%xmm7   ## iter1b 

        movapd  %xmm3,%xmm2     ## copy of luA 
        movapd  %xmm7,%xmm6     ## copy of luB 
        mulsd   %xmm3,%xmm3     ## luA*luA 
        mulsd   %xmm7,%xmm7     ## luB*luB 
        movapd  nb114nf_three(%rsp),%xmm1
        mulsd   %xmm0,%xmm3     ## rsqA*luA*luA 
        mulsd   %xmm4,%xmm7     ## rsqB*luB*luB         
        movapd  %xmm1,%xmm5
        subsd   %xmm3,%xmm1     ## 3-rsqA*luA*luA 
        subsd   %xmm7,%xmm5     ## 3-rsqB*luB*luB 
        mulsd   %xmm2,%xmm1     ## luA*(3-rsqA*luA*luA) 
        mulsd   %xmm6,%xmm5     ## luB*(3-rsqB*luB*luB) 
        mulsd   nb114nf_half(%rsp),%xmm1   ## rinv 
        mulsd   nb114nf_half(%rsp),%xmm5   ## rinv 
        movapd %xmm1,nb114nf_rinvMH1(%rsp)
        movapd %xmm5,nb114nf_rinvH2M(%rsp)

        ## start with OO interaction 
        movsd nb114nf_rinvsqOO(%rsp),%xmm0   ## xmm0=rinvsq
        movapd  %xmm0,%xmm1
        mulsd   %xmm1,%xmm1 ## rinv4
        mulsd   %xmm0,%xmm1 ##rinvsix
        movsd  %xmm1,%xmm2
        mulsd   %xmm2,%xmm2 ## rinvtwelve
        mulsd  nb114nf_c6(%rsp),%xmm1
        mulsd  nb114nf_c12(%rsp),%xmm2
        movsd %xmm2,%xmm3
        subsd  %xmm1,%xmm3      ## Vvdw=Vvdw12-Vvdw6            
        addsd  nb114nf_Vvdwtot(%rsp),%xmm3
        movsd %xmm3,nb114nf_Vvdwtot(%rsp)

        ## Coulomb interactions.
        ## Sum rinv for H-H interactions in xmm0, H-M in xmm1.
        ## Use xmm2 for the M-M pair
        movsd nb114nf_rinvH1H1(%rsp),%xmm0
        movsd nb114nf_rinvH1M(%rsp),%xmm1
        movsd nb114nf_rinvMM(%rsp),%xmm2

        addsd  nb114nf_rinvH1H2(%rsp),%xmm0
        addsd  nb114nf_rinvH2M(%rsp),%xmm1
        addsd  nb114nf_rinvH2H1(%rsp),%xmm0
        addsd  nb114nf_rinvMH1(%rsp),%xmm1
        addsd  nb114nf_rinvH2H2(%rsp),%xmm0
        addsd  nb114nf_rinvMH2(%rsp),%xmm1
        mulsd  nb114nf_qqHH(%rsp),%xmm0
        mulsd  nb114nf_qqMH(%rsp),%xmm1
        mulsd  nb114nf_qqMM(%rsp),%xmm2
        addsd  %xmm1,%xmm0
        addsd  nb114nf_vctot(%rsp),%xmm2
        addsd  %xmm0,%xmm2
        movsd %xmm2,nb114nf_vctot(%rsp)


_nb_kernel114nf_x86_64_sse2.nb114nf_updateouterdata: 
        ## get n from stack
        movl nb114nf_n(%rsp),%esi
        ## get group index for i particle 
        movq  nb114nf_gid(%rbp),%rdx            ## base of gid[]
        movl  (%rdx,%rsi,4),%edx                ## ggid=gid[n]

        ## accumulate total potential energy and update it 
        movapd nb114nf_vctot(%rsp),%xmm7
        ## accumulate 
        movhlps %xmm7,%xmm6
        addsd  %xmm6,%xmm7      ## low xmm7 has the sum now 

        ## add earlier value from mem 
        movq  nb114nf_Vc(%rbp),%rax
        addsd (%rax,%rdx,8),%xmm7
        ## move back to mem 
        movsd %xmm7,(%rax,%rdx,8)

        ## accumulate total lj energy and update it 
        movapd nb114nf_Vvdwtot(%rsp),%xmm7
        ## accumulate 
        movhlps %xmm7,%xmm6
        addsd  %xmm6,%xmm7      ## low xmm7 has the sum now 

        ## add earlier value from mem 
        movq  nb114nf_Vvdw(%rbp),%rax
        addsd (%rax,%rdx,8),%xmm7
        ## move back to mem 
        movsd %xmm7,(%rax,%rdx,8)

        ## finish if last 
        movl nb114nf_nn1(%rsp),%ecx
        ## esi already loaded with n
        incl %esi
        subl %esi,%ecx
        jz _nb_kernel114nf_x86_64_sse2.nb114nf_outerend

        ## not last, iterate outer loop once more!  
        movl %esi,nb114nf_n(%rsp)
        jmp _nb_kernel114nf_x86_64_sse2.nb114nf_outer
_nb_kernel114nf_x86_64_sse2.nb114nf_outerend: 
        ## check if more outer neighborlists remain
        movl  nb114nf_nri(%rsp),%ecx
        ## esi already loaded with n above
        subl  %esi,%ecx
        jz _nb_kernel114nf_x86_64_sse2.nb114nf_end
        ## non-zero, do one more workunit
        jmp   _nb_kernel114nf_x86_64_sse2.nb114nf_threadloop
_nb_kernel114nf_x86_64_sse2.nb114nf_end: 
        movl nb114nf_nouter(%rsp),%eax
        movl nb114nf_ninner(%rsp),%ebx
        movq nb114nf_outeriter(%rbp),%rcx
        movq nb114nf_inneriter(%rbp),%rdx
        movl %eax,(%rcx)
        movl %ebx,(%rdx)

        addq $968,%rsp
        emms


        pop %r15
        pop %r14
        pop %r13
        pop %r12

        pop %rbx
        pop    %rbp
        ret



