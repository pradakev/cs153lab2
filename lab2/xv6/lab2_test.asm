
_lab2_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

int PScheduler(void);
int PScheduler2(void);

int main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
    // PScheduler();
    PScheduler2();
   6:	e8 65 01 00 00       	call   170 <PScheduler2>

    exit();
   b:	e8 f2 04 00 00       	call   502 <exit>

00000010 <PScheduler>:
}    
      
int PScheduler(void){
  10:	55                   	push   %ebp
  11:	89 e5                	mov    %esp,%ebp
  13:	53                   	push   %ebx
    printf(1, "Testing the priority scheduler and setpriority system call:\n");
    printf(1, "Assuming that the priorities range between range between 0 to 31\n");
    printf(1, "0 is the highest priority. All processes have a default priority of 10\n");
    printf(1, " - The parent processes will switch to priority 0\n");
    setpriority(0); // Use your own setpriority interface
    for (i = 0; i < 3; i++) {
  14:	31 db                	xor    %ebx,%ebx
int PScheduler(void){
  16:	83 ec 14             	sub    $0x14,%esp
    printf(1, "Testing the priority scheduler and setpriority system call:\n");
  19:	c7 44 24 04 b8 09 00 	movl   $0x9b8,0x4(%esp)
  20:	00 
  21:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  28:	e8 23 06 00 00       	call   650 <printf>
    printf(1, "Assuming that the priorities range between range between 0 to 31\n");
  2d:	c7 44 24 04 f8 09 00 	movl   $0x9f8,0x4(%esp)
  34:	00 
  35:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3c:	e8 0f 06 00 00       	call   650 <printf>
    printf(1, "0 is the highest priority. All processes have a default priority of 10\n");
  41:	c7 44 24 04 3c 0a 00 	movl   $0xa3c,0x4(%esp)
  48:	00 
  49:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  50:	e8 fb 05 00 00       	call   650 <printf>
    printf(1, " - The parent processes will switch to priority 0\n");
  55:	c7 44 24 04 84 0a 00 	movl   $0xa84,0x4(%esp)
  5c:	00 
  5d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  64:	e8 e7 05 00 00       	call   650 <printf>
    setpriority(0); // Use your own setpriority interface
  69:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  70:	e8 2d 05 00 00       	call   5a2 <setpriority>
	pid = fork();
  75:	e8 80 04 00 00       	call   4fa <fork>
	if (pid > 0) {
  7a:	83 f8 00             	cmp    $0x0,%eax
  7d:	7e 4b                	jle    ca <PScheduler+0xba>
    for (i = 0; i < 3; i++) {
  7f:	83 c3 01             	add    $0x1,%ebx
  82:	83 fb 03             	cmp    $0x3,%ebx
  85:	75 ee                	jne    75 <PScheduler+0x65>
  87:	bb 03 00 00 00       	mov    $0x3,%ebx
        }
    }

    if(pid > 0) {
        for (i = 0; i < 3; i++) {
            ret_pid = wait();
  8c:	e8 79 04 00 00       	call   50a <wait>
            printf(1, " - This is the parent: child with PID# %d has finished \n", ret_pid);
  91:	c7 44 24 04 2c 0b 00 	movl   $0xb2c,0x4(%esp)
  98:	00 
  99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  a4:	e8 a7 05 00 00       	call   650 <printf>
        for (i = 0; i < 3; i++) {
  a9:	83 eb 01             	sub    $0x1,%ebx
  ac:	75 de                	jne    8c <PScheduler+0x7c>
        }
        printf(1, " - If processes with highest priority finished first then its correct. \n");
  ae:	c7 44 24 04 68 0b 00 	movl   $0xb68,0x4(%esp)
  b5:	00 
  b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  bd:	e8 8e 05 00 00       	call   650 <printf>
    }
			
    return 0;
}
  c2:	83 c4 14             	add    $0x14,%esp
  c5:	31 c0                	xor    %eax,%eax
  c7:	5b                   	pop    %ebx
  c8:	5d                   	pop    %ebp
  c9:	c3                   	ret    
        } else if ( pid == 0) {
  ca:	75 7d                	jne    149 <PScheduler+0x139>
  cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            printf(1, " - Hello! this is child# %d and I will change my priority to %d \n", getpid(), 60 - 20 * i);
  d0:	e8 ad 04 00 00       	call   582 <getpid>
  d5:	6b d3 ec             	imul   $0xffffffec,%ebx,%edx
            setpriority(30 - 10 * i); // Use your own setpriority interface
  d8:	6b db f6             	imul   $0xfffffff6,%ebx,%ebx
            printf(1, " - Hello! this is child# %d and I will change my priority to %d \n", getpid(), 60 - 20 * i);
  db:	c7 44 24 04 b8 0a 00 	movl   $0xab8,0x4(%esp)
  e2:	00 
  e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ea:	83 c2 3c             	add    $0x3c,%edx
  ed:	89 54 24 0c          	mov    %edx,0xc(%esp)
            setpriority(30 - 10 * i); // Use your own setpriority interface
  f1:	83 c3 1e             	add    $0x1e,%ebx
            printf(1, " - Hello! this is child# %d and I will change my priority to %d \n", getpid(), 60 - 20 * i);
  f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  f8:	e8 53 05 00 00       	call   650 <printf>
            setpriority(30 - 10 * i); // Use your own setpriority interface
  fd:	89 1c 24             	mov    %ebx,(%esp)
 100:	e8 9d 04 00 00       	call   5a2 <setpriority>
 105:	ba 50 c3 00 00       	mov    $0xc350,%edx
 10a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
                asm("nop");
 110:	90                   	nop
 111:	b8 10 27 00 00       	mov    $0x2710,%eax
 116:	66 90                	xchg   %ax,%ax
                    asm("nop"); 
 118:	90                   	nop
                for(k = 0; k < 10000; k++) {
 119:	83 e8 01             	sub    $0x1,%eax
 11c:	75 fa                	jne    118 <PScheduler+0x108>
            for (j = 0; j < 50000; j++) {
 11e:	83 ea 01             	sub    $0x1,%edx
 121:	75 ed                	jne    110 <PScheduler+0x100>
            printf(1, " - Child #%d with priority %d has finished! \n", getpid(), 30-10*i);		
 123:	e8 5a 04 00 00       	call   582 <getpid>
 128:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 12c:	c7 44 24 04 fc 0a 00 	movl   $0xafc,0x4(%esp)
 133:	00 
 134:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13b:	89 44 24 08          	mov    %eax,0x8(%esp)
 13f:	e8 0c 05 00 00       	call   650 <printf>
            exit();
 144:	e8 b9 03 00 00       	call   502 <exit>
            printf(2," \n Error fork() \n");
 149:	c7 44 24 04 00 0c 00 	movl   $0xc00,0x4(%esp)
 150:	00 
 151:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 158:	e8 f3 04 00 00       	call   650 <printf>
            exit();
 15d:	e8 a0 03 00 00       	call   502 <exit>
 162:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000170 <PScheduler2>:


int PScheduler2(void){
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
 173:	53                   	push   %ebx
 174:	83 ec 14             	sub    $0x14,%esp
    // You can use your own priority range/value setup

    int pid, ret_pid;
    int i,j,k;
  
    printf(1, "Testing the aging:\n");
 177:	c7 44 24 04 12 0c 00 	movl   $0xc12,0x4(%esp)
 17e:	00 
 17f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 186:	e8 c5 04 00 00       	call   650 <printf>
    printf(1, "Assuming that the priorities range between range between 0 to 31\n");
 18b:	c7 44 24 04 f8 09 00 	movl   $0x9f8,0x4(%esp)
 192:	00 
 193:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 19a:	e8 b1 04 00 00       	call   650 <printf>
    printf(1, "0 is the highest priority. All processes have a default priority of 10\n");
 19f:	c7 44 24 04 3c 0a 00 	movl   $0xa3c,0x4(%esp)
 1a6:	00 
 1a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1ae:	e8 9d 04 00 00       	call   650 <printf>
    printf(1, " - The parent processes will switch to priority 0\n");
 1b3:	c7 44 24 04 84 0a 00 	movl   $0xa84,0x4(%esp)
 1ba:	00 
 1bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c2:	e8 89 04 00 00       	call   650 <printf>
    setpriority(0); // Use your own setpriority interface
 1c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1ce:	e8 cf 03 00 00       	call   5a2 <setpriority>
    for (i = 0; i < 2; i++) {
	pid = fork();
 1d3:	e8 22 03 00 00       	call   4fa <fork>
	if (pid > 0) {
 1d8:	85 c0                	test   %eax,%eax
 1da:	7e 68                	jle    244 <PScheduler2+0xd4>
 1dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	pid = fork();
 1e0:	e8 15 03 00 00       	call   4fa <fork>
    for (i = 0; i < 2; i++) {
 1e5:	ba 01 00 00 00       	mov    $0x1,%edx
	if (pid > 0) {
 1ea:	85 c0                	test   %eax,%eax
 1ec:	7e 58                	jle    246 <PScheduler2+0xd6>
        }
    }

    if(pid > 0) {
        for (i = 0; i < 2; i++) {
            ret_pid = wait();
 1ee:	e8 17 03 00 00       	call   50a <wait>
            printf(1, " - This is the parent: child with PID# %d has finished \n", ret_pid);
 1f3:	c7 44 24 04 2c 0b 00 	movl   $0xb2c,0x4(%esp)
 1fa:	00 
 1fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 202:	89 44 24 08          	mov    %eax,0x8(%esp)
 206:	e8 45 04 00 00       	call   650 <printf>
            ret_pid = wait();
 20b:	e8 fa 02 00 00       	call   50a <wait>
            printf(1, " - This is the parent: child with PID# %d has finished \n", ret_pid);
 210:	c7 44 24 04 2c 0b 00 	movl   $0xb2c,0x4(%esp)
 217:	00 
 218:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 21f:	89 44 24 08          	mov    %eax,0x8(%esp)
 223:	e8 28 04 00 00       	call   650 <printf>
        }
        printf(1, " - If processes with highest wait time finished first then its correct. \n");
 228:	c7 44 24 04 b4 0b 00 	movl   $0xbb4,0x4(%esp)
 22f:	00 
 230:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 237:	e8 14 04 00 00       	call   650 <printf>
    }
			
    return 0;
 23c:	83 c4 14             	add    $0x14,%esp
 23f:	31 c0                	xor    %eax,%eax
 241:	5b                   	pop    %ebx
 242:	5d                   	pop    %ebp
 243:	c3                   	ret    
    for (i = 0; i < 2; i++) {
 244:	31 d2                	xor    %edx,%edx
        } else if ( pid == 0) {
 246:	85 c0                	test   %eax,%eax
 248:	75 77                	jne    2c1 <PScheduler2+0x151>
            printf(1, " - Hello! this is child# %d and I will change my priority to %d \n", getpid(), 21 * i + 3);
 24a:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
 251:	01 d0                	add    %edx,%eax
 253:	8d 5c 82 03          	lea    0x3(%edx,%eax,4),%ebx
 257:	e8 26 03 00 00       	call   582 <getpid>
 25c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 260:	c7 44 24 04 b8 0a 00 	movl   $0xab8,0x4(%esp)
 267:	00 
 268:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 26f:	89 44 24 08          	mov    %eax,0x8(%esp)
 273:	e8 d8 03 00 00       	call   650 <printf>
            setpriority(21 * i + 3); // Use your own setpriority interface
 278:	89 1c 24             	mov    %ebx,(%esp)
 27b:	e8 22 03 00 00       	call   5a2 <setpriority>
 280:	ba 50 c3 00 00       	mov    $0xc350,%edx
 285:	8d 76 00             	lea    0x0(%esi),%esi
                asm("nop");
 288:	90                   	nop
 289:	b8 10 27 00 00       	mov    $0x2710,%eax
 28e:	66 90                	xchg   %ax,%ax
                    asm("nop"); 
 290:	90                   	nop
                for(k = 0; k < 10000; k++) {
 291:	83 e8 01             	sub    $0x1,%eax
 294:	75 fa                	jne    290 <PScheduler2+0x120>
            for (j = 0; j < 50000; j++) {
 296:	83 ea 01             	sub    $0x1,%edx
 299:	75 ed                	jne    288 <PScheduler2+0x118>
            printf(1, " - Child #%d with priority %d has finished! \n", getpid(), 21*i + 3);		
 29b:	e8 e2 02 00 00       	call   582 <getpid>
 2a0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 2a4:	c7 44 24 04 fc 0a 00 	movl   $0xafc,0x4(%esp)
 2ab:	00 
 2ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2b3:	89 44 24 08          	mov    %eax,0x8(%esp)
 2b7:	e8 94 03 00 00       	call   650 <printf>
            exit();
 2bc:	e8 41 02 00 00       	call   502 <exit>
            printf(2," \n Error fork() \n");
 2c1:	c7 44 24 04 00 0c 00 	movl   $0xc00,0x4(%esp)
 2c8:	00 
 2c9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 2d0:	e8 7b 03 00 00       	call   650 <printf>
            exit();
 2d5:	e8 28 02 00 00       	call   502 <exit>
 2da:	66 90                	xchg   %ax,%ax
 2dc:	66 90                	xchg   %ax,%ax
 2de:	66 90                	xchg   %ax,%ax

000002e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2e9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ea:	89 c2                	mov    %eax,%edx
 2ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2f0:	83 c1 01             	add    $0x1,%ecx
 2f3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 2f7:	83 c2 01             	add    $0x1,%edx
 2fa:	84 db                	test   %bl,%bl
 2fc:	88 5a ff             	mov    %bl,-0x1(%edx)
 2ff:	75 ef                	jne    2f0 <strcpy+0x10>
    ;
  return os;
}
 301:	5b                   	pop    %ebx
 302:	5d                   	pop    %ebp
 303:	c3                   	ret    
 304:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 30a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000310 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	8b 55 08             	mov    0x8(%ebp),%edx
 316:	53                   	push   %ebx
 317:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 31a:	0f b6 02             	movzbl (%edx),%eax
 31d:	84 c0                	test   %al,%al
 31f:	74 2d                	je     34e <strcmp+0x3e>
 321:	0f b6 19             	movzbl (%ecx),%ebx
 324:	38 d8                	cmp    %bl,%al
 326:	74 0e                	je     336 <strcmp+0x26>
 328:	eb 2b                	jmp    355 <strcmp+0x45>
 32a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 330:	38 c8                	cmp    %cl,%al
 332:	75 15                	jne    349 <strcmp+0x39>
    p++, q++;
 334:	89 d9                	mov    %ebx,%ecx
 336:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 339:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 33c:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 33f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 343:	84 c0                	test   %al,%al
 345:	75 e9                	jne    330 <strcmp+0x20>
 347:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 349:	29 c8                	sub    %ecx,%eax
}
 34b:	5b                   	pop    %ebx
 34c:	5d                   	pop    %ebp
 34d:	c3                   	ret    
 34e:	0f b6 09             	movzbl (%ecx),%ecx
  while(*p && *p == *q)
 351:	31 c0                	xor    %eax,%eax
 353:	eb f4                	jmp    349 <strcmp+0x39>
 355:	0f b6 cb             	movzbl %bl,%ecx
 358:	eb ef                	jmp    349 <strcmp+0x39>
 35a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000360 <strlen>:

uint
strlen(const char *s)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 366:	80 39 00             	cmpb   $0x0,(%ecx)
 369:	74 12                	je     37d <strlen+0x1d>
 36b:	31 d2                	xor    %edx,%edx
 36d:	8d 76 00             	lea    0x0(%esi),%esi
 370:	83 c2 01             	add    $0x1,%edx
 373:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 377:	89 d0                	mov    %edx,%eax
 379:	75 f5                	jne    370 <strlen+0x10>
    ;
  return n;
}
 37b:	5d                   	pop    %ebp
 37c:	c3                   	ret    
  for(n = 0; s[n]; n++)
 37d:	31 c0                	xor    %eax,%eax
}
 37f:	5d                   	pop    %ebp
 380:	c3                   	ret    
 381:	eb 0d                	jmp    390 <memset>
 383:	90                   	nop
 384:	90                   	nop
 385:	90                   	nop
 386:	90                   	nop
 387:	90                   	nop
 388:	90                   	nop
 389:	90                   	nop
 38a:	90                   	nop
 38b:	90                   	nop
 38c:	90                   	nop
 38d:	90                   	nop
 38e:	90                   	nop
 38f:	90                   	nop

00000390 <memset>:

void*
memset(void *dst, int c, uint n)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	8b 55 08             	mov    0x8(%ebp),%edx
 396:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 397:	8b 4d 10             	mov    0x10(%ebp),%ecx
 39a:	8b 45 0c             	mov    0xc(%ebp),%eax
 39d:	89 d7                	mov    %edx,%edi
 39f:	fc                   	cld    
 3a0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3a2:	89 d0                	mov    %edx,%eax
 3a4:	5f                   	pop    %edi
 3a5:	5d                   	pop    %ebp
 3a6:	c3                   	ret    
 3a7:	89 f6                	mov    %esi,%esi
 3a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003b0 <strchr>:

char*
strchr(const char *s, char c)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	53                   	push   %ebx
 3b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 3ba:	0f b6 18             	movzbl (%eax),%ebx
 3bd:	84 db                	test   %bl,%bl
 3bf:	74 1d                	je     3de <strchr+0x2e>
    if(*s == c)
 3c1:	38 d3                	cmp    %dl,%bl
 3c3:	89 d1                	mov    %edx,%ecx
 3c5:	75 0d                	jne    3d4 <strchr+0x24>
 3c7:	eb 17                	jmp    3e0 <strchr+0x30>
 3c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3d0:	38 ca                	cmp    %cl,%dl
 3d2:	74 0c                	je     3e0 <strchr+0x30>
  for(; *s; s++)
 3d4:	83 c0 01             	add    $0x1,%eax
 3d7:	0f b6 10             	movzbl (%eax),%edx
 3da:	84 d2                	test   %dl,%dl
 3dc:	75 f2                	jne    3d0 <strchr+0x20>
      return (char*)s;
  return 0;
 3de:	31 c0                	xor    %eax,%eax
}
 3e0:	5b                   	pop    %ebx
 3e1:	5d                   	pop    %ebp
 3e2:	c3                   	ret    
 3e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003f0 <gets>:

char*
gets(char *buf, int max)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3f5:	31 f6                	xor    %esi,%esi
{
 3f7:	53                   	push   %ebx
 3f8:	83 ec 2c             	sub    $0x2c,%esp
    cc = read(0, &c, 1);
 3fb:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 3fe:	eb 31                	jmp    431 <gets+0x41>
    cc = read(0, &c, 1);
 400:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 407:	00 
 408:	89 7c 24 04          	mov    %edi,0x4(%esp)
 40c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 413:	e8 02 01 00 00       	call   51a <read>
    if(cc < 1)
 418:	85 c0                	test   %eax,%eax
 41a:	7e 1d                	jle    439 <gets+0x49>
      break;
    buf[i++] = c;
 41c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  for(i=0; i+1 < max; ){
 420:	89 de                	mov    %ebx,%esi
    buf[i++] = c;
 422:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 425:	3c 0d                	cmp    $0xd,%al
    buf[i++] = c;
 427:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 42b:	74 0c                	je     439 <gets+0x49>
 42d:	3c 0a                	cmp    $0xa,%al
 42f:	74 08                	je     439 <gets+0x49>
  for(i=0; i+1 < max; ){
 431:	8d 5e 01             	lea    0x1(%esi),%ebx
 434:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 437:	7c c7                	jl     400 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 439:	8b 45 08             	mov    0x8(%ebp),%eax
 43c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 440:	83 c4 2c             	add    $0x2c,%esp
 443:	5b                   	pop    %ebx
 444:	5e                   	pop    %esi
 445:	5f                   	pop    %edi
 446:	5d                   	pop    %ebp
 447:	c3                   	ret    
 448:	90                   	nop
 449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000450 <stat>:

int
stat(const char *n, struct stat *st)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	56                   	push   %esi
 454:	53                   	push   %ebx
 455:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 458:	8b 45 08             	mov    0x8(%ebp),%eax
 45b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 462:	00 
 463:	89 04 24             	mov    %eax,(%esp)
 466:	e8 d7 00 00 00       	call   542 <open>
  if(fd < 0)
 46b:	85 c0                	test   %eax,%eax
  fd = open(n, O_RDONLY);
 46d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 46f:	78 27                	js     498 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 471:	8b 45 0c             	mov    0xc(%ebp),%eax
 474:	89 1c 24             	mov    %ebx,(%esp)
 477:	89 44 24 04          	mov    %eax,0x4(%esp)
 47b:	e8 da 00 00 00       	call   55a <fstat>
  close(fd);
 480:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 483:	89 c6                	mov    %eax,%esi
  close(fd);
 485:	e8 a0 00 00 00       	call   52a <close>
  return r;
 48a:	89 f0                	mov    %esi,%eax
}
 48c:	83 c4 10             	add    $0x10,%esp
 48f:	5b                   	pop    %ebx
 490:	5e                   	pop    %esi
 491:	5d                   	pop    %ebp
 492:	c3                   	ret    
 493:	90                   	nop
 494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 49d:	eb ed                	jmp    48c <stat+0x3c>
 49f:	90                   	nop

000004a0 <atoi>:

int
atoi(const char *s)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4a6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4a7:	0f be 11             	movsbl (%ecx),%edx
 4aa:	8d 42 d0             	lea    -0x30(%edx),%eax
 4ad:	3c 09                	cmp    $0x9,%al
  n = 0;
 4af:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 4b4:	77 17                	ja     4cd <atoi+0x2d>
 4b6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 4b8:	83 c1 01             	add    $0x1,%ecx
 4bb:	8d 04 80             	lea    (%eax,%eax,4),%eax
 4be:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 4c2:	0f be 11             	movsbl (%ecx),%edx
 4c5:	8d 5a d0             	lea    -0x30(%edx),%ebx
 4c8:	80 fb 09             	cmp    $0x9,%bl
 4cb:	76 eb                	jbe    4b8 <atoi+0x18>
  return n;
}
 4cd:	5b                   	pop    %ebx
 4ce:	5d                   	pop    %ebp
 4cf:	c3                   	ret    

000004d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4d0:	55                   	push   %ebp
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4d1:	31 d2                	xor    %edx,%edx
{
 4d3:	89 e5                	mov    %esp,%ebp
 4d5:	56                   	push   %esi
 4d6:	8b 45 08             	mov    0x8(%ebp),%eax
 4d9:	53                   	push   %ebx
 4da:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4dd:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n-- > 0)
 4e0:	85 db                	test   %ebx,%ebx
 4e2:	7e 12                	jle    4f6 <memmove+0x26>
 4e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 4e8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 4ec:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 4ef:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 4f2:	39 da                	cmp    %ebx,%edx
 4f4:	75 f2                	jne    4e8 <memmove+0x18>
  return vdst;
}
 4f6:	5b                   	pop    %ebx
 4f7:	5e                   	pop    %esi
 4f8:	5d                   	pop    %ebp
 4f9:	c3                   	ret    

000004fa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4fa:	b8 01 00 00 00       	mov    $0x1,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <exit>:
SYSCALL(exit)
 502:	b8 02 00 00 00       	mov    $0x2,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <wait>:
SYSCALL(wait)
 50a:	b8 03 00 00 00       	mov    $0x3,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <pipe>:
SYSCALL(pipe)
 512:	b8 04 00 00 00       	mov    $0x4,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <read>:
SYSCALL(read)
 51a:	b8 05 00 00 00       	mov    $0x5,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <write>:
SYSCALL(write)
 522:	b8 10 00 00 00       	mov    $0x10,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <close>:
SYSCALL(close)
 52a:	b8 15 00 00 00       	mov    $0x15,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <kill>:
SYSCALL(kill)
 532:	b8 06 00 00 00       	mov    $0x6,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <exec>:
SYSCALL(exec)
 53a:	b8 07 00 00 00       	mov    $0x7,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <open>:
SYSCALL(open)
 542:	b8 0f 00 00 00       	mov    $0xf,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <mknod>:
SYSCALL(mknod)
 54a:	b8 11 00 00 00       	mov    $0x11,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <unlink>:
SYSCALL(unlink)
 552:	b8 12 00 00 00       	mov    $0x12,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <fstat>:
SYSCALL(fstat)
 55a:	b8 08 00 00 00       	mov    $0x8,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <link>:
SYSCALL(link)
 562:	b8 13 00 00 00       	mov    $0x13,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <mkdir>:
SYSCALL(mkdir)
 56a:	b8 14 00 00 00       	mov    $0x14,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <chdir>:
SYSCALL(chdir)
 572:	b8 09 00 00 00       	mov    $0x9,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <dup>:
SYSCALL(dup)
 57a:	b8 0a 00 00 00       	mov    $0xa,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <getpid>:
SYSCALL(getpid)
 582:	b8 0b 00 00 00       	mov    $0xb,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <sbrk>:
SYSCALL(sbrk)
 58a:	b8 0c 00 00 00       	mov    $0xc,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <sleep>:
SYSCALL(sleep)
 592:	b8 0d 00 00 00       	mov    $0xd,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <uptime>:
SYSCALL(uptime)
 59a:	b8 0e 00 00 00       	mov    $0xe,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <setpriority>:
SYSCALL(setpriority) // kevin prada
 5a2:	b8 16 00 00 00       	mov    $0x16,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    
 5aa:	66 90                	xchg   %ax,%ax
 5ac:	66 90                	xchg   %ax,%ax
 5ae:	66 90                	xchg   %ax,%ax

000005b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	57                   	push   %edi
 5b4:	56                   	push   %esi
 5b5:	89 c6                	mov    %eax,%esi
 5b7:	53                   	push   %ebx
 5b8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 5be:	85 db                	test   %ebx,%ebx
 5c0:	74 09                	je     5cb <printint+0x1b>
 5c2:	89 d0                	mov    %edx,%eax
 5c4:	c1 e8 1f             	shr    $0x1f,%eax
 5c7:	84 c0                	test   %al,%al
 5c9:	75 75                	jne    640 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5cb:	89 d0                	mov    %edx,%eax
  neg = 0;
 5cd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5d4:	89 75 c0             	mov    %esi,-0x40(%ebp)
  }

  i = 0;
 5d7:	31 ff                	xor    %edi,%edi
 5d9:	89 ce                	mov    %ecx,%esi
 5db:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 5de:	eb 02                	jmp    5e2 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 5e0:	89 cf                	mov    %ecx,%edi
 5e2:	31 d2                	xor    %edx,%edx
 5e4:	f7 f6                	div    %esi
 5e6:	8d 4f 01             	lea    0x1(%edi),%ecx
 5e9:	0f b6 92 2d 0c 00 00 	movzbl 0xc2d(%edx),%edx
  }while((x /= base) != 0);
 5f0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 5f2:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 5f5:	75 e9                	jne    5e0 <printint+0x30>
  if(neg)
 5f7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    buf[i++] = digits[x % base];
 5fa:	89 c8                	mov    %ecx,%eax
 5fc:	8b 75 c0             	mov    -0x40(%ebp),%esi
  if(neg)
 5ff:	85 d2                	test   %edx,%edx
 601:	74 08                	je     60b <printint+0x5b>
    buf[i++] = '-';
 603:	8d 4f 02             	lea    0x2(%edi),%ecx
 606:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 60b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 60e:	66 90                	xchg   %ax,%ax
 610:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 615:	83 ef 01             	sub    $0x1,%edi
  write(fd, &c, 1);
 618:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 61f:	00 
 620:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 624:	89 34 24             	mov    %esi,(%esp)
 627:	88 45 d7             	mov    %al,-0x29(%ebp)
 62a:	e8 f3 fe ff ff       	call   522 <write>
  while(--i >= 0)
 62f:	83 ff ff             	cmp    $0xffffffff,%edi
 632:	75 dc                	jne    610 <printint+0x60>
    putc(fd, buf[i]);
}
 634:	83 c4 4c             	add    $0x4c,%esp
 637:	5b                   	pop    %ebx
 638:	5e                   	pop    %esi
 639:	5f                   	pop    %edi
 63a:	5d                   	pop    %ebp
 63b:	c3                   	ret    
 63c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    x = -xx;
 640:	89 d0                	mov    %edx,%eax
 642:	f7 d8                	neg    %eax
    neg = 1;
 644:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 64b:	eb 87                	jmp    5d4 <printint+0x24>
 64d:	8d 76 00             	lea    0x0(%esi),%esi

00000650 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 654:	31 ff                	xor    %edi,%edi
{
 656:	56                   	push   %esi
 657:	53                   	push   %ebx
 658:	83 ec 3c             	sub    $0x3c,%esp
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 65b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  ap = (uint*)(void*)&fmt + 1;
 65e:	8d 45 10             	lea    0x10(%ebp),%eax
{
 661:	8b 75 08             	mov    0x8(%ebp),%esi
  ap = (uint*)(void*)&fmt + 1;
 664:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 667:	0f b6 13             	movzbl (%ebx),%edx
 66a:	83 c3 01             	add    $0x1,%ebx
 66d:	84 d2                	test   %dl,%dl
 66f:	75 39                	jne    6aa <printf+0x5a>
 671:	e9 c2 00 00 00       	jmp    738 <printf+0xe8>
 676:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 678:	83 fa 25             	cmp    $0x25,%edx
 67b:	0f 84 bf 00 00 00    	je     740 <printf+0xf0>
  write(fd, &c, 1);
 681:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 684:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 68b:	00 
 68c:	89 44 24 04          	mov    %eax,0x4(%esp)
 690:	89 34 24             	mov    %esi,(%esp)
        state = '%';
      } else {
        putc(fd, c);
 693:	88 55 e2             	mov    %dl,-0x1e(%ebp)
  write(fd, &c, 1);
 696:	e8 87 fe ff ff       	call   522 <write>
 69b:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; fmt[i]; i++){
 69e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 6a2:	84 d2                	test   %dl,%dl
 6a4:	0f 84 8e 00 00 00    	je     738 <printf+0xe8>
    if(state == 0){
 6aa:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 6ac:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 6af:	74 c7                	je     678 <printf+0x28>
      }
    } else if(state == '%'){
 6b1:	83 ff 25             	cmp    $0x25,%edi
 6b4:	75 e5                	jne    69b <printf+0x4b>
      if(c == 'd'){
 6b6:	83 fa 64             	cmp    $0x64,%edx
 6b9:	0f 84 31 01 00 00    	je     7f0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6bf:	25 f7 00 00 00       	and    $0xf7,%eax
 6c4:	83 f8 70             	cmp    $0x70,%eax
 6c7:	0f 84 83 00 00 00    	je     750 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6cd:	83 fa 73             	cmp    $0x73,%edx
 6d0:	0f 84 a2 00 00 00    	je     778 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6d6:	83 fa 63             	cmp    $0x63,%edx
 6d9:	0f 84 35 01 00 00    	je     814 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6df:	83 fa 25             	cmp    $0x25,%edx
 6e2:	0f 84 e0 00 00 00    	je     7c8 <printf+0x178>
  write(fd, &c, 1);
 6e8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 6eb:	83 c3 01             	add    $0x1,%ebx
 6ee:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6f5:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6f6:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 6f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6fc:	89 34 24             	mov    %esi,(%esp)
 6ff:	89 55 d0             	mov    %edx,-0x30(%ebp)
 702:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 706:	e8 17 fe ff ff       	call   522 <write>
        putc(fd, c);
 70b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  write(fd, &c, 1);
 70e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 711:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 718:	00 
 719:	89 44 24 04          	mov    %eax,0x4(%esp)
 71d:	89 34 24             	mov    %esi,(%esp)
        putc(fd, c);
 720:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 723:	e8 fa fd ff ff       	call   522 <write>
  for(i = 0; fmt[i]; i++){
 728:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 72c:	84 d2                	test   %dl,%dl
 72e:	0f 85 76 ff ff ff    	jne    6aa <printf+0x5a>
 734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }
}
 738:	83 c4 3c             	add    $0x3c,%esp
 73b:	5b                   	pop    %ebx
 73c:	5e                   	pop    %esi
 73d:	5f                   	pop    %edi
 73e:	5d                   	pop    %ebp
 73f:	c3                   	ret    
        state = '%';
 740:	bf 25 00 00 00       	mov    $0x25,%edi
 745:	e9 51 ff ff ff       	jmp    69b <printf+0x4b>
 74a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 750:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 753:	b9 10 00 00 00       	mov    $0x10,%ecx
      state = 0;
 758:	31 ff                	xor    %edi,%edi
        printint(fd, *ap, 16, 0);
 75a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 761:	8b 10                	mov    (%eax),%edx
 763:	89 f0                	mov    %esi,%eax
 765:	e8 46 fe ff ff       	call   5b0 <printint>
        ap++;
 76a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 76e:	e9 28 ff ff ff       	jmp    69b <printf+0x4b>
 773:	90                   	nop
 774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 778:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 77b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        s = (char*)*ap;
 77f:	8b 38                	mov    (%eax),%edi
          s = "(null)";
 781:	b8 26 0c 00 00       	mov    $0xc26,%eax
 786:	85 ff                	test   %edi,%edi
 788:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 78b:	0f b6 07             	movzbl (%edi),%eax
 78e:	84 c0                	test   %al,%al
 790:	74 2a                	je     7bc <printf+0x16c>
 792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 798:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 79b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
          s++;
 79e:	83 c7 01             	add    $0x1,%edi
  write(fd, &c, 1);
 7a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7a8:	00 
 7a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ad:	89 34 24             	mov    %esi,(%esp)
 7b0:	e8 6d fd ff ff       	call   522 <write>
        while(*s != 0){
 7b5:	0f b6 07             	movzbl (%edi),%eax
 7b8:	84 c0                	test   %al,%al
 7ba:	75 dc                	jne    798 <printf+0x148>
      state = 0;
 7bc:	31 ff                	xor    %edi,%edi
 7be:	e9 d8 fe ff ff       	jmp    69b <printf+0x4b>
 7c3:	90                   	nop
 7c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 7c8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      state = 0;
 7cb:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 7cd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7d4:	00 
 7d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d9:	89 34 24             	mov    %esi,(%esp)
 7dc:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 7e0:	e8 3d fd ff ff       	call   522 <write>
 7e5:	e9 b1 fe ff ff       	jmp    69b <printf+0x4b>
 7ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 7f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 7f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
      state = 0;
 7f8:	66 31 ff             	xor    %di,%di
        printint(fd, *ap, 10, 1);
 7fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 802:	8b 10                	mov    (%eax),%edx
 804:	89 f0                	mov    %esi,%eax
 806:	e8 a5 fd ff ff       	call   5b0 <printint>
        ap++;
 80b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 80f:	e9 87 fe ff ff       	jmp    69b <printf+0x4b>
        putc(fd, *ap);
 814:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      state = 0;
 817:	31 ff                	xor    %edi,%edi
        putc(fd, *ap);
 819:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 81b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 822:	00 
 823:	89 34 24             	mov    %esi,(%esp)
        putc(fd, *ap);
 826:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 829:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 82c:	89 44 24 04          	mov    %eax,0x4(%esp)
 830:	e8 ed fc ff ff       	call   522 <write>
        ap++;
 835:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 839:	e9 5d fe ff ff       	jmp    69b <printf+0x4b>
 83e:	66 90                	xchg   %ax,%ax

00000840 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 840:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 841:	a1 f4 0e 00 00       	mov    0xef4,%eax
{
 846:	89 e5                	mov    %esp,%ebp
 848:	57                   	push   %edi
 849:	56                   	push   %esi
 84a:	53                   	push   %ebx
 84b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84e:	8b 08                	mov    (%eax),%ecx
  bp = (Header*)ap - 1;
 850:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 853:	39 d0                	cmp    %edx,%eax
 855:	72 11                	jb     868 <free+0x28>
 857:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 858:	39 c8                	cmp    %ecx,%eax
 85a:	72 04                	jb     860 <free+0x20>
 85c:	39 ca                	cmp    %ecx,%edx
 85e:	72 10                	jb     870 <free+0x30>
 860:	89 c8                	mov    %ecx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 862:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 864:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 866:	73 f0                	jae    858 <free+0x18>
 868:	39 ca                	cmp    %ecx,%edx
 86a:	72 04                	jb     870 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86c:	39 c8                	cmp    %ecx,%eax
 86e:	72 f0                	jb     860 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 870:	8b 73 fc             	mov    -0x4(%ebx),%esi
 873:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 876:	39 cf                	cmp    %ecx,%edi
 878:	74 1e                	je     898 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 87a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 87d:	8b 48 04             	mov    0x4(%eax),%ecx
 880:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 883:	39 f2                	cmp    %esi,%edx
 885:	74 28                	je     8af <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 887:	89 10                	mov    %edx,(%eax)
  freep = p;
 889:	a3 f4 0e 00 00       	mov    %eax,0xef4
}
 88e:	5b                   	pop    %ebx
 88f:	5e                   	pop    %esi
 890:	5f                   	pop    %edi
 891:	5d                   	pop    %ebp
 892:	c3                   	ret    
 893:	90                   	nop
 894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 898:	03 71 04             	add    0x4(%ecx),%esi
 89b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 89e:	8b 08                	mov    (%eax),%ecx
 8a0:	8b 09                	mov    (%ecx),%ecx
 8a2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8a5:	8b 48 04             	mov    0x4(%eax),%ecx
 8a8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 8ab:	39 f2                	cmp    %esi,%edx
 8ad:	75 d8                	jne    887 <free+0x47>
    p->s.size += bp->s.size;
 8af:	03 4b fc             	add    -0x4(%ebx),%ecx
  freep = p;
 8b2:	a3 f4 0e 00 00       	mov    %eax,0xef4
    p->s.size += bp->s.size;
 8b7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8ba:	8b 53 f8             	mov    -0x8(%ebx),%edx
 8bd:	89 10                	mov    %edx,(%eax)
}
 8bf:	5b                   	pop    %ebx
 8c0:	5e                   	pop    %esi
 8c1:	5f                   	pop    %edi
 8c2:	5d                   	pop    %ebp
 8c3:	c3                   	ret    
 8c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 8ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000008d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8d0:	55                   	push   %ebp
 8d1:	89 e5                	mov    %esp,%ebp
 8d3:	57                   	push   %edi
 8d4:	56                   	push   %esi
 8d5:	53                   	push   %ebx
 8d6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8dc:	8b 1d f4 0e 00 00    	mov    0xef4,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e2:	8d 48 07             	lea    0x7(%eax),%ecx
 8e5:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 8e8:	85 db                	test   %ebx,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ea:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 8ed:	0f 84 9b 00 00 00    	je     98e <malloc+0xbe>
 8f3:	8b 13                	mov    (%ebx),%edx
 8f5:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 8f8:	39 fe                	cmp    %edi,%esi
 8fa:	76 64                	jbe    960 <malloc+0x90>
 8fc:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  if(nu < 4096)
 903:	bb 00 80 00 00       	mov    $0x8000,%ebx
 908:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 90b:	eb 0e                	jmp    91b <malloc+0x4b>
 90d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 910:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 912:	8b 78 04             	mov    0x4(%eax),%edi
 915:	39 fe                	cmp    %edi,%esi
 917:	76 4f                	jbe    968 <malloc+0x98>
 919:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 91b:	3b 15 f4 0e 00 00    	cmp    0xef4,%edx
 921:	75 ed                	jne    910 <malloc+0x40>
  if(nu < 4096)
 923:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 926:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 92c:	bf 00 10 00 00       	mov    $0x1000,%edi
 931:	0f 43 fe             	cmovae %esi,%edi
 934:	0f 42 c3             	cmovb  %ebx,%eax
  p = sbrk(nu * sizeof(Header));
 937:	89 04 24             	mov    %eax,(%esp)
 93a:	e8 4b fc ff ff       	call   58a <sbrk>
  if(p == (char*)-1)
 93f:	83 f8 ff             	cmp    $0xffffffff,%eax
 942:	74 18                	je     95c <malloc+0x8c>
  hp->s.size = nu;
 944:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 947:	83 c0 08             	add    $0x8,%eax
 94a:	89 04 24             	mov    %eax,(%esp)
 94d:	e8 ee fe ff ff       	call   840 <free>
  return freep;
 952:	8b 15 f4 0e 00 00    	mov    0xef4,%edx
      if((p = morecore(nunits)) == 0)
 958:	85 d2                	test   %edx,%edx
 95a:	75 b4                	jne    910 <malloc+0x40>
        return 0;
 95c:	31 c0                	xor    %eax,%eax
 95e:	eb 20                	jmp    980 <malloc+0xb0>
    if(p->s.size >= nunits){
 960:	89 d0                	mov    %edx,%eax
 962:	89 da                	mov    %ebx,%edx
 964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 968:	39 fe                	cmp    %edi,%esi
 96a:	74 1c                	je     988 <malloc+0xb8>
        p->s.size -= nunits;
 96c:	29 f7                	sub    %esi,%edi
 96e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 971:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 974:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 977:	89 15 f4 0e 00 00    	mov    %edx,0xef4
      return (void*)(p + 1);
 97d:	83 c0 08             	add    $0x8,%eax
  }
}
 980:	83 c4 1c             	add    $0x1c,%esp
 983:	5b                   	pop    %ebx
 984:	5e                   	pop    %esi
 985:	5f                   	pop    %edi
 986:	5d                   	pop    %ebp
 987:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 988:	8b 08                	mov    (%eax),%ecx
 98a:	89 0a                	mov    %ecx,(%edx)
 98c:	eb e9                	jmp    977 <malloc+0xa7>
    base.s.ptr = freep = prevp = &base;
 98e:	c7 05 f4 0e 00 00 f8 	movl   $0xef8,0xef4
 995:	0e 00 00 
    base.s.size = 0;
 998:	ba f8 0e 00 00       	mov    $0xef8,%edx
    base.s.ptr = freep = prevp = &base;
 99d:	c7 05 f8 0e 00 00 f8 	movl   $0xef8,0xef8
 9a4:	0e 00 00 
    base.s.size = 0;
 9a7:	c7 05 fc 0e 00 00 00 	movl   $0x0,0xefc
 9ae:	00 00 00 
 9b1:	e9 46 ff ff ff       	jmp    8fc <malloc+0x2c>
