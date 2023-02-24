
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 00 2e 10 80       	mov    $0x80102e00,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 14             	sub    $0x14,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 20 6d 10 	movl   $0x80106d20,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 10 41 00 00       	call   80104170 <initlock>
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 27 6d 10 	movl   $0x80106d27,0x4(%esp)
8010009b:	80 
8010009c:	e8 9f 3f 00 00       	call   80104040 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000e6:	e8 f5 41 00 00       	call   801042e0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 ea 41 00 00       	call   80104350 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 0f 3f 00 00       	call   80104080 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 b2 1f 00 00       	call   80102130 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
  panic("bget: no buffers");
80100188:	c7 04 24 2e 6d 10 80 	movl   $0x80106d2e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 6b 3f 00 00       	call   80104120 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
  iderw(b);
801001c4:	e9 67 1f 00 00       	jmp    80102130 <iderw>
    panic("bwrite");
801001c9:	c7 04 24 3f 6d 10 80 	movl   $0x80106d3f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 2a 3f 00 00       	call   80104120 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 de 3e 00 00       	call   801040e0 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 d2 40 00 00       	call   801042e0 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100250:	e9 fb 40 00 00       	jmp    80104350 <release>
    panic("brelse");
80100255:	c7 04 24 46 6d 10 80 	movl   $0x80106d46,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 19 15 00 00       	call   801017a0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 4d 40 00 00       	call   801042e0 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 13 34 00 00       	call   801036c0 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 f8 39 00 00       	call   80103cc0 <sleep>
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 3a 40 00 00       	call   80104350 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 a2 13 00 00       	call   801016c0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 1c 40 00 00       	call   80104350 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 84 13 00 00       	call   801016c0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 f5 23 00 00       	call   80102770 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 4d 6d 10 80 	movl   $0x80106d4d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 bb 76 10 80 	movl   $0x801076bb,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 dc 3d 00 00       	call   80104190 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 61 6d 10 80 	movl   $0x80106d61,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 82 54 00 00       	call   80105890 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx
  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 
  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 d2 53 00 00       	call   80105890 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 c6 53 00 00       	call   80105890 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 ba 53 00 00       	call   80105890 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 3f 3f 00 00       	call   80104440 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 82 3e 00 00       	call   801043a0 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    panic("pos under/overflow");
8010052a:	c7 04 24 65 6d 10 80 	movl   $0x80106d65,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 90 6d 10 80 	movzbl -0x7fef9270(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>
  if(sign)
801005a8:	85 ff                	test   %edi,%edi
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 99 11 00 00       	call   801017a0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 cd 3c 00 00       	call   801042e0 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 15 3d 00 00       	call   80104350 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 7a 10 00 00       	call   801016c0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 58 3c 00 00       	call   80104350 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 78 6d 10 80       	mov    $0x80106d78,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 44 3b 00 00       	call   801042e0 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007a1:	c7 04 24 7f 6d 10 80 	movl   $0x80106d7f,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 16 3b 00 00       	call   801042e0 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 24 3b 00 00       	call   80104350 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 a9 35 00 00       	call   80103e60 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 24 36 00 00       	jmp    80103f50 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 88 6d 10 	movl   $0x80106d88,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 06 38 00 00       	call   80104170 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100997:	e8 24 19 00 00       	call   801022c0 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 0f 2d 00 00       	call   801036c0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 64 21 00 00       	call   80102b20 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 49 15 00 00       	call   80101f10 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c2 01 00 00    	je     80100b93 <exec+0x1f3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 e7 0c 00 00       	call   801016c0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 75 0f 00 00       	call   80101970 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 18 0f 00 00       	call   80101920 <iunlockput>
    end_op();
80100a08:	e8 83 21 00 00       	call   80102b90 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 4f 60 00 00       	call   80106a80 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 dd 0e 00 00       	call   80101970 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 19 5e 00 00       	call   801068f0 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 18 5d 00 00       	call   80106830 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 d2 5e 00 00       	call   80106a00 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 e5 0d 00 00       	call   80101920 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 4b 20 00 00       	call   80102b90 <end_op>
  sz = PGROUNDUP(sz);
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 7f 5d 00 00       	call   801068f0 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b79:	75 33                	jne    80100bae <exec+0x20e>
    freevm(pgdir);
80100b7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 77 5e 00 00       	call   80106a00 <freevm>
  return -1;
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 7f fe ff ff       	jmp    80100a12 <exec+0x72>
    end_op();
80100b93:	e8 f8 1f 00 00       	call   80102b90 <end_op>
    cprintf("exec: fail\n");
80100b98:	c7 04 24 a1 6d 10 80 	movl   $0x80106da1,(%esp)
80100b9f:	e8 ac fa ff ff       	call   80100650 <cprintf>
    return -1;
80100ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba9:	e9 64 fe ff ff       	jmp    80100a12 <exec+0x72>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bae:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100bb4:	89 d8                	mov    %ebx,%eax
80100bb6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 63 5f 00 00       	call   80106b30 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bd0:	8b 00                	mov    (%eax),%eax
80100bd2:	85 c0                	test   %eax,%eax
80100bd4:	0f 84 64 01 00 00    	je     80100d3e <exec+0x39e>
80100bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bdd:	31 d2                	xor    %edx,%edx
80100bdf:	8d 71 04             	lea    0x4(%ecx),%esi
80100be2:	89 cf                	mov    %ecx,%edi
80100be4:	89 d1                	mov    %edx,%ecx
80100be6:	89 f2                	mov    %esi,%edx
80100be8:	89 fe                	mov    %edi,%esi
80100bea:	89 cf                	mov    %ecx,%edi
80100bec:	eb 0a                	jmp    80100bf8 <exec+0x258>
80100bee:	66 90                	xchg   %ax,%ax
80100bf0:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bf3:	83 ff 20             	cmp    $0x20,%edi
80100bf6:	74 83                	je     80100b7b <exec+0x1db>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bf8:	89 04 24             	mov    %eax,(%esp)
80100bfb:	89 95 ec fe ff ff    	mov    %edx,-0x114(%ebp)
80100c01:	e8 ba 39 00 00       	call   801045c0 <strlen>
80100c06:	f7 d0                	not    %eax
80100c08:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0a:	8b 06                	mov    (%esi),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c0c:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0f:	89 04 24             	mov    %eax,(%esp)
80100c12:	e8 a9 39 00 00       	call   801045c0 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 5a 60 00 00       	call   80106c90 <copyout>
80100c36:	85 c0                	test   %eax,%eax
80100c38:	0f 88 3d ff ff ff    	js     80100b7b <exec+0x1db>
  for(argc = 0; argv[argc]; argc++) {
80100c3e:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
    ustack[3+argc] = sp;
80100c44:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100c4a:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c51:	83 c7 01             	add    $0x1,%edi
80100c54:	8b 02                	mov    (%edx),%eax
80100c56:	89 d6                	mov    %edx,%esi
80100c58:	85 c0                	test   %eax,%eax
80100c5a:	75 94                	jne    80100bf0 <exec+0x250>
80100c5c:	89 fa                	mov    %edi,%edx
  ustack[3+argc] = 0;
80100c5e:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c65:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c69:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
  ustack[1] = argc;
80100c70:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c76:	89 da                	mov    %ebx,%edx
80100c78:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100c7a:	83 c0 0c             	add    $0xc,%eax
80100c7d:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c83:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[0] = 0xffffffff;  // fake return PC
80100c91:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c98:	ff ff ff 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c9b:	89 04 24             	mov    %eax,(%esp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c9e:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ca4:	e8 e7 5f 00 00       	call   80106c90 <copyout>
80100ca9:	85 c0                	test   %eax,%eax
80100cab:	0f 88 ca fe ff ff    	js     80100b7b <exec+0x1db>
  for(last=s=path; *s; s++)
80100cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb4:	0f b6 10             	movzbl (%eax),%edx
80100cb7:	84 d2                	test   %dl,%dl
80100cb9:	74 19                	je     80100cd4 <exec+0x334>
80100cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cbe:	83 c0 01             	add    $0x1,%eax
      last = s+1;
80100cc1:	80 fa 2f             	cmp    $0x2f,%dl
  for(last=s=path; *s; s++)
80100cc4:	0f b6 10             	movzbl (%eax),%edx
      last = s+1;
80100cc7:	0f 44 c8             	cmove  %eax,%ecx
80100cca:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100ccd:	84 d2                	test   %dl,%dl
80100ccf:	75 f0                	jne    80100cc1 <exec+0x321>
80100cd1:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cd4:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cda:	8b 45 08             	mov    0x8(%ebp),%eax
80100cdd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ce4:	00 
80100ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce9:	89 f8                	mov    %edi,%eax
80100ceb:	83 c0 6c             	add    $0x6c,%eax
80100cee:	89 04 24             	mov    %eax,(%esp)
80100cf1:	e8 8a 38 00 00       	call   80104580 <safestrcpy>
  curproc->pgdir = pgdir;
80100cf6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100cfc:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->tf->eip = elf.entry;  // main
80100cff:	8b 47 18             	mov    0x18(%edi),%eax
  curproc->pgdir = pgdir;
80100d02:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100d05:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
80100d0b:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d0d:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d13:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d16:	8b 47 18             	mov    0x18(%edi),%eax
80100d19:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d1c:	89 3c 24             	mov    %edi,(%esp)
80100d1f:	e8 7c 59 00 00       	call   801066a0 <switchuvm>
  freevm(oldpgdir);
80100d24:	89 34 24             	mov    %esi,(%esp)
80100d27:	e8 d4 5c 00 00       	call   80106a00 <freevm>
  curproc->T_start = ticks;
80100d2c:	a1 a0 58 11 80       	mov    0x801158a0,%eax
80100d31:	89 87 80 00 00 00    	mov    %eax,0x80(%edi)
  return 0;
80100d37:	31 c0                	xor    %eax,%eax
80100d39:	e9 d4 fc ff ff       	jmp    80100a12 <exec+0x72>
  for(argc = 0; argv[argc]; argc++) {
80100d3e:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100d44:	31 d2                	xor    %edx,%edx
80100d46:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d4c:	e9 0d ff ff ff       	jmp    80100c5e <exec+0x2be>
80100d51:	66 90                	xchg   %ax,%ax
80100d53:	66 90                	xchg   %ax,%ax
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	c7 44 24 04 ad 6d 10 	movl   $0x80106dad,0x4(%esp)
80100d6d:	80 
80100d6e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d75:	e8 f6 33 00 00       	call   80104170 <initlock>
}
80100d7a:	c9                   	leave  
80100d7b:	c3                   	ret    
80100d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d89:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100d8c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d93:	e8 48 35 00 00       	call   801042e0 <acquire>
80100d98:	eb 11                	jmp    80100dab <filealloc+0x2b>
80100d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100da9:	74 25                	je     80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      f->ref = 1;
80100db9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dc0:	e8 8b 35 00 00       	call   80104350 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc5:	83 c4 14             	add    $0x14,%esp
      return f;
80100dc8:	89 d8                	mov    %ebx,%eax
}
80100dca:	5b                   	pop    %ebx
80100dcb:	5d                   	pop    %ebp
80100dcc:	c3                   	ret    
80100dcd:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100dd0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dd7:	e8 74 35 00 00       	call   80104350 <release>
}
80100ddc:	83 c4 14             	add    $0x14,%esp
  return 0;
80100ddf:	31 c0                	xor    %eax,%eax
}
80100de1:	5b                   	pop    %ebx
80100de2:	5d                   	pop    %ebp
80100de3:	c3                   	ret    
80100de4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 14             	sub    $0x14,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e01:	e8 da 34 00 00       	call   801042e0 <acquire>
  if(f->ref < 1)
80100e06:	8b 43 04             	mov    0x4(%ebx),%eax
80100e09:	85 c0                	test   %eax,%eax
80100e0b:	7e 1a                	jle    80100e27 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100e0d:	83 c0 01             	add    $0x1,%eax
80100e10:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e13:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e1a:	e8 31 35 00 00       	call   80104350 <release>
  return f;
}
80100e1f:	83 c4 14             	add    $0x14,%esp
80100e22:	89 d8                	mov    %ebx,%eax
80100e24:	5b                   	pop    %ebx
80100e25:	5d                   	pop    %ebp
80100e26:	c3                   	ret    
    panic("filedup");
80100e27:	c7 04 24 b4 6d 10 80 	movl   $0x80106db4,(%esp)
80100e2e:	e8 2d f5 ff ff       	call   80100360 <panic>
80100e33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 1c             	sub    $0x1c,%esp
80100e49:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e53:	e8 88 34 00 00       	call   801042e0 <acquire>
  if(f->ref < 1)
80100e58:	8b 57 04             	mov    0x4(%edi),%edx
80100e5b:	85 d2                	test   %edx,%edx
80100e5d:	0f 8e 89 00 00 00    	jle    80100eec <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e63:	83 ea 01             	sub    $0x1,%edx
80100e66:	85 d2                	test   %edx,%edx
80100e68:	89 57 04             	mov    %edx,0x4(%edi)
80100e6b:	74 13                	je     80100e80 <fileclose+0x40>
    release(&ftable.lock);
80100e6d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e74:	83 c4 1c             	add    $0x1c,%esp
80100e77:	5b                   	pop    %ebx
80100e78:	5e                   	pop    %esi
80100e79:	5f                   	pop    %edi
80100e7a:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7b:	e9 d0 34 00 00       	jmp    80104350 <release>
  ff = *f;
80100e80:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e84:	8b 37                	mov    (%edi),%esi
80100e86:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->type = FD_NONE;
80100e89:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  ff = *f;
80100e8f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e92:	8b 47 10             	mov    0x10(%edi),%eax
  release(&ftable.lock);
80100e95:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  ff = *f;
80100e9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100e9f:	e8 ac 34 00 00       	call   80104350 <release>
  if(ff.type == FD_PIPE)
80100ea4:	83 fe 01             	cmp    $0x1,%esi
80100ea7:	74 0f                	je     80100eb8 <fileclose+0x78>
  else if(ff.type == FD_INODE){
80100ea9:	83 fe 02             	cmp    $0x2,%esi
80100eac:	74 22                	je     80100ed0 <fileclose+0x90>
}
80100eae:	83 c4 1c             	add    $0x1c,%esp
80100eb1:	5b                   	pop    %ebx
80100eb2:	5e                   	pop    %esi
80100eb3:	5f                   	pop    %edi
80100eb4:	5d                   	pop    %ebp
80100eb5:	c3                   	ret    
80100eb6:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100eb8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100ebc:	89 1c 24             	mov    %ebx,(%esp)
80100ebf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100ec3:	e8 a8 23 00 00       	call   80103270 <pipeclose>
80100ec8:	eb e4                	jmp    80100eae <fileclose+0x6e>
80100eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
80100ed0:	e8 4b 1c 00 00       	call   80102b20 <begin_op>
    iput(ff.ip);
80100ed5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ed8:	89 04 24             	mov    %eax,(%esp)
80100edb:	e8 00 09 00 00       	call   801017e0 <iput>
}
80100ee0:	83 c4 1c             	add    $0x1c,%esp
80100ee3:	5b                   	pop    %ebx
80100ee4:	5e                   	pop    %esi
80100ee5:	5f                   	pop    %edi
80100ee6:	5d                   	pop    %ebp
    end_op();
80100ee7:	e9 a4 1c 00 00       	jmp    80102b90 <end_op>
    panic("fileclose");
80100eec:	c7 04 24 bc 6d 10 80 	movl   $0x80106dbc,(%esp)
80100ef3:	e8 68 f4 ff ff       	call   80100360 <panic>
80100ef8:	90                   	nop
80100ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 14             	sub    $0x14,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f0a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f0d:	75 31                	jne    80100f40 <filestat+0x40>
    ilock(f->ip);
80100f0f:	8b 43 10             	mov    0x10(%ebx),%eax
80100f12:	89 04 24             	mov    %eax,(%esp)
80100f15:	e8 a6 07 00 00       	call   801016c0 <ilock>
    stati(f->ip, st);
80100f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f1d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f21:	8b 43 10             	mov    0x10(%ebx),%eax
80100f24:	89 04 24             	mov    %eax,(%esp)
80100f27:	e8 14 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f2c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f2f:	89 04 24             	mov    %eax,(%esp)
80100f32:	e8 69 08 00 00       	call   801017a0 <iunlock>
    return 0;
  }
  return -1;
}
80100f37:	83 c4 14             	add    $0x14,%esp
    return 0;
80100f3a:	31 c0                	xor    %eax,%eax
}
80100f3c:	5b                   	pop    %ebx
80100f3d:	5d                   	pop    %ebp
80100f3e:	c3                   	ret    
80100f3f:	90                   	nop
80100f40:	83 c4 14             	add    $0x14,%esp
  return -1;
80100f43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f48:	5b                   	pop    %ebx
80100f49:	5d                   	pop    %ebp
80100f4a:	c3                   	ret    
80100f4b:	90                   	nop
80100f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 1c             	sub    $0x1c,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f62:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f66:	74 68                	je     80100fd0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f68:	8b 03                	mov    (%ebx),%eax
80100f6a:	83 f8 01             	cmp    $0x1,%eax
80100f6d:	74 49                	je     80100fb8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6f:	83 f8 02             	cmp    $0x2,%eax
80100f72:	75 63                	jne    80100fd7 <fileread+0x87>
    ilock(f->ip);
80100f74:	8b 43 10             	mov    0x10(%ebx),%eax
80100f77:	89 04 24             	mov    %eax,(%esp)
80100f7a:	e8 41 07 00 00       	call   801016c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f83:	8b 43 14             	mov    0x14(%ebx),%eax
80100f86:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f8a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f8e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f91:	89 04 24             	mov    %eax,(%esp)
80100f94:	e8 d7 09 00 00       	call   80101970 <readi>
80100f99:	85 c0                	test   %eax,%eax
80100f9b:	89 c6                	mov    %eax,%esi
80100f9d:	7e 03                	jle    80100fa2 <fileread+0x52>
      f->off += r;
80100f9f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa2:	8b 43 10             	mov    0x10(%ebx),%eax
80100fa5:	89 04 24             	mov    %eax,(%esp)
80100fa8:	e8 f3 07 00 00       	call   801017a0 <iunlock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fad:	89 f0                	mov    %esi,%eax
    return r;
  }
  panic("fileread");
}
80100faf:	83 c4 1c             	add    $0x1c,%esp
80100fb2:	5b                   	pop    %ebx
80100fb3:	5e                   	pop    %esi
80100fb4:	5f                   	pop    %edi
80100fb5:	5d                   	pop    %ebp
80100fb6:	c3                   	ret    
80100fb7:	90                   	nop
    return piperead(f->pipe, addr, n);
80100fb8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fbb:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fbe:	83 c4 1c             	add    $0x1c,%esp
80100fc1:	5b                   	pop    %ebx
80100fc2:	5e                   	pop    %esi
80100fc3:	5f                   	pop    %edi
80100fc4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fc5:	e9 26 24 00 00       	jmp    801033f0 <piperead>
80100fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fd5:	eb d8                	jmp    80100faf <fileread+0x5f>
  panic("fileread");
80100fd7:	c7 04 24 c6 6d 10 80 	movl   $0x80106dc6,(%esp)
80100fde:	e8 7d f3 ff ff       	call   80100360 <panic>
80100fe3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 2c             	sub    $0x2c,%esp
80100ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ffc:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fff:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101002:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101005:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 ae 00 00 00    	je     801010c0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 07                	mov    (%edi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c2 00 00 00    	je     801010df <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d7 00 00 00    	jne    801010fd <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101029:	31 db                	xor    %ebx,%ebx
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 31                	jg     80101060 <filewrite+0x70>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101038:	8b 4f 10             	mov    0x10(%edi),%ecx
        f->off += r;
8010103b:	01 47 14             	add    %eax,0x14(%edi)
8010103e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101041:	89 0c 24             	mov    %ecx,(%esp)
80101044:	e8 57 07 00 00       	call   801017a0 <iunlock>
      end_op();
80101049:	e8 42 1b 00 00       	call   80102b90 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101051:	39 f0                	cmp    %esi,%eax
80101053:	0f 85 98 00 00 00    	jne    801010f1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101059:	01 c3                	add    %eax,%ebx
    while(i < n){
8010105b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010105e:	7e 70                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101060:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101063:	b8 00 06 00 00       	mov    $0x600,%eax
80101068:	29 de                	sub    %ebx,%esi
8010106a:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80101070:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101073:	e8 a8 1a 00 00       	call   80102b20 <begin_op>
      ilock(f->ip);
80101078:	8b 47 10             	mov    0x10(%edi),%eax
8010107b:	89 04 24             	mov    %eax,(%esp)
8010107e:	e8 3d 06 00 00       	call   801016c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101083:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101087:	8b 47 14             	mov    0x14(%edi),%eax
8010108a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010108e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101091:	01 d8                	add    %ebx,%eax
80101093:	89 44 24 04          	mov    %eax,0x4(%esp)
80101097:	8b 47 10             	mov    0x10(%edi),%eax
8010109a:	89 04 24             	mov    %eax,(%esp)
8010109d:	e8 ce 09 00 00       	call   80101a70 <writei>
801010a2:	85 c0                	test   %eax,%eax
801010a4:	7f 92                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
801010a6:	8b 4f 10             	mov    0x10(%edi),%ecx
801010a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010ac:	89 0c 24             	mov    %ecx,(%esp)
801010af:	e8 ec 06 00 00       	call   801017a0 <iunlock>
      end_op();
801010b4:	e8 d7 1a 00 00       	call   80102b90 <end_op>
      if(r < 0)
801010b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010bc:	85 c0                	test   %eax,%eax
801010be:	74 91                	je     80101051 <filewrite+0x61>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010c0:	83 c4 2c             	add    $0x2c,%esp
    return -1;
801010c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010c8:	5b                   	pop    %ebx
801010c9:	5e                   	pop    %esi
801010ca:	5f                   	pop    %edi
801010cb:	5d                   	pop    %ebp
801010cc:	c3                   	ret    
801010cd:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
801010d0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010d3:	89 d8                	mov    %ebx,%eax
801010d5:	75 e9                	jne    801010c0 <filewrite+0xd0>
}
801010d7:	83 c4 2c             	add    $0x2c,%esp
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801010df:	8b 47 0c             	mov    0xc(%edi),%eax
801010e2:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e5:	83 c4 2c             	add    $0x2c,%esp
801010e8:	5b                   	pop    %ebx
801010e9:	5e                   	pop    %esi
801010ea:	5f                   	pop    %edi
801010eb:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ec:	e9 0f 22 00 00       	jmp    80103300 <pipewrite>
        panic("short filewrite");
801010f1:	c7 04 24 cf 6d 10 80 	movl   $0x80106dcf,(%esp)
801010f8:	e8 63 f2 ff ff       	call   80100360 <panic>
  panic("filewrite");
801010fd:	c7 04 24 d5 6d 10 80 	movl   $0x80106dd5,(%esp)
80101104:	e8 57 f2 ff ff       	call   80100360 <panic>
80101109:	66 90                	xchg   %ax,%ax
8010110b:	66 90                	xchg   %ax,%ax
8010110d:	66 90                	xchg   %ax,%ax
8010110f:	90                   	nop

80101110 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	89 d7                	mov    %edx,%edi
80101116:	56                   	push   %esi
80101117:	53                   	push   %ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101118:	bb 01 00 00 00       	mov    $0x1,%ebx
{
8010111d:	83 ec 1c             	sub    $0x1c,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101120:	c1 ea 0c             	shr    $0xc,%edx
80101123:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101129:	89 04 24             	mov    %eax,(%esp)
8010112c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101130:	e8 9b ef ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101135:	89 f9                	mov    %edi,%ecx
  bi = b % BPB;
80101137:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
8010113d:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
8010113f:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101142:	c1 fa 03             	sar    $0x3,%edx
  m = 1 << (bi % 8);
80101145:	d3 e3                	shl    %cl,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101147:	89 c6                	mov    %eax,%esi
  if((bp->data[bi/8] & m) == 0)
80101149:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
8010114e:	0f b6 c8             	movzbl %al,%ecx
80101151:	85 d9                	test   %ebx,%ecx
80101153:	74 20                	je     80101175 <bfree+0x65>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101155:	f7 d3                	not    %ebx
80101157:	21 c3                	and    %eax,%ebx
80101159:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
8010115d:	89 34 24             	mov    %esi,(%esp)
80101160:	e8 5b 1b 00 00       	call   80102cc0 <log_write>
  brelse(bp);
80101165:	89 34 24             	mov    %esi,(%esp)
80101168:	e8 73 f0 ff ff       	call   801001e0 <brelse>
}
8010116d:	83 c4 1c             	add    $0x1c,%esp
80101170:	5b                   	pop    %ebx
80101171:	5e                   	pop    %esi
80101172:	5f                   	pop    %edi
80101173:	5d                   	pop    %ebp
80101174:	c3                   	ret    
    panic("freeing free block");
80101175:	c7 04 24 df 6d 10 80 	movl   $0x80106ddf,(%esp)
8010117c:	e8 df f1 ff ff       	call   80100360 <panic>
80101181:	eb 0d                	jmp    80101190 <balloc>
80101183:	90                   	nop
80101184:	90                   	nop
80101185:	90                   	nop
80101186:	90                   	nop
80101187:	90                   	nop
80101188:	90                   	nop
80101189:	90                   	nop
8010118a:	90                   	nop
8010118b:	90                   	nop
8010118c:	90                   	nop
8010118d:	90                   	nop
8010118e:	90                   	nop
8010118f:	90                   	nop

80101190 <balloc>:
{
80101190:	55                   	push   %ebp
80101191:	89 e5                	mov    %esp,%ebp
80101193:	57                   	push   %edi
80101194:	56                   	push   %esi
80101195:	53                   	push   %ebx
80101196:	83 ec 2c             	sub    $0x2c,%esp
80101199:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010119c:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011a1:	85 c0                	test   %eax,%eax
801011a3:	0f 84 8c 00 00 00    	je     80101235 <balloc+0xa5>
801011a9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011b0:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011b3:	89 f0                	mov    %esi,%eax
801011b5:	c1 f8 0c             	sar    $0xc,%eax
801011b8:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011be:	89 44 24 04          	mov    %eax,0x4(%esp)
801011c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011c5:	89 04 24             	mov    %eax,(%esp)
801011c8:	e8 03 ef ff ff       	call   801000d0 <bread>
801011cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011d0:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011d8:	31 c0                	xor    %eax,%eax
801011da:	eb 33                	jmp    8010120f <balloc+0x7f>
801011dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011e0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011e3:	89 c2                	mov    %eax,%edx
      m = 1 << (bi % 8);
801011e5:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011e7:	c1 fa 03             	sar    $0x3,%edx
      m = 1 << (bi % 8);
801011ea:	83 e1 07             	and    $0x7,%ecx
801011ed:	bf 01 00 00 00       	mov    $0x1,%edi
801011f2:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011f4:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
      m = 1 << (bi % 8);
801011f9:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011fb:	0f b6 fb             	movzbl %bl,%edi
801011fe:	85 cf                	test   %ecx,%edi
80101200:	74 46                	je     80101248 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101202:	83 c0 01             	add    $0x1,%eax
80101205:	83 c6 01             	add    $0x1,%esi
80101208:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010120d:	74 05                	je     80101214 <balloc+0x84>
8010120f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101212:	72 cc                	jb     801011e0 <balloc+0x50>
    brelse(bp);
80101214:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101217:	89 04 24             	mov    %eax,(%esp)
8010121a:	e8 c1 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010121f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101226:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101229:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010122f:	0f 82 7b ff ff ff    	jb     801011b0 <balloc+0x20>
  panic("balloc: out of blocks");
80101235:	c7 04 24 f2 6d 10 80 	movl   $0x80106df2,(%esp)
8010123c:	e8 1f f1 ff ff       	call   80100360 <panic>
80101241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101248:	09 d9                	or     %ebx,%ecx
8010124a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010124d:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
80101251:	89 1c 24             	mov    %ebx,(%esp)
80101254:	e8 67 1a 00 00       	call   80102cc0 <log_write>
        brelse(bp);
80101259:	89 1c 24             	mov    %ebx,(%esp)
8010125c:	e8 7f ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
80101261:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101264:	89 74 24 04          	mov    %esi,0x4(%esp)
80101268:	89 04 24             	mov    %eax,(%esp)
8010126b:	e8 60 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101270:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101277:	00 
80101278:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010127f:	00 
  bp = bread(dev, bno);
80101280:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101282:	8d 40 5c             	lea    0x5c(%eax),%eax
80101285:	89 04 24             	mov    %eax,(%esp)
80101288:	e8 13 31 00 00       	call   801043a0 <memset>
  log_write(bp);
8010128d:	89 1c 24             	mov    %ebx,(%esp)
80101290:	e8 2b 1a 00 00       	call   80102cc0 <log_write>
  brelse(bp);
80101295:	89 1c 24             	mov    %ebx,(%esp)
80101298:	e8 43 ef ff ff       	call   801001e0 <brelse>
}
8010129d:	83 c4 2c             	add    $0x2c,%esp
801012a0:	89 f0                	mov    %esi,%eax
801012a2:	5b                   	pop    %ebx
801012a3:	5e                   	pop    %esi
801012a4:	5f                   	pop    %edi
801012a5:	5d                   	pop    %ebp
801012a6:	c3                   	ret    
801012a7:	89 f6                	mov    %esi,%esi
801012a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801012b0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	57                   	push   %edi
801012b4:	89 c7                	mov    %eax,%edi
801012b6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012b7:	31 f6                	xor    %esi,%esi
{
801012b9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ba:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
801012bf:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&icache.lock);
801012c2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
{
801012c9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012cc:	e8 0f 30 00 00       	call   801042e0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012d4:	eb 14                	jmp    801012ea <iget+0x3a>
801012d6:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d8:	85 f6                	test   %esi,%esi
801012da:	74 3c                	je     80101318 <iget+0x68>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012dc:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e2:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012e8:	74 46                	je     80101330 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ea:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012ed:	85 c9                	test   %ecx,%ecx
801012ef:	7e e7                	jle    801012d8 <iget+0x28>
801012f1:	39 3b                	cmp    %edi,(%ebx)
801012f3:	75 e3                	jne    801012d8 <iget+0x28>
801012f5:	39 53 04             	cmp    %edx,0x4(%ebx)
801012f8:	75 de                	jne    801012d8 <iget+0x28>
      ip->ref++;
801012fa:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012fd:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012ff:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
      ip->ref++;
80101306:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101309:	e8 42 30 00 00       	call   80104350 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010130e:	83 c4 1c             	add    $0x1c,%esp
80101311:	89 f0                	mov    %esi,%eax
80101313:	5b                   	pop    %ebx
80101314:	5e                   	pop    %esi
80101315:	5f                   	pop    %edi
80101316:	5d                   	pop    %ebp
80101317:	c3                   	ret    
80101318:	85 c9                	test   %ecx,%ecx
8010131a:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010131d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101323:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101329:	75 bf                	jne    801012ea <iget+0x3a>
8010132b:	90                   	nop
8010132c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(empty == 0)
80101330:	85 f6                	test   %esi,%esi
80101332:	74 29                	je     8010135d <iget+0xad>
  ip->dev = dev;
80101334:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101336:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101339:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101340:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101347:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010134e:	e8 fd 2f 00 00       	call   80104350 <release>
}
80101353:	83 c4 1c             	add    $0x1c,%esp
80101356:	89 f0                	mov    %esi,%eax
80101358:	5b                   	pop    %ebx
80101359:	5e                   	pop    %esi
8010135a:	5f                   	pop    %edi
8010135b:	5d                   	pop    %ebp
8010135c:	c3                   	ret    
    panic("iget: no inodes");
8010135d:	c7 04 24 08 6e 10 80 	movl   $0x80106e08,(%esp)
80101364:	e8 f7 ef ff ff       	call   80100360 <panic>
80101369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101370 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	57                   	push   %edi
80101374:	56                   	push   %esi
80101375:	53                   	push   %ebx
80101376:	89 c3                	mov    %eax,%ebx
80101378:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010137b:	83 fa 0b             	cmp    $0xb,%edx
8010137e:	77 18                	ja     80101398 <bmap+0x28>
80101380:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
80101383:	8b 46 5c             	mov    0x5c(%esi),%eax
80101386:	85 c0                	test   %eax,%eax
80101388:	74 66                	je     801013f0 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010138a:	83 c4 1c             	add    $0x1c,%esp
8010138d:	5b                   	pop    %ebx
8010138e:	5e                   	pop    %esi
8010138f:	5f                   	pop    %edi
80101390:	5d                   	pop    %ebp
80101391:	c3                   	ret    
80101392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;
80101398:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
8010139b:	83 fe 7f             	cmp    $0x7f,%esi
8010139e:	77 77                	ja     80101417 <bmap+0xa7>
    if((addr = ip->addrs[NDIRECT]) == 0)
801013a0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801013a6:	85 c0                	test   %eax,%eax
801013a8:	74 5e                	je     80101408 <bmap+0x98>
    bp = bread(ip->dev, addr);
801013aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801013ae:	8b 03                	mov    (%ebx),%eax
801013b0:	89 04 24             	mov    %eax,(%esp)
801013b3:	e8 18 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013b8:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
    bp = bread(ip->dev, addr);
801013bc:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013be:	8b 32                	mov    (%edx),%esi
801013c0:	85 f6                	test   %esi,%esi
801013c2:	75 19                	jne    801013dd <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
801013c4:	8b 03                	mov    (%ebx),%eax
801013c6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013c9:	e8 c2 fd ff ff       	call   80101190 <balloc>
801013ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013d1:	89 02                	mov    %eax,(%edx)
801013d3:	89 c6                	mov    %eax,%esi
      log_write(bp);
801013d5:	89 3c 24             	mov    %edi,(%esp)
801013d8:	e8 e3 18 00 00       	call   80102cc0 <log_write>
    brelse(bp);
801013dd:	89 3c 24             	mov    %edi,(%esp)
801013e0:	e8 fb ed ff ff       	call   801001e0 <brelse>
}
801013e5:	83 c4 1c             	add    $0x1c,%esp
    brelse(bp);
801013e8:	89 f0                	mov    %esi,%eax
}
801013ea:	5b                   	pop    %ebx
801013eb:	5e                   	pop    %esi
801013ec:	5f                   	pop    %edi
801013ed:	5d                   	pop    %ebp
801013ee:	c3                   	ret    
801013ef:	90                   	nop
      ip->addrs[bn] = addr = balloc(ip->dev);
801013f0:	8b 03                	mov    (%ebx),%eax
801013f2:	e8 99 fd ff ff       	call   80101190 <balloc>
801013f7:	89 46 5c             	mov    %eax,0x5c(%esi)
}
801013fa:	83 c4 1c             	add    $0x1c,%esp
801013fd:	5b                   	pop    %ebx
801013fe:	5e                   	pop    %esi
801013ff:	5f                   	pop    %edi
80101400:	5d                   	pop    %ebp
80101401:	c3                   	ret    
80101402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101408:	8b 03                	mov    (%ebx),%eax
8010140a:	e8 81 fd ff ff       	call   80101190 <balloc>
8010140f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101415:	eb 93                	jmp    801013aa <bmap+0x3a>
  panic("bmap: out of range");
80101417:	c7 04 24 18 6e 10 80 	movl   $0x80106e18,(%esp)
8010141e:	e8 3d ef ff ff       	call   80100360 <panic>
80101423:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101430 <readsb>:
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	56                   	push   %esi
80101434:	53                   	push   %ebx
80101435:	83 ec 10             	sub    $0x10,%esp
  bp = bread(dev, 1);
80101438:	8b 45 08             	mov    0x8(%ebp),%eax
8010143b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101442:	00 
{
80101443:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101446:	89 04 24             	mov    %eax,(%esp)
80101449:	e8 82 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010144e:	89 34 24             	mov    %esi,(%esp)
80101451:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101458:	00 
  bp = bread(dev, 1);
80101459:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010145b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010145e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101462:	e8 d9 2f 00 00       	call   80104440 <memmove>
  brelse(bp);
80101467:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010146a:	83 c4 10             	add    $0x10,%esp
8010146d:	5b                   	pop    %ebx
8010146e:	5e                   	pop    %esi
8010146f:	5d                   	pop    %ebp
  brelse(bp);
80101470:	e9 6b ed ff ff       	jmp    801001e0 <brelse>
80101475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101489:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
8010148c:	c7 44 24 04 2b 6e 10 	movl   $0x80106e2b,0x4(%esp)
80101493:	80 
80101494:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010149b:	e8 d0 2c 00 00       	call   80104170 <initlock>
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	89 1c 24             	mov    %ebx,(%esp)
801014a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014a9:	c7 44 24 04 32 6e 10 	movl   $0x80106e32,0x4(%esp)
801014b0:	80 
801014b1:	e8 8a 2b 00 00       	call   80104040 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b6:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014bc:	75 e2                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014be:	8b 45 08             	mov    0x8(%ebp),%eax
801014c1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014c8:	80 
801014c9:	89 04 24             	mov    %eax,(%esp)
801014cc:	e8 5f ff ff ff       	call   80101430 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014d1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014d6:	c7 04 24 98 6e 10 80 	movl   $0x80106e98,(%esp)
801014dd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014e1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014e6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014ea:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014ef:	89 44 24 14          	mov    %eax,0x14(%esp)
801014f3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801014f8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014fc:	a1 c8 09 11 80       	mov    0x801109c8,%eax
80101501:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101505:	a1 c4 09 11 80       	mov    0x801109c4,%eax
8010150a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010150e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101513:	89 44 24 04          	mov    %eax,0x4(%esp)
80101517:	e8 34 f1 ff ff       	call   80100650 <cprintf>
}
8010151c:	83 c4 24             	add    $0x24,%esp
8010151f:	5b                   	pop    %ebx
80101520:	5d                   	pop    %ebp
80101521:	c3                   	ret    
80101522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101530 <ialloc>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	57                   	push   %edi
80101534:	56                   	push   %esi
80101535:	53                   	push   %ebx
80101536:	83 ec 2c             	sub    $0x2c,%esp
80101539:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010153c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101543:	8b 7d 08             	mov    0x8(%ebp),%edi
80101546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101549:	0f 86 a2 00 00 00    	jbe    801015f1 <ialloc+0xc1>
8010154f:	be 01 00 00 00       	mov    $0x1,%esi
80101554:	bb 01 00 00 00       	mov    $0x1,%ebx
80101559:	eb 1a                	jmp    80101575 <ialloc+0x45>
8010155b:	90                   	nop
8010155c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    brelse(bp);
80101560:	89 14 24             	mov    %edx,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101563:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101566:	e8 75 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010156b:	89 de                	mov    %ebx,%esi
8010156d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101573:	73 7c                	jae    801015f1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101575:	89 f0                	mov    %esi,%eax
80101577:	c1 e8 03             	shr    $0x3,%eax
8010157a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101580:	89 3c 24             	mov    %edi,(%esp)
80101583:	89 44 24 04          	mov    %eax,0x4(%esp)
80101587:	e8 44 eb ff ff       	call   801000d0 <bread>
8010158c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010158e:	89 f0                	mov    %esi,%eax
80101590:	83 e0 07             	and    $0x7,%eax
80101593:	c1 e0 06             	shl    $0x6,%eax
80101596:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010159a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010159e:	75 c0                	jne    80101560 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015a0:	89 0c 24             	mov    %ecx,(%esp)
801015a3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015aa:	00 
801015ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015b2:	00 
801015b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015b9:	e8 e2 2d 00 00       	call   801043a0 <memset>
      dip->type = type;
801015be:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
      dip->type = type;
801015c5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015c8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      dip->type = type;
801015cb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ce:	89 14 24             	mov    %edx,(%esp)
801015d1:	e8 ea 16 00 00       	call   80102cc0 <log_write>
      brelse(bp);
801015d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015d9:	89 14 24             	mov    %edx,(%esp)
801015dc:	e8 ff eb ff ff       	call   801001e0 <brelse>
}
801015e1:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
801015e4:	89 f2                	mov    %esi,%edx
}
801015e6:	5b                   	pop    %ebx
      return iget(dev, inum);
801015e7:	89 f8                	mov    %edi,%eax
}
801015e9:	5e                   	pop    %esi
801015ea:	5f                   	pop    %edi
801015eb:	5d                   	pop    %ebp
      return iget(dev, inum);
801015ec:	e9 bf fc ff ff       	jmp    801012b0 <iget>
  panic("ialloc: no inodes");
801015f1:	c7 04 24 38 6e 10 80 	movl   $0x80106e38,(%esp)
801015f8:	e8 63 ed ff ff       	call   80100360 <panic>
801015fd:	8d 76 00             	lea    0x0(%esi),%esi

80101600 <iupdate>:
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	83 ec 10             	sub    $0x10,%esp
80101608:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010160b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101611:	c1 e8 03             	shr    $0x3,%eax
80101614:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010161a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010161e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101621:	89 04 24             	mov    %eax,(%esp)
80101624:	e8 a7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101629:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010162c:	83 e2 07             	and    $0x7,%edx
8010162f:	c1 e2 06             	shl    $0x6,%edx
80101632:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101636:	89 c6                	mov    %eax,%esi
  dip->type = ip->type;
80101638:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163c:	83 c2 0c             	add    $0xc,%edx
  dip->type = ip->type;
8010163f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101643:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101647:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010164b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010164f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101653:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101657:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010165b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010165e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101661:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101665:	89 14 24             	mov    %edx,(%esp)
80101668:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010166f:	00 
80101670:	e8 cb 2d 00 00       	call   80104440 <memmove>
  log_write(bp);
80101675:	89 34 24             	mov    %esi,(%esp)
80101678:	e8 43 16 00 00       	call   80102cc0 <log_write>
  brelse(bp);
8010167d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101680:	83 c4 10             	add    $0x10,%esp
80101683:	5b                   	pop    %ebx
80101684:	5e                   	pop    %esi
80101685:	5d                   	pop    %ebp
  brelse(bp);
80101686:	e9 55 eb ff ff       	jmp    801001e0 <brelse>
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <idup>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	53                   	push   %ebx
80101694:	83 ec 14             	sub    $0x14,%esp
80101697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010169a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016a1:	e8 3a 2c 00 00       	call   801042e0 <acquire>
  ip->ref++;
801016a6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016aa:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016b1:	e8 9a 2c 00 00       	call   80104350 <release>
}
801016b6:	83 c4 14             	add    $0x14,%esp
801016b9:	89 d8                	mov    %ebx,%eax
801016bb:	5b                   	pop    %ebx
801016bc:	5d                   	pop    %ebp
801016bd:	c3                   	ret    
801016be:	66 90                	xchg   %ax,%ax

801016c0 <ilock>:
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	83 ec 10             	sub    $0x10,%esp
801016c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016cb:	85 db                	test   %ebx,%ebx
801016cd:	0f 84 b3 00 00 00    	je     80101786 <ilock+0xc6>
801016d3:	8b 53 08             	mov    0x8(%ebx),%edx
801016d6:	85 d2                	test   %edx,%edx
801016d8:	0f 8e a8 00 00 00    	jle    80101786 <ilock+0xc6>
  acquiresleep(&ip->lock);
801016de:	8d 43 0c             	lea    0xc(%ebx),%eax
801016e1:	89 04 24             	mov    %eax,(%esp)
801016e4:	e8 97 29 00 00       	call   80104080 <acquiresleep>
  if(ip->valid == 0){
801016e9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ec:	85 c0                	test   %eax,%eax
801016ee:	74 08                	je     801016f8 <ilock+0x38>
}
801016f0:	83 c4 10             	add    $0x10,%esp
801016f3:	5b                   	pop    %ebx
801016f4:	5e                   	pop    %esi
801016f5:	5d                   	pop    %ebp
801016f6:	c3                   	ret    
801016f7:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
801016fb:	c1 e8 03             	shr    $0x3,%eax
801016fe:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101704:	89 44 24 04          	mov    %eax,0x4(%esp)
80101708:	8b 03                	mov    (%ebx),%eax
8010170a:	89 04 24             	mov    %eax,(%esp)
8010170d:	e8 be e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101712:	8b 53 04             	mov    0x4(%ebx),%edx
80101715:	83 e2 07             	and    $0x7,%edx
80101718:	c1 e2 06             	shl    $0x6,%edx
8010171b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171f:	89 c6                	mov    %eax,%esi
    ip->type = dip->type;
80101721:	0f b7 02             	movzwl (%edx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101724:	83 c2 0c             	add    $0xc,%edx
    ip->type = dip->type;
80101727:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010172b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010172f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101733:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101737:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010173b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010173f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101743:	8b 42 fc             	mov    -0x4(%edx),%eax
80101746:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101749:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010174c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101750:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101757:	00 
80101758:	89 04 24             	mov    %eax,(%esp)
8010175b:	e8 e0 2c 00 00       	call   80104440 <memmove>
    brelse(bp);
80101760:	89 34 24             	mov    %esi,(%esp)
80101763:	e8 78 ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101768:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010176d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101774:	0f 85 76 ff ff ff    	jne    801016f0 <ilock+0x30>
      panic("ilock: no type");
8010177a:	c7 04 24 50 6e 10 80 	movl   $0x80106e50,(%esp)
80101781:	e8 da eb ff ff       	call   80100360 <panic>
    panic("ilock");
80101786:	c7 04 24 4a 6e 10 80 	movl   $0x80106e4a,(%esp)
8010178d:	e8 ce eb ff ff       	call   80100360 <panic>
80101792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017a0 <iunlock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	83 ec 10             	sub    $0x10,%esp
801017a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017ab:	85 db                	test   %ebx,%ebx
801017ad:	74 24                	je     801017d3 <iunlock+0x33>
801017af:	8d 73 0c             	lea    0xc(%ebx),%esi
801017b2:	89 34 24             	mov    %esi,(%esp)
801017b5:	e8 66 29 00 00       	call   80104120 <holdingsleep>
801017ba:	85 c0                	test   %eax,%eax
801017bc:	74 15                	je     801017d3 <iunlock+0x33>
801017be:	8b 43 08             	mov    0x8(%ebx),%eax
801017c1:	85 c0                	test   %eax,%eax
801017c3:	7e 0e                	jle    801017d3 <iunlock+0x33>
  releasesleep(&ip->lock);
801017c5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	5b                   	pop    %ebx
801017cc:	5e                   	pop    %esi
801017cd:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017ce:	e9 0d 29 00 00       	jmp    801040e0 <releasesleep>
    panic("iunlock");
801017d3:	c7 04 24 5f 6e 10 80 	movl   $0x80106e5f,(%esp)
801017da:	e8 81 eb ff ff       	call   80100360 <panic>
801017df:	90                   	nop

801017e0 <iput>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	57                   	push   %edi
801017e4:	56                   	push   %esi
801017e5:	53                   	push   %ebx
801017e6:	83 ec 1c             	sub    $0x1c,%esp
801017e9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017ec:	8d 7e 0c             	lea    0xc(%esi),%edi
801017ef:	89 3c 24             	mov    %edi,(%esp)
801017f2:	e8 89 28 00 00       	call   80104080 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017f7:	8b 56 4c             	mov    0x4c(%esi),%edx
801017fa:	85 d2                	test   %edx,%edx
801017fc:	74 07                	je     80101805 <iput+0x25>
801017fe:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101803:	74 2b                	je     80101830 <iput+0x50>
  releasesleep(&ip->lock);
80101805:	89 3c 24             	mov    %edi,(%esp)
80101808:	e8 d3 28 00 00       	call   801040e0 <releasesleep>
  acquire(&icache.lock);
8010180d:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101814:	e8 c7 2a 00 00       	call   801042e0 <acquire>
  ip->ref--;
80101819:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010181d:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101824:	83 c4 1c             	add    $0x1c,%esp
80101827:	5b                   	pop    %ebx
80101828:	5e                   	pop    %esi
80101829:	5f                   	pop    %edi
8010182a:	5d                   	pop    %ebp
  release(&icache.lock);
8010182b:	e9 20 2b 00 00       	jmp    80104350 <release>
    acquire(&icache.lock);
80101830:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101837:	e8 a4 2a 00 00       	call   801042e0 <acquire>
    int r = ip->ref;
8010183c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010183f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101846:	e8 05 2b 00 00       	call   80104350 <release>
    if(r == 1){
8010184b:	83 fb 01             	cmp    $0x1,%ebx
8010184e:	75 b5                	jne    80101805 <iput+0x25>
80101850:	8d 4e 30             	lea    0x30(%esi),%ecx
80101853:	89 f3                	mov    %esi,%ebx
80101855:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101858:	89 cf                	mov    %ecx,%edi
8010185a:	eb 0b                	jmp    80101867 <iput+0x87>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101860:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101863:	39 fb                	cmp    %edi,%ebx
80101865:	74 19                	je     80101880 <iput+0xa0>
    if(ip->addrs[i]){
80101867:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010186a:	85 d2                	test   %edx,%edx
8010186c:	74 f2                	je     80101860 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010186e:	8b 06                	mov    (%esi),%eax
80101870:	e8 9b f8 ff ff       	call   80101110 <bfree>
      ip->addrs[i] = 0;
80101875:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010187c:	eb e2                	jmp    80101860 <iput+0x80>
8010187e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101880:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101886:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101889:	85 c0                	test   %eax,%eax
8010188b:	75 2b                	jne    801018b8 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010188d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101894:	89 34 24             	mov    %esi,(%esp)
80101897:	e8 64 fd ff ff       	call   80101600 <iupdate>
      ip->type = 0;
8010189c:	31 c0                	xor    %eax,%eax
8010189e:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
801018a2:	89 34 24             	mov    %esi,(%esp)
801018a5:	e8 56 fd ff ff       	call   80101600 <iupdate>
      ip->valid = 0;
801018aa:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018b1:	e9 4f ff ff ff       	jmp    80101805 <iput+0x25>
801018b6:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018bc:	8b 06                	mov    (%esi),%eax
    for(j = 0; j < NINDIRECT; j++){
801018be:	31 db                	xor    %ebx,%ebx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018c0:	89 04 24             	mov    %eax,(%esp)
801018c3:	e8 08 e8 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801018c8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    a = (uint*)bp->data;
801018cb:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801018d1:	89 cf                	mov    %ecx,%edi
801018d3:	31 c0                	xor    %eax,%eax
801018d5:	eb 0e                	jmp    801018e5 <iput+0x105>
801018d7:	90                   	nop
801018d8:	83 c3 01             	add    $0x1,%ebx
801018db:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018e1:	89 d8                	mov    %ebx,%eax
801018e3:	74 10                	je     801018f5 <iput+0x115>
      if(a[j])
801018e5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018e8:	85 d2                	test   %edx,%edx
801018ea:	74 ec                	je     801018d8 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018ec:	8b 06                	mov    (%esi),%eax
801018ee:	e8 1d f8 ff ff       	call   80101110 <bfree>
801018f3:	eb e3                	jmp    801018d8 <iput+0xf8>
    brelse(bp);
801018f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018fb:	89 04 24             	mov    %eax,(%esp)
801018fe:	e8 dd e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101903:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101909:	8b 06                	mov    (%esi),%eax
8010190b:	e8 00 f8 ff ff       	call   80101110 <bfree>
    ip->addrs[NDIRECT] = 0;
80101910:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101917:	00 00 00 
8010191a:	e9 6e ff ff ff       	jmp    8010188d <iput+0xad>
8010191f:	90                   	nop

80101920 <iunlockput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 14             	sub    $0x14,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	89 1c 24             	mov    %ebx,(%esp)
8010192d:	e8 6e fe ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101932:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101935:	83 c4 14             	add    $0x14,%esp
80101938:	5b                   	pop    %ebx
80101939:	5d                   	pop    %ebp
  iput(ip);
8010193a:	e9 a1 fe ff ff       	jmp    801017e0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 2c             	sub    $0x2c,%esp
80101979:	8b 45 0c             	mov    0xc(%ebp),%eax
8010197c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010197f:	8b 75 10             	mov    0x10(%ebp),%esi
80101982:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101985:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101988:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
8010198d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101990:	0f 84 aa 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101996:	8b 47 58             	mov    0x58(%edi),%eax
80101999:	39 f0                	cmp    %esi,%eax
8010199b:	0f 82 c7 00 00 00    	jb     80101a68 <readi+0xf8>
801019a1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019a4:	89 da                	mov    %ebx,%edx
801019a6:	01 f2                	add    %esi,%edx
801019a8:	0f 82 ba 00 00 00    	jb     80101a68 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019ae:	89 c1                	mov    %eax,%ecx
801019b0:	29 f1                	sub    %esi,%ecx
801019b2:	39 d0                	cmp    %edx,%eax
801019b4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b7:	31 c0                	xor    %eax,%eax
801019b9:	85 c9                	test   %ecx,%ecx
    n = ip->size - off;
801019bb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019be:	74 70                	je     80101a30 <readi+0xc0>
801019c0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019c3:	89 c7                	mov    %eax,%edi
801019c5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019cb:	89 f2                	mov    %esi,%edx
801019cd:	c1 ea 09             	shr    $0x9,%edx
801019d0:	89 d8                	mov    %ebx,%eax
801019d2:	e8 99 f9 ff ff       	call   80101370 <bmap>
801019d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019db:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019dd:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019e2:	89 04 24             	mov    %eax,(%esp)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019ed:	29 f9                	sub    %edi,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ef:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019f1:	89 f0                	mov    %esi,%eax
801019f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f8:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fa:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019fe:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a00:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a04:	8b 45 e0             	mov    -0x20(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a07:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a0e:	01 df                	add    %ebx,%edi
80101a10:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a12:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a15:	89 04 24             	mov    %eax,(%esp)
80101a18:	e8 23 2a 00 00       	call   80104440 <memmove>
    brelse(bp);
80101a1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a20:	89 14 24             	mov    %edx,(%esp)
80101a23:	e8 b8 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a28:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a2e:	77 98                	ja     801019c8 <readi+0x58>
  }
  return n;
80101a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a33:	83 c4 2c             	add    $0x2c,%esp
80101a36:	5b                   	pop    %ebx
80101a37:	5e                   	pop    %esi
80101a38:	5f                   	pop    %edi
80101a39:	5d                   	pop    %ebp
80101a3a:	c3                   	ret    
80101a3b:	90                   	nop
80101a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 1e                	ja     80101a68 <readi+0xf8>
80101a4a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 13                	je     80101a68 <readi+0xf8>
    return devsw[ip->major].read(ip, dst, n);
80101a55:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a58:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101a5b:	83 c4 2c             	add    $0x2c,%esp
80101a5e:	5b                   	pop    %ebx
80101a5f:	5e                   	pop    %esi
80101a60:	5f                   	pop    %edi
80101a61:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a62:	ff e0                	jmp    *%eax
80101a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a6d:	eb c4                	jmp    80101a33 <readi+0xc3>
80101a6f:	90                   	nop

80101a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 2c             	sub    $0x2c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a90:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 e3 00 00 00    	jb     80101b88 <writei+0x118>
80101aa5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101aa8:	89 c8                	mov    %ecx,%eax
80101aaa:	01 f0                	add    %esi,%eax
80101aac:	0f 82 d6 00 00 00    	jb     80101b88 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ab2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab7:	0f 87 cb 00 00 00    	ja     80101b88 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101abd:	85 c9                	test   %ecx,%ecx
80101abf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ac6:	74 77                	je     80101b3f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101acb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101acd:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad2:	c1 ea 09             	shr    $0x9,%edx
80101ad5:	89 f8                	mov    %edi,%eax
80101ad7:	e8 94 f8 ff ff       	call   80101370 <bmap>
80101adc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ae0:	8b 07                	mov    (%edi),%eax
80101ae2:	89 04 24             	mov    %eax,(%esp)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101aed:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af5:	89 f0                	mov    %esi,%eax
80101af7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101afc:	29 c3                	sub    %eax,%ebx
80101afe:	39 cb                	cmp    %ecx,%ebx
80101b00:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b07:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b09:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b0d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b11:	89 04 24             	mov    %eax,(%esp)
80101b14:	e8 27 29 00 00       	call   80104440 <memmove>
    log_write(bp);
80101b19:	89 3c 24             	mov    %edi,(%esp)
80101b1c:	e8 9f 11 00 00       	call   80102cc0 <log_write>
    brelse(bp);
80101b21:	89 3c 24             	mov    %edi,(%esp)
80101b24:	e8 b7 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b29:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b2f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b32:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b35:	77 91                	ja     80101ac8 <writei+0x58>
  }

  if(n > 0 && off > ip->size){
80101b37:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b3d:	72 39                	jb     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b42:	83 c4 2c             	add    $0x2c,%esp
80101b45:	5b                   	pop    %ebx
80101b46:	5e                   	pop    %esi
80101b47:	5f                   	pop    %edi
80101b48:	5d                   	pop    %ebp
80101b49:	c3                   	ret    
80101b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 2e                	ja     80101b88 <writei+0x118>
80101b5a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 23                	je     80101b88 <writei+0x118>
    return devsw[ip->major].write(ip, src, n);
80101b65:	89 4d 10             	mov    %ecx,0x10(%ebp)
}
80101b68:	83 c4 2c             	add    $0x2c,%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b7b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b7e:	89 04 24             	mov    %eax,(%esp)
80101b81:	e8 7a fa ff ff       	call   80101600 <iupdate>
80101b86:	eb b7                	jmp    80101b3f <writei+0xcf>
}
80101b88:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80101b8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101b90:	5b                   	pop    %ebx
80101b91:	5e                   	pop    %esi
80101b92:	5f                   	pop    %edi
80101b93:	5d                   	pop    %ebp
80101b94:	c3                   	ret    
80101b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ba9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101bb0:	00 
80101bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bb5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb8:	89 04 24             	mov    %eax,(%esp)
80101bbb:	e8 00 29 00 00       	call   801044c0 <strncmp>
}
80101bc0:	c9                   	leave  
80101bc1:	c3                   	ret    
80101bc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	57                   	push   %edi
80101bd4:	56                   	push   %esi
80101bd5:	53                   	push   %ebx
80101bd6:	83 ec 2c             	sub    $0x2c,%esp
80101bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bdc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101be1:	0f 85 97 00 00 00    	jne    80101c7e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101be7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bea:	31 ff                	xor    %edi,%edi
80101bec:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bef:	85 d2                	test   %edx,%edx
80101bf1:	75 0d                	jne    80101c00 <dirlookup+0x30>
80101bf3:	eb 73                	jmp    80101c68 <dirlookup+0x98>
80101bf5:	8d 76 00             	lea    0x0(%esi),%esi
80101bf8:	83 c7 10             	add    $0x10,%edi
80101bfb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bfe:	76 68                	jbe    80101c68 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c00:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c07:	00 
80101c08:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c0c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c10:	89 1c 24             	mov    %ebx,(%esp)
80101c13:	e8 58 fd ff ff       	call   80101970 <readi>
80101c18:	83 f8 10             	cmp    $0x10,%eax
80101c1b:	75 55                	jne    80101c72 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c1d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c22:	74 d4                	je     80101bf8 <dirlookup+0x28>
  return strncmp(s, t, DIRSIZ);
80101c24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c27:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c2e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c35:	00 
80101c36:	89 04 24             	mov    %eax,(%esp)
80101c39:	e8 82 28 00 00       	call   801044c0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c3e:	85 c0                	test   %eax,%eax
80101c40:	75 b6                	jne    80101bf8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c42:	8b 45 10             	mov    0x10(%ebp),%eax
80101c45:	85 c0                	test   %eax,%eax
80101c47:	74 05                	je     80101c4e <dirlookup+0x7e>
        *poff = off;
80101c49:	8b 45 10             	mov    0x10(%ebp),%eax
80101c4c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c4e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c52:	8b 03                	mov    (%ebx),%eax
80101c54:	e8 57 f6 ff ff       	call   801012b0 <iget>
    }
  }

  return 0;
}
80101c59:	83 c4 2c             	add    $0x2c,%esp
80101c5c:	5b                   	pop    %ebx
80101c5d:	5e                   	pop    %esi
80101c5e:	5f                   	pop    %edi
80101c5f:	5d                   	pop    %ebp
80101c60:	c3                   	ret    
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c68:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101c6b:	31 c0                	xor    %eax,%eax
}
80101c6d:	5b                   	pop    %ebx
80101c6e:	5e                   	pop    %esi
80101c6f:	5f                   	pop    %edi
80101c70:	5d                   	pop    %ebp
80101c71:	c3                   	ret    
      panic("dirlookup read");
80101c72:	c7 04 24 79 6e 10 80 	movl   $0x80106e79,(%esp)
80101c79:	e8 e2 e6 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101c7e:	c7 04 24 67 6e 10 80 	movl   $0x80106e67,(%esp)
80101c85:	e8 d6 e6 ff ff       	call   80100360 <panic>
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	89 cf                	mov    %ecx,%edi
80101c96:	56                   	push   %esi
80101c97:	53                   	push   %ebx
80101c98:	89 c3                	mov    %eax,%ebx
80101c9a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c9d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101ca0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101ca3:	0f 84 51 01 00 00    	je     80101dfa <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ca9:	e8 12 1a 00 00       	call   801036c0 <myproc>
80101cae:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101cb1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cb8:	e8 23 26 00 00       	call   801042e0 <acquire>
  ip->ref++;
80101cbd:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cc1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cc8:	e8 83 26 00 00       	call   80104350 <release>
80101ccd:	eb 04                	jmp    80101cd3 <namex+0x43>
80101ccf:	90                   	nop
    path++;
80101cd0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cd3:	0f b6 03             	movzbl (%ebx),%eax
80101cd6:	3c 2f                	cmp    $0x2f,%al
80101cd8:	74 f6                	je     80101cd0 <namex+0x40>
  if(*path == 0)
80101cda:	84 c0                	test   %al,%al
80101cdc:	0f 84 ed 00 00 00    	je     80101dcf <namex+0x13f>
  while(*path != '/' && *path != 0)
80101ce2:	0f b6 03             	movzbl (%ebx),%eax
80101ce5:	89 da                	mov    %ebx,%edx
80101ce7:	84 c0                	test   %al,%al
80101ce9:	0f 84 b1 00 00 00    	je     80101da0 <namex+0x110>
80101cef:	3c 2f                	cmp    $0x2f,%al
80101cf1:	75 0f                	jne    80101d02 <namex+0x72>
80101cf3:	e9 a8 00 00 00       	jmp    80101da0 <namex+0x110>
80101cf8:	3c 2f                	cmp    $0x2f,%al
80101cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d00:	74 0a                	je     80101d0c <namex+0x7c>
    path++;
80101d02:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d05:	0f b6 02             	movzbl (%edx),%eax
80101d08:	84 c0                	test   %al,%al
80101d0a:	75 ec                	jne    80101cf8 <namex+0x68>
80101d0c:	89 d1                	mov    %edx,%ecx
80101d0e:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d10:	83 f9 0d             	cmp    $0xd,%ecx
80101d13:	0f 8e 8f 00 00 00    	jle    80101da8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d19:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d1d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d24:	00 
80101d25:	89 3c 24             	mov    %edi,(%esp)
80101d28:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d2b:	e8 10 27 00 00       	call   80104440 <memmove>
    path++;
80101d30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d33:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d35:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d38:	75 0e                	jne    80101d48 <namex+0xb8>
80101d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d40:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d43:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d46:	74 f8                	je     80101d40 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d48:	89 34 24             	mov    %esi,(%esp)
80101d4b:	e8 70 f9 ff ff       	call   801016c0 <ilock>
    if(ip->type != T_DIR){
80101d50:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d55:	0f 85 85 00 00 00    	jne    80101de0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d5e:	85 d2                	test   %edx,%edx
80101d60:	74 09                	je     80101d6b <namex+0xdb>
80101d62:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d65:	0f 84 a5 00 00 00    	je     80101e10 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d72:	00 
80101d73:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d77:	89 34 24             	mov    %esi,(%esp)
80101d7a:	e8 51 fe ff ff       	call   80101bd0 <dirlookup>
80101d7f:	85 c0                	test   %eax,%eax
80101d81:	74 5d                	je     80101de0 <namex+0x150>
  iunlock(ip);
80101d83:	89 34 24             	mov    %esi,(%esp)
80101d86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d89:	e8 12 fa ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101d8e:	89 34 24             	mov    %esi,(%esp)
80101d91:	e8 4a fa ff ff       	call   801017e0 <iput>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d99:	89 c6                	mov    %eax,%esi
80101d9b:	e9 33 ff ff ff       	jmp    80101cd3 <namex+0x43>
  while(*path != '/' && *path != 0)
80101da0:	31 c9                	xor    %ecx,%ecx
80101da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(name, s, len);
80101da8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101dac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101db0:	89 3c 24             	mov    %edi,(%esp)
80101db3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101db9:	e8 82 26 00 00       	call   80104440 <memmove>
    name[len] = 0;
80101dbe:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dc1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dc4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dc8:	89 d3                	mov    %edx,%ebx
80101dca:	e9 66 ff ff ff       	jmp    80101d35 <namex+0xa5>
  }
  if(nameiparent){
80101dcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dd2:	85 c0                	test   %eax,%eax
80101dd4:	75 4c                	jne    80101e22 <namex+0x192>
80101dd6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd8:	83 c4 2c             	add    $0x2c,%esp
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
  iunlock(ip);
80101de0:	89 34 24             	mov    %esi,(%esp)
80101de3:	e8 b8 f9 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101de8:	89 34 24             	mov    %esi,(%esp)
80101deb:	e8 f0 f9 ff ff       	call   801017e0 <iput>
}
80101df0:	83 c4 2c             	add    $0x2c,%esp
      return 0;
80101df3:	31 c0                	xor    %eax,%eax
}
80101df5:	5b                   	pop    %ebx
80101df6:	5e                   	pop    %esi
80101df7:	5f                   	pop    %edi
80101df8:	5d                   	pop    %ebp
80101df9:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101dfa:	ba 01 00 00 00       	mov    $0x1,%edx
80101dff:	b8 01 00 00 00       	mov    $0x1,%eax
80101e04:	e8 a7 f4 ff ff       	call   801012b0 <iget>
80101e09:	89 c6                	mov    %eax,%esi
80101e0b:	e9 c3 fe ff ff       	jmp    80101cd3 <namex+0x43>
      iunlock(ip);
80101e10:	89 34 24             	mov    %esi,(%esp)
80101e13:	e8 88 f9 ff ff       	call   801017a0 <iunlock>
}
80101e18:	83 c4 2c             	add    $0x2c,%esp
      return ip;
80101e1b:	89 f0                	mov    %esi,%eax
}
80101e1d:	5b                   	pop    %ebx
80101e1e:	5e                   	pop    %esi
80101e1f:	5f                   	pop    %edi
80101e20:	5d                   	pop    %ebp
80101e21:	c3                   	ret    
    iput(ip);
80101e22:	89 34 24             	mov    %esi,(%esp)
80101e25:	e8 b6 f9 ff ff       	call   801017e0 <iput>
    return 0;
80101e2a:	31 c0                	xor    %eax,%eax
80101e2c:	eb aa                	jmp    80101dd8 <namex+0x148>
80101e2e:	66 90                	xchg   %ax,%ax

80101e30 <dirlink>:
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 2c             	sub    $0x2c,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e46:	00 
80101e47:	89 1c 24             	mov    %ebx,(%esp)
80101e4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e4e:	e8 7d fd ff ff       	call   80101bd0 <dirlookup>
80101e53:	85 c0                	test   %eax,%eax
80101e55:	0f 85 8b 00 00 00    	jne    80101ee6 <dirlink+0xb6>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e5b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e5e:	31 ff                	xor    %edi,%edi
80101e60:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e63:	85 c0                	test   %eax,%eax
80101e65:	75 13                	jne    80101e7a <dirlink+0x4a>
80101e67:	eb 35                	jmp    80101e9e <dirlink+0x6e>
80101e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e70:	8d 57 10             	lea    0x10(%edi),%edx
80101e73:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e76:	89 d7                	mov    %edx,%edi
80101e78:	76 24                	jbe    80101e9e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e7a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e81:	00 
80101e82:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e86:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e8a:	89 1c 24             	mov    %ebx,(%esp)
80101e8d:	e8 de fa ff ff       	call   80101970 <readi>
80101e92:	83 f8 10             	cmp    $0x10,%eax
80101e95:	75 5e                	jne    80101ef5 <dirlink+0xc5>
    if(de.inum == 0)
80101e97:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e9c:	75 d2                	jne    80101e70 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
80101e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ea8:	00 
80101ea9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ead:	8d 45 da             	lea    -0x26(%ebp),%eax
80101eb0:	89 04 24             	mov    %eax,(%esp)
80101eb3:	e8 78 26 00 00       	call   80104530 <strncpy>
  de.inum = inum;
80101eb8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ebb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ec2:	00 
80101ec3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ec7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101ecb:	89 1c 24             	mov    %ebx,(%esp)
  de.inum = inum;
80101ece:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ed2:	e8 99 fb ff ff       	call   80101a70 <writei>
80101ed7:	83 f8 10             	cmp    $0x10,%eax
80101eda:	75 25                	jne    80101f01 <dirlink+0xd1>
  return 0;
80101edc:	31 c0                	xor    %eax,%eax
}
80101ede:	83 c4 2c             	add    $0x2c,%esp
80101ee1:	5b                   	pop    %ebx
80101ee2:	5e                   	pop    %esi
80101ee3:	5f                   	pop    %edi
80101ee4:	5d                   	pop    %ebp
80101ee5:	c3                   	ret    
    iput(ip);
80101ee6:	89 04 24             	mov    %eax,(%esp)
80101ee9:	e8 f2 f8 ff ff       	call   801017e0 <iput>
    return -1;
80101eee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef3:	eb e9                	jmp    80101ede <dirlink+0xae>
      panic("dirlink read");
80101ef5:	c7 04 24 88 6e 10 80 	movl   $0x80106e88,(%esp)
80101efc:	e8 5f e4 ff ff       	call   80100360 <panic>
    panic("dirlink");
80101f01:	c7 04 24 a2 74 10 80 	movl   $0x801074a2,(%esp)
80101f08:	e8 53 e4 ff ff       	call   80100360 <panic>
80101f0d:	8d 76 00             	lea    0x0(%esi),%esi

80101f10 <namei>:

struct inode*
namei(char *path)
{
80101f10:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f11:	31 d2                	xor    %edx,%edx
{
80101f13:	89 e5                	mov    %esp,%ebp
80101f15:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f18:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f1e:	e8 6d fd ff ff       	call   80101c90 <namex>
}
80101f23:	c9                   	leave  
80101f24:	c3                   	ret    
80101f25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f30 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f30:	55                   	push   %ebp
  return namex(path, 1, name);
80101f31:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f36:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f3e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f3f:	e9 4c fd ff ff       	jmp    80101c90 <namex>
80101f44:	66 90                	xchg   %ax,%ax
80101f46:	66 90                	xchg   %ax,%ax
80101f48:	66 90                	xchg   %ax,%ax
80101f4a:	66 90                	xchg   %ax,%ax
80101f4c:	66 90                	xchg   %ax,%ax
80101f4e:	66 90                	xchg   %ax,%ax

80101f50 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	56                   	push   %esi
80101f54:	89 c6                	mov    %eax,%esi
80101f56:	53                   	push   %ebx
80101f57:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f5a:	85 c0                	test   %eax,%eax
80101f5c:	0f 84 99 00 00 00    	je     80101ffb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f62:	8b 48 08             	mov    0x8(%eax),%ecx
80101f65:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f6b:	0f 87 7e 00 00 00    	ja     80101fef <idestart+0x9f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f71:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f76:	66 90                	xchg   %ax,%ax
80101f78:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f79:	83 e0 c0             	and    $0xffffffc0,%eax
80101f7c:	3c 40                	cmp    $0x40,%al
80101f7e:	75 f8                	jne    80101f78 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f80:	31 db                	xor    %ebx,%ebx
80101f82:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f87:	89 d8                	mov    %ebx,%eax
80101f89:	ee                   	out    %al,(%dx)
80101f8a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f8f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f94:	ee                   	out    %al,(%dx)
80101f95:	0f b6 c1             	movzbl %cl,%eax
80101f98:	b2 f3                	mov    $0xf3,%dl
80101f9a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f9b:	89 c8                	mov    %ecx,%eax
80101f9d:	b2 f4                	mov    $0xf4,%dl
80101f9f:	c1 f8 08             	sar    $0x8,%eax
80101fa2:	ee                   	out    %al,(%dx)
80101fa3:	b2 f5                	mov    $0xf5,%dl
80101fa5:	89 d8                	mov    %ebx,%eax
80101fa7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fa8:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fac:	b2 f6                	mov    $0xf6,%dl
80101fae:	83 e0 01             	and    $0x1,%eax
80101fb1:	c1 e0 04             	shl    $0x4,%eax
80101fb4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fb7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fb8:	f6 06 04             	testb  $0x4,(%esi)
80101fbb:	75 13                	jne    80101fd0 <idestart+0x80>
80101fbd:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fc2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fc7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fc8:	83 c4 10             	add    $0x10,%esp
80101fcb:	5b                   	pop    %ebx
80101fcc:	5e                   	pop    %esi
80101fcd:	5d                   	pop    %ebp
80101fce:	c3                   	ret    
80101fcf:	90                   	nop
80101fd0:	b2 f7                	mov    $0xf7,%dl
80101fd2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fd7:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fd8:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fdd:	83 c6 5c             	add    $0x5c,%esi
80101fe0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fe5:	fc                   	cld    
80101fe6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fe8:	83 c4 10             	add    $0x10,%esp
80101feb:	5b                   	pop    %ebx
80101fec:	5e                   	pop    %esi
80101fed:	5d                   	pop    %ebp
80101fee:	c3                   	ret    
    panic("incorrect blockno");
80101fef:	c7 04 24 f4 6e 10 80 	movl   $0x80106ef4,(%esp)
80101ff6:	e8 65 e3 ff ff       	call   80100360 <panic>
    panic("idestart");
80101ffb:	c7 04 24 eb 6e 10 80 	movl   $0x80106eeb,(%esp)
80102002:	e8 59 e3 ff ff       	call   80100360 <panic>
80102007:	89 f6                	mov    %esi,%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <ideinit>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
80102016:	c7 44 24 04 06 6f 10 	movl   $0x80106f06,0x4(%esp)
8010201d:	80 
8010201e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102025:	e8 46 21 00 00       	call   80104170 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010202a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010202f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102036:	83 e8 01             	sub    $0x1,%eax
80102039:	89 44 24 04          	mov    %eax,0x4(%esp)
8010203d:	e8 7e 02 00 00       	call   801022c0 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102042:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102047:	90                   	nop
80102048:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102049:	83 e0 c0             	and    $0xffffffc0,%eax
8010204c:	3c 40                	cmp    $0x40,%al
8010204e:	75 f8                	jne    80102048 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102050:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102055:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010205a:	ee                   	out    %al,(%dx)
8010205b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102060:	b2 f7                	mov    $0xf7,%dl
80102062:	eb 09                	jmp    8010206d <ideinit+0x5d>
80102064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<1000; i++){
80102068:	83 e9 01             	sub    $0x1,%ecx
8010206b:	74 0f                	je     8010207c <ideinit+0x6c>
8010206d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010206e:	84 c0                	test   %al,%al
80102070:	74 f6                	je     80102068 <ideinit+0x58>
      havedisk1 = 1;
80102072:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102079:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010207c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102081:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102086:	ee                   	out    %al,(%dx)
}
80102087:	c9                   	leave  
80102088:	c3                   	ret    
80102089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102090 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102099:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020a0:	e8 3b 22 00 00       	call   801042e0 <acquire>

  if((b = idequeue) == 0){
801020a5:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020ab:	85 db                	test   %ebx,%ebx
801020ad:	74 30                	je     801020df <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020af:	8b 43 58             	mov    0x58(%ebx),%eax
801020b2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020b7:	8b 33                	mov    (%ebx),%esi
801020b9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020bf:	74 37                	je     801020f8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020c1:	83 e6 fb             	and    $0xfffffffb,%esi
801020c4:	83 ce 02             	or     $0x2,%esi
801020c7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020c9:	89 1c 24             	mov    %ebx,(%esp)
801020cc:	e8 8f 1d 00 00       	call   80103e60 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020d1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020d6:	85 c0                	test   %eax,%eax
801020d8:	74 05                	je     801020df <ideintr+0x4f>
    idestart(idequeue);
801020da:	e8 71 fe ff ff       	call   80101f50 <idestart>
    release(&idelock);
801020df:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020e6:	e8 65 22 00 00       	call   80104350 <release>

  release(&idelock);
}
801020eb:	83 c4 1c             	add    $0x1c,%esp
801020ee:	5b                   	pop    %ebx
801020ef:	5e                   	pop    %esi
801020f0:	5f                   	pop    %edi
801020f1:	5d                   	pop    %ebp
801020f2:	c3                   	ret    
801020f3:	90                   	nop
801020f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020f8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020fd:	8d 76 00             	lea    0x0(%esi),%esi
80102100:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102101:	89 c1                	mov    %eax,%ecx
80102103:	83 e1 c0             	and    $0xffffffc0,%ecx
80102106:	80 f9 40             	cmp    $0x40,%cl
80102109:	75 f5                	jne    80102100 <ideintr+0x70>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010210b:	a8 21                	test   $0x21,%al
8010210d:	75 b2                	jne    801020c1 <ideintr+0x31>
    insl(0x1f0, b->data, BSIZE/4);
8010210f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102112:	b9 80 00 00 00       	mov    $0x80,%ecx
80102117:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211c:	fc                   	cld    
8010211d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010211f:	8b 33                	mov    (%ebx),%esi
80102121:	eb 9e                	jmp    801020c1 <ideintr+0x31>
80102123:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102130 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	53                   	push   %ebx
80102134:	83 ec 14             	sub    $0x14,%esp
80102137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010213a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010213d:	89 04 24             	mov    %eax,(%esp)
80102140:	e8 db 1f 00 00       	call   80104120 <holdingsleep>
80102145:	85 c0                	test   %eax,%eax
80102147:	0f 84 9e 00 00 00    	je     801021eb <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010214d:	8b 03                	mov    (%ebx),%eax
8010214f:	83 e0 06             	and    $0x6,%eax
80102152:	83 f8 02             	cmp    $0x2,%eax
80102155:	0f 84 a8 00 00 00    	je     80102203 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010215b:	8b 53 04             	mov    0x4(%ebx),%edx
8010215e:	85 d2                	test   %edx,%edx
80102160:	74 0d                	je     8010216f <iderw+0x3f>
80102162:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102167:	85 c0                	test   %eax,%eax
80102169:	0f 84 88 00 00 00    	je     801021f7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010216f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102176:	e8 65 21 00 00       	call   801042e0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
80102180:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102187:	85 c0                	test   %eax,%eax
80102189:	75 07                	jne    80102192 <iderw+0x62>
8010218b:	eb 4e                	jmp    801021db <iderw+0xab>
8010218d:	8d 76 00             	lea    0x0(%esi),%esi
80102190:	89 d0                	mov    %edx,%eax
80102192:	8b 50 58             	mov    0x58(%eax),%edx
80102195:	85 d2                	test   %edx,%edx
80102197:	75 f7                	jne    80102190 <iderw+0x60>
80102199:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010219c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010219e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021a4:	74 3c                	je     801021e2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021a6:	8b 03                	mov    (%ebx),%eax
801021a8:	83 e0 06             	and    $0x6,%eax
801021ab:	83 f8 02             	cmp    $0x2,%eax
801021ae:	74 1a                	je     801021ca <iderw+0x9a>
    sleep(b, &idelock);
801021b0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021b7:	80 
801021b8:	89 1c 24             	mov    %ebx,(%esp)
801021bb:	e8 00 1b 00 00       	call   80103cc0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021c0:	8b 13                	mov    (%ebx),%edx
801021c2:	83 e2 06             	and    $0x6,%edx
801021c5:	83 fa 02             	cmp    $0x2,%edx
801021c8:	75 e6                	jne    801021b0 <iderw+0x80>
  }


  release(&idelock);
801021ca:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021d1:	83 c4 14             	add    $0x14,%esp
801021d4:	5b                   	pop    %ebx
801021d5:	5d                   	pop    %ebp
  release(&idelock);
801021d6:	e9 75 21 00 00       	jmp    80104350 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021db:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021e0:	eb ba                	jmp    8010219c <iderw+0x6c>
    idestart(b);
801021e2:	89 d8                	mov    %ebx,%eax
801021e4:	e8 67 fd ff ff       	call   80101f50 <idestart>
801021e9:	eb bb                	jmp    801021a6 <iderw+0x76>
    panic("iderw: buf not locked");
801021eb:	c7 04 24 0a 6f 10 80 	movl   $0x80106f0a,(%esp)
801021f2:	e8 69 e1 ff ff       	call   80100360 <panic>
    panic("iderw: ide disk 1 not present");
801021f7:	c7 04 24 35 6f 10 80 	movl   $0x80106f35,(%esp)
801021fe:	e8 5d e1 ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
80102203:	c7 04 24 20 6f 10 80 	movl   $0x80106f20,(%esp)
8010220a:	e8 51 e1 ff ff       	call   80100360 <panic>
8010220f:	90                   	nop

80102210 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	56                   	push   %esi
80102214:	53                   	push   %ebx
80102215:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102218:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010221f:	00 c0 fe 
  ioapic->reg = reg;
80102222:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102229:	00 00 00 
  return ioapic->data;
8010222c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102232:	8b 42 10             	mov    0x10(%edx),%eax
  ioapic->reg = reg;
80102235:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010223b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102241:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102248:	c1 e8 10             	shr    $0x10,%eax
8010224b:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010224e:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102251:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102254:	39 c2                	cmp    %eax,%edx
80102256:	74 12                	je     8010226a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102258:	c7 04 24 54 6f 10 80 	movl   $0x80106f54,(%esp)
8010225f:	e8 ec e3 ff ff       	call   80100650 <cprintf>
80102264:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010226a:	ba 10 00 00 00       	mov    $0x10,%edx
8010226f:	31 c0                	xor    %eax,%eax
80102271:	eb 07                	jmp    8010227a <ioapicinit+0x6a>
80102273:	90                   	nop
80102274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102278:	89 cb                	mov    %ecx,%ebx
  ioapic->reg = reg;
8010227a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010227c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102282:	8d 48 20             	lea    0x20(%eax),%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102285:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  for(i = 0; i <= maxintr; i++){
8010228b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010228e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102291:	8d 4a 01             	lea    0x1(%edx),%ecx
80102294:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102297:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102299:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010229f:	39 c6                	cmp    %eax,%esi
  ioapic->data = data;
801022a1:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022a8:	7d ce                	jge    80102278 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022aa:	83 c4 10             	add    $0x10,%esp
801022ad:	5b                   	pop    %ebx
801022ae:	5e                   	pop    %esi
801022af:	5d                   	pop    %ebp
801022b0:	c3                   	ret    
801022b1:	eb 0d                	jmp    801022c0 <ioapicenable>
801022b3:	90                   	nop
801022b4:	90                   	nop
801022b5:	90                   	nop
801022b6:	90                   	nop
801022b7:	90                   	nop
801022b8:	90                   	nop
801022b9:	90                   	nop
801022ba:	90                   	nop
801022bb:	90                   	nop
801022bc:	90                   	nop
801022bd:	90                   	nop
801022be:	90                   	nop
801022bf:	90                   	nop

801022c0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	8b 55 08             	mov    0x8(%ebp),%edx
801022c6:	53                   	push   %ebx
801022c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ca:	8d 5a 20             	lea    0x20(%edx),%ebx
801022cd:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
  ioapic->reg = reg;
801022d1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022d7:	c1 e0 18             	shl    $0x18,%eax
  ioapic->reg = reg;
801022da:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022dc:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022e2:	83 c1 01             	add    $0x1,%ecx
  ioapic->data = data;
801022e5:	89 5a 10             	mov    %ebx,0x10(%edx)
  ioapic->reg = reg;
801022e8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022ea:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022f0:	89 42 10             	mov    %eax,0x10(%edx)
}
801022f3:	5b                   	pop    %ebx
801022f4:	5d                   	pop    %ebp
801022f5:	c3                   	ret    
801022f6:	66 90                	xchg   %ax,%ax
801022f8:	66 90                	xchg   %ax,%ax
801022fa:	66 90                	xchg   %ax,%ax
801022fc:	66 90                	xchg   %ax,%ax
801022fe:	66 90                	xchg   %ax,%ax

80102300 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	53                   	push   %ebx
80102304:	83 ec 14             	sub    $0x14,%esp
80102307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010230a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102310:	75 7c                	jne    8010238e <kfree+0x8e>
80102312:	81 fb a8 58 11 80    	cmp    $0x801158a8,%ebx
80102318:	72 74                	jb     8010238e <kfree+0x8e>
8010231a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102320:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102325:	77 67                	ja     8010238e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102327:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010232e:	00 
8010232f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102336:	00 
80102337:	89 1c 24             	mov    %ebx,(%esp)
8010233a:	e8 61 20 00 00       	call   801043a0 <memset>

  if(kmem.use_lock)
8010233f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102345:	85 d2                	test   %edx,%edx
80102347:	75 37                	jne    80102380 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102349:	a1 78 26 11 80       	mov    0x80112678,%eax
8010234e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102350:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102355:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010235b:	85 c0                	test   %eax,%eax
8010235d:	75 09                	jne    80102368 <kfree+0x68>
    release(&kmem.lock);
}
8010235f:	83 c4 14             	add    $0x14,%esp
80102362:	5b                   	pop    %ebx
80102363:	5d                   	pop    %ebp
80102364:	c3                   	ret    
80102365:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102368:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010236f:	83 c4 14             	add    $0x14,%esp
80102372:	5b                   	pop    %ebx
80102373:	5d                   	pop    %ebp
    release(&kmem.lock);
80102374:	e9 d7 1f 00 00       	jmp    80104350 <release>
80102379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102380:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102387:	e8 54 1f 00 00       	call   801042e0 <acquire>
8010238c:	eb bb                	jmp    80102349 <kfree+0x49>
    panic("kfree");
8010238e:	c7 04 24 86 6f 10 80 	movl   $0x80106f86,(%esp)
80102395:	e8 c6 df ff ff       	call   80100360 <panic>
8010239a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023a0 <freerange>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
801023a5:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
801023a8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ae:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023b4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ba:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023c0:	39 de                	cmp    %ebx,%esi
801023c2:	73 08                	jae    801023cc <freerange+0x2c>
801023c4:	eb 18                	jmp    801023de <freerange+0x3e>
801023c6:	66 90                	xchg   %ax,%ax
801023c8:	89 da                	mov    %ebx,%edx
801023ca:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023cc:	89 14 24             	mov    %edx,(%esp)
801023cf:	e8 2c ff ff ff       	call   80102300 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023da:	39 f0                	cmp    %esi,%eax
801023dc:	76 ea                	jbe    801023c8 <freerange+0x28>
}
801023de:	83 c4 10             	add    $0x10,%esp
801023e1:	5b                   	pop    %ebx
801023e2:	5e                   	pop    %esi
801023e3:	5d                   	pop    %ebp
801023e4:	c3                   	ret    
801023e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023f0 <kinit1>:
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	83 ec 10             	sub    $0x10,%esp
801023f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023fb:	c7 44 24 04 8c 6f 10 	movl   $0x80106f8c,0x4(%esp)
80102402:	80 
80102403:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010240a:	e8 61 1d 00 00       	call   80104170 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010240f:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
80102412:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102419:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010241c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102422:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102428:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010242e:	39 de                	cmp    %ebx,%esi
80102430:	73 0a                	jae    8010243c <kinit1+0x4c>
80102432:	eb 1a                	jmp    8010244e <kinit1+0x5e>
80102434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102438:	89 da                	mov    %ebx,%edx
8010243a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010243c:	89 14 24             	mov    %edx,(%esp)
8010243f:	e8 bc fe ff ff       	call   80102300 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102444:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010244a:	39 c6                	cmp    %eax,%esi
8010244c:	73 ea                	jae    80102438 <kinit1+0x48>
}
8010244e:	83 c4 10             	add    $0x10,%esp
80102451:	5b                   	pop    %ebx
80102452:	5e                   	pop    %esi
80102453:	5d                   	pop    %ebp
80102454:	c3                   	ret    
80102455:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
80102465:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102468:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010246b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010246e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102474:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010247a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102480:	39 de                	cmp    %ebx,%esi
80102482:	73 08                	jae    8010248c <kinit2+0x2c>
80102484:	eb 18                	jmp    8010249e <kinit2+0x3e>
80102486:	66 90                	xchg   %ax,%ax
80102488:	89 da                	mov    %ebx,%edx
8010248a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010248c:	89 14 24             	mov    %edx,(%esp)
8010248f:	e8 6c fe ff ff       	call   80102300 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102494:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010249a:	39 c6                	cmp    %eax,%esi
8010249c:	73 ea                	jae    80102488 <kinit2+0x28>
  kmem.use_lock = 1;
8010249e:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024a5:	00 00 00 
}
801024a8:	83 c4 10             	add    $0x10,%esp
801024ab:	5b                   	pop    %ebx
801024ac:	5e                   	pop    %esi
801024ad:	5d                   	pop    %ebp
801024ae:	c3                   	ret    
801024af:	90                   	nop

801024b0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	53                   	push   %ebx
801024b4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024b7:	a1 74 26 11 80       	mov    0x80112674,%eax
801024bc:	85 c0                	test   %eax,%eax
801024be:	75 30                	jne    801024f0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024c0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024c6:	85 db                	test   %ebx,%ebx
801024c8:	74 08                	je     801024d2 <kalloc+0x22>
    kmem.freelist = r->next;
801024ca:	8b 13                	mov    (%ebx),%edx
801024cc:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024d2:	85 c0                	test   %eax,%eax
801024d4:	74 0c                	je     801024e2 <kalloc+0x32>
    release(&kmem.lock);
801024d6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024dd:	e8 6e 1e 00 00       	call   80104350 <release>
  return (char*)r;
}
801024e2:	83 c4 14             	add    $0x14,%esp
801024e5:	89 d8                	mov    %ebx,%eax
801024e7:	5b                   	pop    %ebx
801024e8:	5d                   	pop    %ebp
801024e9:	c3                   	ret    
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
801024f0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024f7:	e8 e4 1d 00 00       	call   801042e0 <acquire>
801024fc:	a1 74 26 11 80       	mov    0x80112674,%eax
80102501:	eb bd                	jmp    801024c0 <kalloc+0x10>
80102503:	66 90                	xchg   %ax,%ax
80102505:	66 90                	xchg   %ax,%ax
80102507:	66 90                	xchg   %ax,%ax
80102509:	66 90                	xchg   %ax,%ax
8010250b:	66 90                	xchg   %ax,%ax
8010250d:	66 90                	xchg   %ax,%ax
8010250f:	90                   	nop

80102510 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102510:	ba 64 00 00 00       	mov    $0x64,%edx
80102515:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102516:	a8 01                	test   $0x1,%al
80102518:	0f 84 ba 00 00 00    	je     801025d8 <kbdgetc+0xc8>
8010251e:	b2 60                	mov    $0x60,%dl
80102520:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102521:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102524:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010252a:	0f 84 88 00 00 00    	je     801025b8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102530:	84 c0                	test   %al,%al
80102532:	79 2c                	jns    80102560 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102534:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010253a:	f6 c2 40             	test   $0x40,%dl
8010253d:	75 05                	jne    80102544 <kbdgetc+0x34>
8010253f:	89 c1                	mov    %eax,%ecx
80102541:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102544:	0f b6 81 c0 70 10 80 	movzbl -0x7fef8f40(%ecx),%eax
8010254b:	83 c8 40             	or     $0x40,%eax
8010254e:	0f b6 c0             	movzbl %al,%eax
80102551:	f7 d0                	not    %eax
80102553:	21 d0                	and    %edx,%eax
80102555:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010255a:	31 c0                	xor    %eax,%eax
8010255c:	c3                   	ret    
8010255d:	8d 76 00             	lea    0x0(%esi),%esi
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	53                   	push   %ebx
80102564:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(shift & E0ESC){
8010256a:	f6 c3 40             	test   $0x40,%bl
8010256d:	74 09                	je     80102578 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102572:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102575:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102578:	0f b6 91 c0 70 10 80 	movzbl -0x7fef8f40(%ecx),%edx
  shift ^= togglecode[data];
8010257f:	0f b6 81 c0 6f 10 80 	movzbl -0x7fef9040(%ecx),%eax
  shift |= shiftcode[data];
80102586:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102588:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010258a:	89 d0                	mov    %edx,%eax
8010258c:	83 e0 03             	and    $0x3,%eax
8010258f:	8b 04 85 a0 6f 10 80 	mov    -0x7fef9060(,%eax,4),%eax
  shift ^= togglecode[data];
80102596:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  if(shift & CAPSLOCK){
8010259c:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010259f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801025a3:	74 0b                	je     801025b0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801025a5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a8:	83 fa 19             	cmp    $0x19,%edx
801025ab:	77 1b                	ja     801025c8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025ad:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025b0:	5b                   	pop    %ebx
801025b1:	5d                   	pop    %ebp
801025b2:	c3                   	ret    
801025b3:	90                   	nop
801025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025b8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025bf:	31 c0                	xor    %eax,%eax
801025c1:	c3                   	ret    
801025c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801025c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025cb:	8d 50 20             	lea    0x20(%eax),%edx
801025ce:	83 f9 19             	cmp    $0x19,%ecx
801025d1:	0f 46 c2             	cmovbe %edx,%eax
  return c;
801025d4:	eb da                	jmp    801025b0 <kbdgetc+0xa0>
801025d6:	66 90                	xchg   %ax,%ax
    return -1;
801025d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025dd:	c3                   	ret    
801025de:	66 90                	xchg   %ax,%ax

801025e0 <kbdintr>:

void
kbdintr(void)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025e6:	c7 04 24 10 25 10 80 	movl   $0x80102510,(%esp)
801025ed:	e8 be e1 ff ff       	call   801007b0 <consoleintr>
}
801025f2:	c9                   	leave  
801025f3:	c3                   	ret    
801025f4:	66 90                	xchg   %ax,%ax
801025f6:	66 90                	xchg   %ax,%ax
801025f8:	66 90                	xchg   %ax,%ax
801025fa:	66 90                	xchg   %ax,%ax
801025fc:	66 90                	xchg   %ax,%ax
801025fe:	66 90                	xchg   %ax,%ax

80102600 <fill_rtcdate>:
  return inb(CMOS_RETURN);
}

static void
fill_rtcdate(struct rtcdate *r)
{
80102600:	55                   	push   %ebp
80102601:	89 c1                	mov    %eax,%ecx
80102603:	89 e5                	mov    %esp,%ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102605:	ba 70 00 00 00       	mov    $0x70,%edx
8010260a:	53                   	push   %ebx
8010260b:	31 c0                	xor    %eax,%eax
8010260d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010260e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102613:	89 da                	mov    %ebx,%edx
80102615:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
80102616:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102619:	b2 70                	mov    $0x70,%dl
8010261b:	89 01                	mov    %eax,(%ecx)
8010261d:	b8 02 00 00 00       	mov    $0x2,%eax
80102622:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102623:	89 da                	mov    %ebx,%edx
80102625:	ec                   	in     (%dx),%al
80102626:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102629:	b2 70                	mov    $0x70,%dl
8010262b:	89 41 04             	mov    %eax,0x4(%ecx)
8010262e:	b8 04 00 00 00       	mov    $0x4,%eax
80102633:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102634:	89 da                	mov    %ebx,%edx
80102636:	ec                   	in     (%dx),%al
80102637:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010263a:	b2 70                	mov    $0x70,%dl
8010263c:	89 41 08             	mov    %eax,0x8(%ecx)
8010263f:	b8 07 00 00 00       	mov    $0x7,%eax
80102644:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102645:	89 da                	mov    %ebx,%edx
80102647:	ec                   	in     (%dx),%al
80102648:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010264b:	b2 70                	mov    $0x70,%dl
8010264d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102650:	b8 08 00 00 00       	mov    $0x8,%eax
80102655:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102656:	89 da                	mov    %ebx,%edx
80102658:	ec                   	in     (%dx),%al
80102659:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010265c:	b2 70                	mov    $0x70,%dl
8010265e:	89 41 10             	mov    %eax,0x10(%ecx)
80102661:	b8 09 00 00 00       	mov    $0x9,%eax
80102666:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102667:	89 da                	mov    %ebx,%edx
80102669:	ec                   	in     (%dx),%al
8010266a:	0f b6 d8             	movzbl %al,%ebx
8010266d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102670:	5b                   	pop    %ebx
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102680 <lapicinit>:
  if(!lapic)
80102680:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102685:	55                   	push   %ebp
80102686:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102688:	85 c0                	test   %eax,%eax
8010268a:	0f 84 c0 00 00 00    	je     80102750 <lapicinit+0xd0>
  lapic[index] = value;
80102690:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102697:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010269a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010269d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026aa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026b1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026b4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026be:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026c1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026cb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026d8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026db:	8b 50 20             	mov    0x20(%eax),%edx
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026de:	8b 50 30             	mov    0x30(%eax),%edx
801026e1:	c1 ea 10             	shr    $0x10,%edx
801026e4:	80 fa 03             	cmp    $0x3,%dl
801026e7:	77 6f                	ja     80102758 <lapicinit+0xd8>
  lapic[index] = value;
801026e9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026f0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102700:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102703:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010270a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102710:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102717:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010271d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102724:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102727:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010272a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102731:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102734:	8b 50 20             	mov    0x20(%eax),%edx
80102737:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
80102738:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010273e:	80 e6 10             	and    $0x10,%dh
80102741:	75 f5                	jne    80102738 <lapicinit+0xb8>
  lapic[index] = value;
80102743:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010274a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010274d:	8b 40 20             	mov    0x20(%eax),%eax
}
80102750:	5d                   	pop    %ebp
80102751:	c3                   	ret    
80102752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102758:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010275f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102762:	8b 50 20             	mov    0x20(%eax),%edx
80102765:	eb 82                	jmp    801026e9 <lapicinit+0x69>
80102767:	89 f6                	mov    %esi,%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <lapicid>:
  if (!lapic)
80102770:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102775:	55                   	push   %ebp
80102776:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102778:	85 c0                	test   %eax,%eax
8010277a:	74 0c                	je     80102788 <lapicid+0x18>
  return lapic[ID] >> 24;
8010277c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010277f:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
80102780:	c1 e8 18             	shr    $0x18,%eax
}
80102783:	c3                   	ret    
80102784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102788:	31 c0                	xor    %eax,%eax
}
8010278a:	5d                   	pop    %ebp
8010278b:	c3                   	ret    
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <lapiceoi>:
  if(lapic)
80102790:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102795:	55                   	push   %ebp
80102796:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102798:	85 c0                	test   %eax,%eax
8010279a:	74 0d                	je     801027a9 <lapiceoi+0x19>
  lapic[index] = value;
8010279c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027a3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a6:	8b 40 20             	mov    0x20(%eax),%eax
}
801027a9:	5d                   	pop    %ebp
801027aa:	c3                   	ret    
801027ab:	90                   	nop
801027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027b0 <microdelay>:
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
}
801027b3:	5d                   	pop    %ebp
801027b4:	c3                   	ret    
801027b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <lapicstartap>:
{
801027c0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027c1:	ba 70 00 00 00       	mov    $0x70,%edx
801027c6:	89 e5                	mov    %esp,%ebp
801027c8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027cd:	53                   	push   %ebx
801027ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027d4:	ee                   	out    %al,(%dx)
801027d5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027da:	b2 71                	mov    $0x71,%dl
801027dc:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801027dd:	31 c0                	xor    %eax,%eax
801027df:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027e5:	89 d8                	mov    %ebx,%eax
801027e7:	c1 e8 04             	shr    $0x4,%eax
801027ea:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027f0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(ICRHI, apicid<<24);
801027f5:	c1 e1 18             	shl    $0x18,%ecx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027f8:	c1 eb 0c             	shr    $0xc,%ebx
  lapic[index] = value;
801027fb:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102801:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102804:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010280b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010280e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102811:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102818:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010281b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102827:	89 da                	mov    %ebx,%edx
80102829:	80 ce 06             	or     $0x6,%dh
  lapic[index] = value;
8010282c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102832:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102835:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 48 20             	mov    0x20(%eax),%ecx
  lapic[index] = value;
8010283e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102844:	8b 40 20             	mov    0x20(%eax),%eax
}
80102847:	5b                   	pop    %ebx
80102848:	5d                   	pop    %ebp
80102849:	c3                   	ret    
8010284a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102850 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102850:	55                   	push   %ebp
80102851:	ba 70 00 00 00       	mov    $0x70,%edx
80102856:	89 e5                	mov    %esp,%ebp
80102858:	b8 0b 00 00 00       	mov    $0xb,%eax
8010285d:	57                   	push   %edi
8010285e:	56                   	push   %esi
8010285f:	53                   	push   %ebx
80102860:	83 ec 4c             	sub    $0x4c,%esp
80102863:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102864:	b2 71                	mov    $0x71,%dl
80102866:	ec                   	in     (%dx),%al
80102867:	88 45 b7             	mov    %al,-0x49(%ebp)
8010286a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010286d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102871:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102878:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010287d:	89 d8                	mov    %ebx,%eax
8010287f:	e8 7c fd ff ff       	call   80102600 <fill_rtcdate>
80102884:	b8 0a 00 00 00       	mov    $0xa,%eax
80102889:	89 f2                	mov    %esi,%edx
8010288b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288c:	ba 71 00 00 00       	mov    $0x71,%edx
80102891:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102892:	84 c0                	test   %al,%al
80102894:	78 e7                	js     8010287d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102896:	89 f8                	mov    %edi,%eax
80102898:	e8 63 fd ff ff       	call   80102600 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010289d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801028a4:	00 
801028a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
801028a9:	89 1c 24             	mov    %ebx,(%esp)
801028ac:	e8 3f 1b 00 00       	call   801043f0 <memcmp>
801028b1:	85 c0                	test   %eax,%eax
801028b3:	75 c3                	jne    80102878 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801028b5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028b9:	75 78                	jne    80102933 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028bb:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028be:	89 c2                	mov    %eax,%edx
801028c0:	83 e0 0f             	and    $0xf,%eax
801028c3:	c1 ea 04             	shr    $0x4,%edx
801028c6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028c9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028cc:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028cf:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028d2:	89 c2                	mov    %eax,%edx
801028d4:	83 e0 0f             	and    $0xf,%eax
801028d7:	c1 ea 04             	shr    $0x4,%edx
801028da:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028dd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028e0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028e6:	89 c2                	mov    %eax,%edx
801028e8:	83 e0 0f             	and    $0xf,%eax
801028eb:	c1 ea 04             	shr    $0x4,%edx
801028ee:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028f4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801028f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028fa:	89 c2                	mov    %eax,%edx
801028fc:	83 e0 0f             	and    $0xf,%eax
801028ff:	c1 ea 04             	shr    $0x4,%edx
80102902:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102905:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102908:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010290b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010290e:	89 c2                	mov    %eax,%edx
80102910:	83 e0 0f             	and    $0xf,%eax
80102913:	c1 ea 04             	shr    $0x4,%edx
80102916:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102919:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010291c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010291f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102922:	89 c2                	mov    %eax,%edx
80102924:	83 e0 0f             	and    $0xf,%eax
80102927:	c1 ea 04             	shr    $0x4,%edx
8010292a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010292d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102930:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102933:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102936:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102939:	89 01                	mov    %eax,(%ecx)
8010293b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010293e:	89 41 04             	mov    %eax,0x4(%ecx)
80102941:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102944:	89 41 08             	mov    %eax,0x8(%ecx)
80102947:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010294a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010294d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102950:	89 41 10             	mov    %eax,0x10(%ecx)
80102953:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102956:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102959:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102960:	83 c4 4c             	add    $0x4c,%esp
80102963:	5b                   	pop    %ebx
80102964:	5e                   	pop    %esi
80102965:	5f                   	pop    %edi
80102966:	5d                   	pop    %ebp
80102967:	c3                   	ret    
80102968:	66 90                	xchg   %ax,%ax
8010296a:	66 90                	xchg   %ax,%ax
8010296c:	66 90                	xchg   %ax,%ax
8010296e:	66 90                	xchg   %ax,%ax

80102970 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102970:	55                   	push   %ebp
80102971:	89 e5                	mov    %esp,%ebp
80102973:	57                   	push   %edi
80102974:	56                   	push   %esi
80102975:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102976:	31 db                	xor    %ebx,%ebx
{
80102978:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010297b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102980:	85 c0                	test   %eax,%eax
80102982:	7e 78                	jle    801029fc <install_trans+0x8c>
80102984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102988:	a1 b4 26 11 80       	mov    0x801126b4,%eax
8010298d:	01 d8                	add    %ebx,%eax
8010298f:	83 c0 01             	add    $0x1,%eax
80102992:	89 44 24 04          	mov    %eax,0x4(%esp)
80102996:	a1 c4 26 11 80       	mov    0x801126c4,%eax
8010299b:	89 04 24             	mov    %eax,(%esp)
8010299e:	e8 2d d7 ff ff       	call   801000d0 <bread>
801029a3:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029a5:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
801029ac:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029af:	89 44 24 04          	mov    %eax,0x4(%esp)
801029b3:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029b8:	89 04 24             	mov    %eax,(%esp)
801029bb:	e8 10 d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029c0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029c7:	00 
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029c8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029ca:	8d 47 5c             	lea    0x5c(%edi),%eax
801029cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801029d1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029d4:	89 04 24             	mov    %eax,(%esp)
801029d7:	e8 64 1a 00 00       	call   80104440 <memmove>
    bwrite(dbuf);  // write dst to disk
801029dc:	89 34 24             	mov    %esi,(%esp)
801029df:	e8 bc d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029e4:	89 3c 24             	mov    %edi,(%esp)
801029e7:	e8 f4 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029ec:	89 34 24             	mov    %esi,(%esp)
801029ef:	e8 ec d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801029f4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
801029fa:	7f 8c                	jg     80102988 <install_trans+0x18>
  }
}
801029fc:	83 c4 1c             	add    $0x1c,%esp
801029ff:	5b                   	pop    %ebx
80102a00:	5e                   	pop    %esi
80102a01:	5f                   	pop    %edi
80102a02:	5d                   	pop    %ebp
80102a03:	c3                   	ret    
80102a04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
80102a13:	57                   	push   %edi
80102a14:	56                   	push   %esi
80102a15:	53                   	push   %ebx
80102a16:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a19:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a22:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a27:	89 04 24             	mov    %eax,(%esp)
80102a2a:	e8 a1 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a2f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a35:	31 d2                	xor    %edx,%edx
80102a37:	85 db                	test   %ebx,%ebx
  struct buf *buf = bread(log.dev, log.start);
80102a39:	89 c7                	mov    %eax,%edi
  hb->n = log.lh.n;
80102a3b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a3e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a41:	7e 17                	jle    80102a5a <write_head+0x4a>
80102a43:	90                   	nop
80102a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a48:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a4f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a53:	83 c2 01             	add    $0x1,%edx
80102a56:	39 da                	cmp    %ebx,%edx
80102a58:	75 ee                	jne    80102a48 <write_head+0x38>
  }
  bwrite(buf);
80102a5a:	89 3c 24             	mov    %edi,(%esp)
80102a5d:	e8 3e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a62:	89 3c 24             	mov    %edi,(%esp)
80102a65:	e8 76 d7 ff ff       	call   801001e0 <brelse>
}
80102a6a:	83 c4 1c             	add    $0x1c,%esp
80102a6d:	5b                   	pop    %ebx
80102a6e:	5e                   	pop    %esi
80102a6f:	5f                   	pop    %edi
80102a70:	5d                   	pop    %ebp
80102a71:	c3                   	ret    
80102a72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a80 <initlog>:
{
80102a80:	55                   	push   %ebp
80102a81:	89 e5                	mov    %esp,%ebp
80102a83:	56                   	push   %esi
80102a84:	53                   	push   %ebx
80102a85:	83 ec 30             	sub    $0x30,%esp
80102a88:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102a8b:	c7 44 24 04 c0 71 10 	movl   $0x801071c0,0x4(%esp)
80102a92:	80 
80102a93:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102a9a:	e8 d1 16 00 00       	call   80104170 <initlock>
  readsb(dev, &sb);
80102a9f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102aa6:	89 1c 24             	mov    %ebx,(%esp)
80102aa9:	e8 82 e9 ff ff       	call   80101430 <readsb>
  log.start = sb.logstart;
80102aae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102ab1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  struct buf *buf = bread(log.dev, log.start);
80102ab4:	89 1c 24             	mov    %ebx,(%esp)
  log.dev = dev;
80102ab7:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
80102abd:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.size = sb.nlog;
80102ac1:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102ac7:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102acc:	e8 ff d5 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ad1:	31 d2                	xor    %edx,%edx
  log.lh.n = lh->n;
80102ad3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ad6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ad9:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102adb:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ae1:	7e 17                	jle    80102afa <initlog+0x7a>
80102ae3:	90                   	nop
80102ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102ae8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102aec:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102af3:	83 c2 01             	add    $0x1,%edx
80102af6:	39 da                	cmp    %ebx,%edx
80102af8:	75 ee                	jne    80102ae8 <initlog+0x68>
  brelse(buf);
80102afa:	89 04 24             	mov    %eax,(%esp)
80102afd:	e8 de d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b02:	e8 69 fe ff ff       	call   80102970 <install_trans>
  log.lh.n = 0;
80102b07:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b0e:	00 00 00 
  write_head(); // clear the log
80102b11:	e8 fa fe ff ff       	call   80102a10 <write_head>
}
80102b16:	83 c4 30             	add    $0x30,%esp
80102b19:	5b                   	pop    %ebx
80102b1a:	5e                   	pop    %esi
80102b1b:	5d                   	pop    %ebp
80102b1c:	c3                   	ret    
80102b1d:	8d 76 00             	lea    0x0(%esi),%esi

80102b20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b26:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b2d:	e8 ae 17 00 00       	call   801042e0 <acquire>
80102b32:	eb 18                	jmp    80102b4c <begin_op+0x2c>
80102b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b38:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b3f:	80 
80102b40:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b47:	e8 74 11 00 00       	call   80103cc0 <sleep>
    if(log.committing){
80102b4c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b51:	85 c0                	test   %eax,%eax
80102b53:	75 e3                	jne    80102b38 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b55:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b5a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b60:	83 c0 01             	add    $0x1,%eax
80102b63:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b66:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b69:	83 fa 1e             	cmp    $0x1e,%edx
80102b6c:	7f ca                	jg     80102b38 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b6e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      log.outstanding += 1;
80102b75:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b7a:	e8 d1 17 00 00       	call   80104350 <release>
      break;
    }
  }
}
80102b7f:	c9                   	leave  
80102b80:	c3                   	ret    
80102b81:	eb 0d                	jmp    80102b90 <end_op>
80102b83:	90                   	nop
80102b84:	90                   	nop
80102b85:	90                   	nop
80102b86:	90                   	nop
80102b87:	90                   	nop
80102b88:	90                   	nop
80102b89:	90                   	nop
80102b8a:	90                   	nop
80102b8b:	90                   	nop
80102b8c:	90                   	nop
80102b8d:	90                   	nop
80102b8e:	90                   	nop
80102b8f:	90                   	nop

80102b90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	57                   	push   %edi
80102b94:	56                   	push   %esi
80102b95:	53                   	push   %ebx
80102b96:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102b99:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ba0:	e8 3b 17 00 00       	call   801042e0 <acquire>
  log.outstanding -= 1;
80102ba5:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102baa:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
  log.outstanding -= 1;
80102bb0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bb3:	85 d2                	test   %edx,%edx
  log.outstanding -= 1;
80102bb5:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102bba:	0f 85 f3 00 00 00    	jne    80102cb3 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102bc0:	85 c0                	test   %eax,%eax
80102bc2:	0f 85 cb 00 00 00    	jne    80102c93 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bc8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bcf:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
80102bd1:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102bd8:	00 00 00 
  release(&log.lock);
80102bdb:	e8 70 17 00 00       	call   80104350 <release>
  if (log.lh.n > 0) {
80102be0:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102be5:	85 c0                	test   %eax,%eax
80102be7:	0f 8e 90 00 00 00    	jle    80102c7d <end_op+0xed>
80102bed:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102bf0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bf5:	01 d8                	add    %ebx,%eax
80102bf7:	83 c0 01             	add    $0x1,%eax
80102bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bfe:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c03:	89 04 24             	mov    %eax,(%esp)
80102c06:	e8 c5 d4 ff ff       	call   801000d0 <bread>
80102c0b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c0d:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102c14:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c17:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c1b:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c20:	89 04 24             	mov    %eax,(%esp)
80102c23:	e8 a8 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c28:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c2f:	00 
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c30:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c32:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c35:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c39:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c3c:	89 04 24             	mov    %eax,(%esp)
80102c3f:	e8 fc 17 00 00       	call   80104440 <memmove>
    bwrite(to);  // write the log
80102c44:	89 34 24             	mov    %esi,(%esp)
80102c47:	e8 54 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c4c:	89 3c 24             	mov    %edi,(%esp)
80102c4f:	e8 8c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c54:	89 34 24             	mov    %esi,(%esp)
80102c57:	e8 84 d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c5c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c62:	7c 8c                	jl     80102bf0 <end_op+0x60>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c64:	e8 a7 fd ff ff       	call   80102a10 <write_head>
    install_trans(); // Now install writes to home locations
80102c69:	e8 02 fd ff ff       	call   80102970 <install_trans>
    log.lh.n = 0;
80102c6e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c75:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c78:	e8 93 fd ff ff       	call   80102a10 <write_head>
    acquire(&log.lock);
80102c7d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c84:	e8 57 16 00 00       	call   801042e0 <acquire>
    log.committing = 0;
80102c89:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102c90:	00 00 00 
    wakeup(&log);
80102c93:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c9a:	e8 c1 11 00 00       	call   80103e60 <wakeup>
    release(&log.lock);
80102c9f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ca6:	e8 a5 16 00 00       	call   80104350 <release>
}
80102cab:	83 c4 1c             	add    $0x1c,%esp
80102cae:	5b                   	pop    %ebx
80102caf:	5e                   	pop    %esi
80102cb0:	5f                   	pop    %edi
80102cb1:	5d                   	pop    %ebp
80102cb2:	c3                   	ret    
    panic("log.committing");
80102cb3:	c7 04 24 c4 71 10 80 	movl   $0x801071c4,(%esp)
80102cba:	e8 a1 d6 ff ff       	call   80100360 <panic>
80102cbf:	90                   	nop

80102cc0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cc7:	a1 c8 26 11 80       	mov    0x801126c8,%eax
{
80102ccc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ccf:	83 f8 1d             	cmp    $0x1d,%eax
80102cd2:	0f 8f 98 00 00 00    	jg     80102d70 <log_write+0xb0>
80102cd8:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102cde:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102ce1:	39 d0                	cmp    %edx,%eax
80102ce3:	0f 8d 87 00 00 00    	jge    80102d70 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ce9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cee:	85 c0                	test   %eax,%eax
80102cf0:	0f 8e 86 00 00 00    	jle    80102d7c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102cf6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cfd:	e8 de 15 00 00       	call   801042e0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d02:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d08:	83 fa 00             	cmp    $0x0,%edx
80102d0b:	7e 54                	jle    80102d61 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d0d:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102d10:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d12:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102d18:	75 0f                	jne    80102d29 <log_write+0x69>
80102d1a:	eb 3c                	jmp    80102d58 <log_write+0x98>
80102d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d20:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d27:	74 2f                	je     80102d58 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102d29:	83 c0 01             	add    $0x1,%eax
80102d2c:	39 d0                	cmp    %edx,%eax
80102d2e:	75 f0                	jne    80102d20 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102d30:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d37:	83 c2 01             	add    $0x1,%edx
80102d3a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d40:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d43:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d4a:	83 c4 14             	add    $0x14,%esp
80102d4d:	5b                   	pop    %ebx
80102d4e:	5d                   	pop    %ebp
  release(&log.lock);
80102d4f:	e9 fc 15 00 00       	jmp    80104350 <release>
80102d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80102d58:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d5f:	eb df                	jmp    80102d40 <log_write+0x80>
80102d61:	8b 43 08             	mov    0x8(%ebx),%eax
80102d64:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102d69:	75 d5                	jne    80102d40 <log_write+0x80>
80102d6b:	eb ca                	jmp    80102d37 <log_write+0x77>
80102d6d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("too big a transaction");
80102d70:	c7 04 24 d3 71 10 80 	movl   $0x801071d3,(%esp)
80102d77:	e8 e4 d5 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80102d7c:	c7 04 24 e9 71 10 80 	movl   $0x801071e9,(%esp)
80102d83:	e8 d8 d5 ff ff       	call   80100360 <panic>
80102d88:	66 90                	xchg   %ax,%ax
80102d8a:	66 90                	xchg   %ax,%ax
80102d8c:	66 90                	xchg   %ax,%ax
80102d8e:	66 90                	xchg   %ax,%ax

80102d90 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	53                   	push   %ebx
80102d94:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102d97:	e8 04 09 00 00       	call   801036a0 <cpuid>
80102d9c:	89 c3                	mov    %eax,%ebx
80102d9e:	e8 fd 08 00 00       	call   801036a0 <cpuid>
80102da3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102da7:	c7 04 24 04 72 10 80 	movl   $0x80107204,(%esp)
80102dae:	89 44 24 04          	mov    %eax,0x4(%esp)
80102db2:	e8 99 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102db7:	e8 04 28 00 00       	call   801055c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102dbc:	e8 5f 08 00 00       	call   80103620 <mycpu>
80102dc1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102dc3:	b8 01 00 00 00       	mov    $0x1,%eax
80102dc8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102dcf:	e8 bc 0b 00 00       	call   80103990 <scheduler>
80102dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102de0 <mpenter>:
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102de6:	e8 95 38 00 00       	call   80106680 <switchkvm>
  seginit();
80102deb:	e8 d0 37 00 00       	call   801065c0 <seginit>
  lapicinit();
80102df0:	e8 8b f8 ff ff       	call   80102680 <lapicinit>
  mpmain();
80102df5:	e8 96 ff ff ff       	call   80102d90 <mpmain>
80102dfa:	66 90                	xchg   %ax,%ax
80102dfc:	66 90                	xchg   %ax,%ax
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <main>:
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e04:	bb 80 27 11 80       	mov    $0x80112780,%ebx
{
80102e09:	83 e4 f0             	and    $0xfffffff0,%esp
80102e0c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e0f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e16:	80 
80102e17:	c7 04 24 a8 58 11 80 	movl   $0x801158a8,(%esp)
80102e1e:	e8 cd f5 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102e23:	e8 e8 3c 00 00       	call   80106b10 <kvmalloc>
  mpinit();        // detect other processors
80102e28:	e8 73 01 00 00       	call   80102fa0 <mpinit>
80102e2d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e30:	e8 4b f8 ff ff       	call   80102680 <lapicinit>
  seginit();       // segment descriptors
80102e35:	e8 86 37 00 00       	call   801065c0 <seginit>
  picinit();       // disable pic
80102e3a:	e8 21 03 00 00       	call   80103160 <picinit>
80102e3f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e40:	e8 cb f3 ff ff       	call   80102210 <ioapicinit>
  consoleinit();   // console hardware
80102e45:	e8 06 db ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e4a:	e8 91 2a 00 00       	call   801058e0 <uartinit>
80102e4f:	90                   	nop
  pinit();         // process table
80102e50:	e8 ab 07 00 00       	call   80103600 <pinit>
  tvinit();        // trap vectors
80102e55:	e8 c6 26 00 00       	call   80105520 <tvinit>
  binit();         // buffer cache
80102e5a:	e8 e1 d1 ff ff       	call   80100040 <binit>
80102e5f:	90                   	nop
  fileinit();      // file table
80102e60:	e8 fb de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102e65:	e8 a6 f1 ff ff       	call   80102010 <ideinit>
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e6a:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e71:	00 
80102e72:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e79:	80 
80102e7a:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e81:	e8 ba 15 00 00       	call   80104440 <memmove>
  for(c = cpus; c < cpus+ncpu; c++){
80102e86:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e8d:	00 00 00 
80102e90:	05 80 27 11 80       	add    $0x80112780,%eax
80102e95:	39 d8                	cmp    %ebx,%eax
80102e97:	76 6a                	jbe    80102f03 <main+0x103>
80102e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102ea0:	e8 7b 07 00 00       	call   80103620 <mycpu>
80102ea5:	39 d8                	cmp    %ebx,%eax
80102ea7:	74 41                	je     80102eea <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ea9:	e8 02 f6 ff ff       	call   801024b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
80102eae:	c7 05 f8 6f 00 80 e0 	movl   $0x80102de0,0x80006ff8
80102eb5:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102eb8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102ebf:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ec2:	05 00 10 00 00       	add    $0x1000,%eax
80102ec7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102ecc:	0f b6 03             	movzbl (%ebx),%eax
80102ecf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102ed6:	00 
80102ed7:	89 04 24             	mov    %eax,(%esp)
80102eda:	e8 e1 f8 ff ff       	call   801027c0 <lapicstartap>
80102edf:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ee0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ee6:	85 c0                	test   %eax,%eax
80102ee8:	74 f6                	je     80102ee0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102eea:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ef1:	00 00 00 
80102ef4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102efa:	05 80 27 11 80       	add    $0x80112780,%eax
80102eff:	39 c3                	cmp    %eax,%ebx
80102f01:	72 9d                	jb     80102ea0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f03:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f0a:	8e 
80102f0b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f12:	e8 49 f5 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102f17:	e8 d4 07 00 00       	call   801036f0 <userinit>
  mpmain();        // finish this processor's setup
80102f1c:	e8 6f fe ff ff       	call   80102d90 <mpmain>
80102f21:	66 90                	xchg   %ax,%ax
80102f23:	66 90                	xchg   %ax,%ax
80102f25:	66 90                	xchg   %ax,%ax
80102f27:	66 90                	xchg   %ax,%ax
80102f29:	66 90                	xchg   %ax,%ax
80102f2b:	66 90                	xchg   %ax,%ax
80102f2d:	66 90                	xchg   %ax,%ax
80102f2f:	90                   	nop

80102f30 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f30:	55                   	push   %ebp
80102f31:	89 e5                	mov    %esp,%ebp
80102f33:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f34:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102f3a:	53                   	push   %ebx
  e = addr+len;
80102f3b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102f3e:	83 ec 10             	sub    $0x10,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102f41:	39 de                	cmp    %ebx,%esi
80102f43:	73 3c                	jae    80102f81 <mpsearch1+0x51>
80102f45:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f48:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f4f:	00 
80102f50:	c7 44 24 04 18 72 10 	movl   $0x80107218,0x4(%esp)
80102f57:	80 
80102f58:	89 34 24             	mov    %esi,(%esp)
80102f5b:	e8 90 14 00 00       	call   801043f0 <memcmp>
80102f60:	85 c0                	test   %eax,%eax
80102f62:	75 16                	jne    80102f7a <mpsearch1+0x4a>
80102f64:	31 c9                	xor    %ecx,%ecx
80102f66:	31 d2                	xor    %edx,%edx
    sum += addr[i];
80102f68:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
  for(i=0; i<len; i++)
80102f6c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f6f:	01 c1                	add    %eax,%ecx
  for(i=0; i<len; i++)
80102f71:	83 fa 10             	cmp    $0x10,%edx
80102f74:	75 f2                	jne    80102f68 <mpsearch1+0x38>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f76:	84 c9                	test   %cl,%cl
80102f78:	74 10                	je     80102f8a <mpsearch1+0x5a>
  for(p = addr; p < e; p += sizeof(struct mp))
80102f7a:	83 c6 10             	add    $0x10,%esi
80102f7d:	39 f3                	cmp    %esi,%ebx
80102f7f:	77 c7                	ja     80102f48 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
80102f81:	83 c4 10             	add    $0x10,%esp
  return 0;
80102f84:	31 c0                	xor    %eax,%eax
}
80102f86:	5b                   	pop    %ebx
80102f87:	5e                   	pop    %esi
80102f88:	5d                   	pop    %ebp
80102f89:	c3                   	ret    
80102f8a:	83 c4 10             	add    $0x10,%esp
80102f8d:	89 f0                	mov    %esi,%eax
80102f8f:	5b                   	pop    %ebx
80102f90:	5e                   	pop    %esi
80102f91:	5d                   	pop    %ebp
80102f92:	c3                   	ret    
80102f93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fa0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	57                   	push   %edi
80102fa4:	56                   	push   %esi
80102fa5:	53                   	push   %ebx
80102fa6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102fa9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fb0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fb7:	c1 e0 08             	shl    $0x8,%eax
80102fba:	09 d0                	or     %edx,%eax
80102fbc:	c1 e0 04             	shl    $0x4,%eax
80102fbf:	85 c0                	test   %eax,%eax
80102fc1:	75 1b                	jne    80102fde <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102fc3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102fca:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102fd1:	c1 e0 08             	shl    $0x8,%eax
80102fd4:	09 d0                	or     %edx,%eax
80102fd6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102fd9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80102fde:	ba 00 04 00 00       	mov    $0x400,%edx
80102fe3:	e8 48 ff ff ff       	call   80102f30 <mpsearch1>
80102fe8:	85 c0                	test   %eax,%eax
80102fea:	89 c7                	mov    %eax,%edi
80102fec:	0f 84 22 01 00 00    	je     80103114 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102ff2:	8b 77 04             	mov    0x4(%edi),%esi
80102ff5:	85 f6                	test   %esi,%esi
80102ff7:	0f 84 30 01 00 00    	je     8010312d <mpinit+0x18d>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102ffd:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103003:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010300a:	00 
8010300b:	c7 44 24 04 1d 72 10 	movl   $0x8010721d,0x4(%esp)
80103012:	80 
80103013:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103016:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103019:	e8 d2 13 00 00       	call   801043f0 <memcmp>
8010301e:	85 c0                	test   %eax,%eax
80103020:	0f 85 07 01 00 00    	jne    8010312d <mpinit+0x18d>
  if(conf->version != 1 && conf->version != 4)
80103026:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010302d:	3c 04                	cmp    $0x4,%al
8010302f:	0f 85 0b 01 00 00    	jne    80103140 <mpinit+0x1a0>
  if(sum((uchar*)conf, conf->length) != 0)
80103035:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
  for(i=0; i<len; i++)
8010303c:	85 c0                	test   %eax,%eax
8010303e:	74 21                	je     80103061 <mpinit+0xc1>
  sum = 0;
80103040:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103042:	31 d2                	xor    %edx,%edx
80103044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103048:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010304f:	80 
  for(i=0; i<len; i++)
80103050:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103053:	01 d9                	add    %ebx,%ecx
  for(i=0; i<len; i++)
80103055:	39 d0                	cmp    %edx,%eax
80103057:	7f ef                	jg     80103048 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103059:	84 c9                	test   %cl,%cl
8010305b:	0f 85 cc 00 00 00    	jne    8010312d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103064:	85 c0                	test   %eax,%eax
80103066:	0f 84 c1 00 00 00    	je     8010312d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010306c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  ismp = 1;
80103072:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103077:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010307c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103083:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103089:	03 55 e4             	add    -0x1c(%ebp),%edx
8010308c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103090:	39 c2                	cmp    %eax,%edx
80103092:	76 1b                	jbe    801030af <mpinit+0x10f>
80103094:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
80103097:	80 f9 04             	cmp    $0x4,%cl
8010309a:	77 74                	ja     80103110 <mpinit+0x170>
8010309c:	ff 24 8d 5c 72 10 80 	jmp    *-0x7fef8da4(,%ecx,4)
801030a3:	90                   	nop
801030a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801030a8:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030ab:	39 c2                	cmp    %eax,%edx
801030ad:	77 e5                	ja     80103094 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801030af:	85 db                	test   %ebx,%ebx
801030b1:	0f 84 93 00 00 00    	je     8010314a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030b7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030bb:	74 12                	je     801030cf <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030bd:	ba 22 00 00 00       	mov    $0x22,%edx
801030c2:	b8 70 00 00 00       	mov    $0x70,%eax
801030c7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030c8:	b2 23                	mov    $0x23,%dl
801030ca:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030cb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ce:	ee                   	out    %al,(%dx)
  }
}
801030cf:	83 c4 1c             	add    $0x1c,%esp
801030d2:	5b                   	pop    %ebx
801030d3:	5e                   	pop    %esi
801030d4:	5f                   	pop    %edi
801030d5:	5d                   	pop    %ebp
801030d6:	c3                   	ret    
801030d7:	90                   	nop
      if(ncpu < NCPU) {
801030d8:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801030de:	83 fe 07             	cmp    $0x7,%esi
801030e1:	7f 17                	jg     801030fa <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030e3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030e7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
801030ed:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030f4:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
      p += sizeof(struct mpproc);
801030fa:	83 c0 14             	add    $0x14,%eax
      continue;
801030fd:	eb 91                	jmp    80103090 <mpinit+0xf0>
801030ff:	90                   	nop
      ioapicid = ioapic->apicno;
80103100:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103104:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103107:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
8010310d:	eb 81                	jmp    80103090 <mpinit+0xf0>
8010310f:	90                   	nop
      ismp = 0;
80103110:	31 db                	xor    %ebx,%ebx
80103112:	eb 83                	jmp    80103097 <mpinit+0xf7>
  return mpsearch1(0xF0000, 0x10000);
80103114:	ba 00 00 01 00       	mov    $0x10000,%edx
80103119:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010311e:	e8 0d fe ff ff       	call   80102f30 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103123:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103125:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103127:	0f 85 c5 fe ff ff    	jne    80102ff2 <mpinit+0x52>
    panic("Expect to run on an SMP");
8010312d:	c7 04 24 22 72 10 80 	movl   $0x80107222,(%esp)
80103134:	e8 27 d2 ff ff       	call   80100360 <panic>
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(conf->version != 1 && conf->version != 4)
80103140:	3c 01                	cmp    $0x1,%al
80103142:	0f 84 ed fe ff ff    	je     80103035 <mpinit+0x95>
80103148:	eb e3                	jmp    8010312d <mpinit+0x18d>
    panic("Didn't find a suitable machine");
8010314a:	c7 04 24 3c 72 10 80 	movl   $0x8010723c,(%esp)
80103151:	e8 0a d2 ff ff       	call   80100360 <panic>
80103156:	66 90                	xchg   %ax,%ax
80103158:	66 90                	xchg   %ax,%ax
8010315a:	66 90                	xchg   %ax,%ax
8010315c:	66 90                	xchg   %ax,%ax
8010315e:	66 90                	xchg   %ax,%ax

80103160 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103160:	55                   	push   %ebp
80103161:	ba 21 00 00 00       	mov    $0x21,%edx
80103166:	89 e5                	mov    %esp,%ebp
80103168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010316d:	ee                   	out    %al,(%dx)
8010316e:	b2 a1                	mov    $0xa1,%dl
80103170:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103171:	5d                   	pop    %ebp
80103172:	c3                   	ret    
80103173:	66 90                	xchg   %ax,%ax
80103175:	66 90                	xchg   %ax,%ax
80103177:	66 90                	xchg   %ax,%ax
80103179:	66 90                	xchg   %ax,%ax
8010317b:	66 90                	xchg   %ax,%ax
8010317d:	66 90                	xchg   %ax,%ax
8010317f:	90                   	nop

80103180 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
80103185:	53                   	push   %ebx
80103186:	83 ec 1c             	sub    $0x1c,%esp
80103189:	8b 75 08             	mov    0x8(%ebp),%esi
8010318c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010318f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103195:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010319b:	e8 e0 db ff ff       	call   80100d80 <filealloc>
801031a0:	85 c0                	test   %eax,%eax
801031a2:	89 06                	mov    %eax,(%esi)
801031a4:	0f 84 a4 00 00 00    	je     8010324e <pipealloc+0xce>
801031aa:	e8 d1 db ff ff       	call   80100d80 <filealloc>
801031af:	85 c0                	test   %eax,%eax
801031b1:	89 03                	mov    %eax,(%ebx)
801031b3:	0f 84 87 00 00 00    	je     80103240 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031b9:	e8 f2 f2 ff ff       	call   801024b0 <kalloc>
801031be:	85 c0                	test   %eax,%eax
801031c0:	89 c7                	mov    %eax,%edi
801031c2:	74 7c                	je     80103240 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031c4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031cb:	00 00 00 
  p->writeopen = 1;
801031ce:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031d5:	00 00 00 
  p->nwrite = 0;
801031d8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031df:	00 00 00 
  p->nread = 0;
801031e2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031e9:	00 00 00 
  initlock(&p->lock, "pipe");
801031ec:	89 04 24             	mov    %eax,(%esp)
801031ef:	c7 44 24 04 70 72 10 	movl   $0x80107270,0x4(%esp)
801031f6:	80 
801031f7:	e8 74 0f 00 00       	call   80104170 <initlock>
  (*f0)->type = FD_PIPE;
801031fc:	8b 06                	mov    (%esi),%eax
801031fe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103204:	8b 06                	mov    (%esi),%eax
80103206:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010320a:	8b 06                	mov    (%esi),%eax
8010320c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103210:	8b 06                	mov    (%esi),%eax
80103212:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103215:	8b 03                	mov    (%ebx),%eax
80103217:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010321d:	8b 03                	mov    (%ebx),%eax
8010321f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103223:	8b 03                	mov    (%ebx),%eax
80103225:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103229:	8b 03                	mov    (%ebx),%eax
  return 0;
8010322b:	31 db                	xor    %ebx,%ebx
  (*f1)->pipe = p;
8010322d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103230:	83 c4 1c             	add    $0x1c,%esp
80103233:	89 d8                	mov    %ebx,%eax
80103235:	5b                   	pop    %ebx
80103236:	5e                   	pop    %esi
80103237:	5f                   	pop    %edi
80103238:	5d                   	pop    %ebp
80103239:	c3                   	ret    
8010323a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*f0)
80103240:	8b 06                	mov    (%esi),%eax
80103242:	85 c0                	test   %eax,%eax
80103244:	74 08                	je     8010324e <pipealloc+0xce>
    fileclose(*f0);
80103246:	89 04 24             	mov    %eax,(%esp)
80103249:	e8 f2 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
8010324e:	8b 03                	mov    (%ebx),%eax
  return -1;
80103250:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(*f1)
80103255:	85 c0                	test   %eax,%eax
80103257:	74 d7                	je     80103230 <pipealloc+0xb0>
    fileclose(*f1);
80103259:	89 04 24             	mov    %eax,(%esp)
8010325c:	e8 df db ff ff       	call   80100e40 <fileclose>
}
80103261:	83 c4 1c             	add    $0x1c,%esp
80103264:	89 d8                	mov    %ebx,%eax
80103266:	5b                   	pop    %ebx
80103267:	5e                   	pop    %esi
80103268:	5f                   	pop    %edi
80103269:	5d                   	pop    %ebp
8010326a:	c3                   	ret    
8010326b:	90                   	nop
8010326c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103270 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	56                   	push   %esi
80103274:	53                   	push   %ebx
80103275:	83 ec 10             	sub    $0x10,%esp
80103278:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010327b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010327e:	89 1c 24             	mov    %ebx,(%esp)
80103281:	e8 5a 10 00 00       	call   801042e0 <acquire>
  if(writable){
80103286:	85 f6                	test   %esi,%esi
80103288:	74 3e                	je     801032c8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010328a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103290:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103297:	00 00 00 
    wakeup(&p->nread);
8010329a:	89 04 24             	mov    %eax,(%esp)
8010329d:	e8 be 0b 00 00       	call   80103e60 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801032a2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801032a8:	85 d2                	test   %edx,%edx
801032aa:	75 0a                	jne    801032b6 <pipeclose+0x46>
801032ac:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 32                	je     801032e8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032b9:	83 c4 10             	add    $0x10,%esp
801032bc:	5b                   	pop    %ebx
801032bd:	5e                   	pop    %esi
801032be:	5d                   	pop    %ebp
    release(&p->lock);
801032bf:	e9 8c 10 00 00       	jmp    80104350 <release>
801032c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801032c8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801032ce:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032d5:	00 00 00 
    wakeup(&p->nwrite);
801032d8:	89 04 24             	mov    %eax,(%esp)
801032db:	e8 80 0b 00 00       	call   80103e60 <wakeup>
801032e0:	eb c0                	jmp    801032a2 <pipeclose+0x32>
801032e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&p->lock);
801032e8:	89 1c 24             	mov    %ebx,(%esp)
801032eb:	e8 60 10 00 00       	call   80104350 <release>
    kfree((char*)p);
801032f0:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032f3:	83 c4 10             	add    $0x10,%esp
801032f6:	5b                   	pop    %ebx
801032f7:	5e                   	pop    %esi
801032f8:	5d                   	pop    %ebp
    kfree((char*)p);
801032f9:	e9 02 f0 ff ff       	jmp    80102300 <kfree>
801032fe:	66 90                	xchg   %ax,%ax

80103300 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	57                   	push   %edi
80103304:	56                   	push   %esi
80103305:	53                   	push   %ebx
80103306:	83 ec 1c             	sub    $0x1c,%esp
80103309:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010330c:	89 1c 24             	mov    %ebx,(%esp)
8010330f:	e8 cc 0f 00 00       	call   801042e0 <acquire>
  for(i = 0; i < n; i++){
80103314:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103317:	85 c9                	test   %ecx,%ecx
80103319:	0f 8e b2 00 00 00    	jle    801033d1 <pipewrite+0xd1>
8010331f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103322:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103328:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010332e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103334:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103337:	03 4d 10             	add    0x10(%ebp),%ecx
8010333a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010333d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103343:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103349:	39 c8                	cmp    %ecx,%eax
8010334b:	74 38                	je     80103385 <pipewrite+0x85>
8010334d:	eb 55                	jmp    801033a4 <pipewrite+0xa4>
8010334f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103350:	e8 6b 03 00 00       	call   801036c0 <myproc>
80103355:	8b 40 24             	mov    0x24(%eax),%eax
80103358:	85 c0                	test   %eax,%eax
8010335a:	75 33                	jne    8010338f <pipewrite+0x8f>
      wakeup(&p->nread);
8010335c:	89 3c 24             	mov    %edi,(%esp)
8010335f:	e8 fc 0a 00 00       	call   80103e60 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103364:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103368:	89 34 24             	mov    %esi,(%esp)
8010336b:	e8 50 09 00 00       	call   80103cc0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103370:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103376:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010337c:	05 00 02 00 00       	add    $0x200,%eax
80103381:	39 c2                	cmp    %eax,%edx
80103383:	75 23                	jne    801033a8 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103385:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010338b:	85 d2                	test   %edx,%edx
8010338d:	75 c1                	jne    80103350 <pipewrite+0x50>
        release(&p->lock);
8010338f:	89 1c 24             	mov    %ebx,(%esp)
80103392:	e8 b9 0f 00 00       	call   80104350 <release>
        return -1;
80103397:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010339c:	83 c4 1c             	add    $0x1c,%esp
8010339f:	5b                   	pop    %ebx
801033a0:	5e                   	pop    %esi
801033a1:	5f                   	pop    %edi
801033a2:	5d                   	pop    %ebp
801033a3:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033a4:	89 c2                	mov    %eax,%edx
801033a6:	66 90                	xchg   %ax,%ax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801033a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033ab:	8d 42 01             	lea    0x1(%edx),%eax
801033ae:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033b4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033ba:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033be:	0f b6 09             	movzbl (%ecx),%ecx
801033c1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801033c5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033c8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033cb:	0f 85 6c ff ff ff    	jne    8010333d <pipewrite+0x3d>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033d1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033d7:	89 04 24             	mov    %eax,(%esp)
801033da:	e8 81 0a 00 00       	call   80103e60 <wakeup>
  release(&p->lock);
801033df:	89 1c 24             	mov    %ebx,(%esp)
801033e2:	e8 69 0f 00 00       	call   80104350 <release>
  return n;
801033e7:	8b 45 10             	mov    0x10(%ebp),%eax
801033ea:	eb b0                	jmp    8010339c <pipewrite+0x9c>
801033ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 1c             	sub    $0x1c,%esp
801033f9:	8b 75 08             	mov    0x8(%ebp),%esi
801033fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801033ff:	89 34 24             	mov    %esi,(%esp)
80103402:	e8 d9 0e 00 00       	call   801042e0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103407:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010340d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103413:	75 5b                	jne    80103470 <piperead+0x80>
80103415:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010341b:	85 db                	test   %ebx,%ebx
8010341d:	74 51                	je     80103470 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010341f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103425:	eb 25                	jmp    8010344c <piperead+0x5c>
80103427:	90                   	nop
80103428:	89 74 24 04          	mov    %esi,0x4(%esp)
8010342c:	89 1c 24             	mov    %ebx,(%esp)
8010342f:	e8 8c 08 00 00       	call   80103cc0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103434:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010343a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103440:	75 2e                	jne    80103470 <piperead+0x80>
80103442:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103448:	85 d2                	test   %edx,%edx
8010344a:	74 24                	je     80103470 <piperead+0x80>
    if(myproc()->killed){
8010344c:	e8 6f 02 00 00       	call   801036c0 <myproc>
80103451:	8b 48 24             	mov    0x24(%eax),%ecx
80103454:	85 c9                	test   %ecx,%ecx
80103456:	74 d0                	je     80103428 <piperead+0x38>
      release(&p->lock);
80103458:	89 34 24             	mov    %esi,(%esp)
8010345b:	e8 f0 0e 00 00       	call   80104350 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103460:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80103463:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103468:	5b                   	pop    %ebx
80103469:	5e                   	pop    %esi
8010346a:	5f                   	pop    %edi
8010346b:	5d                   	pop    %ebp
8010346c:	c3                   	ret    
8010346d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103470:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103473:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103475:	85 d2                	test   %edx,%edx
80103477:	7f 2b                	jg     801034a4 <piperead+0xb4>
80103479:	eb 31                	jmp    801034ac <piperead+0xbc>
8010347b:	90                   	nop
8010347c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103480:	8d 48 01             	lea    0x1(%eax),%ecx
80103483:	25 ff 01 00 00       	and    $0x1ff,%eax
80103488:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010348e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103493:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103496:	83 c3 01             	add    $0x1,%ebx
80103499:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010349c:	74 0e                	je     801034ac <piperead+0xbc>
    if(p->nread == p->nwrite)
8010349e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034a4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034aa:	75 d4                	jne    80103480 <piperead+0x90>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801034ac:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034b2:	89 04 24             	mov    %eax,(%esp)
801034b5:	e8 a6 09 00 00       	call   80103e60 <wakeup>
  release(&p->lock);
801034ba:	89 34 24             	mov    %esi,(%esp)
801034bd:	e8 8e 0e 00 00       	call   80104350 <release>
}
801034c2:	83 c4 1c             	add    $0x1c,%esp
  return i;
801034c5:	89 d8                	mov    %ebx,%eax
}
801034c7:	5b                   	pop    %ebx
801034c8:	5e                   	pop    %esi
801034c9:	5f                   	pop    %edi
801034ca:	5d                   	pop    %ebp
801034cb:	c3                   	ret    
801034cc:	66 90                	xchg   %ax,%ax
801034ce:	66 90                	xchg   %ax,%ax

801034d0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034d4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801034d9:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801034dc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034e3:	e8 f8 0d 00 00       	call   801042e0 <acquire>
801034e8:	eb 18                	jmp    80103502 <allocproc+0x32>
801034ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034f0:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
801034f6:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
801034fc:	0f 84 8e 00 00 00    	je     80103590 <allocproc+0xc0>
    if(p->state == UNUSED)
80103502:	8b 43 0c             	mov    0xc(%ebx),%eax
80103505:	85 c0                	test   %eax,%eax
80103507:	75 e7                	jne    801034f0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103509:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->prior_val = 10;    // Kevin Prada - Initializing Priority Value to 31
                        // Range for priority is [0, 31]. 31 is lowest priority
  p->T_burst = 0;     // KP

  release(&ptable.lock);
8010350e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  p->state = EMBRYO;
80103515:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->prior_val = 10;    // Kevin Prada - Initializing Priority Value to 31
8010351c:	c7 43 7c 0a 00 00 00 	movl   $0xa,0x7c(%ebx)
  p->pid = nextpid++;
80103523:	8d 50 01             	lea    0x1(%eax),%edx
80103526:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010352c:	89 43 10             	mov    %eax,0x10(%ebx)
  p->T_burst = 0;     // KP
8010352f:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103536:	00 00 00 
  release(&ptable.lock);
80103539:	e8 12 0e 00 00       	call   80104350 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010353e:	e8 6d ef ff ff       	call   801024b0 <kalloc>
80103543:	85 c0                	test   %eax,%eax
80103545:	89 43 08             	mov    %eax,0x8(%ebx)
80103548:	74 5a                	je     801035a4 <allocproc+0xd4>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010354a:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103550:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103555:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103558:	c7 40 14 0f 55 10 80 	movl   $0x8010550f,0x14(%eax)
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010355f:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80103566:	00 
80103567:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010356e:	00 
8010356f:	89 04 24             	mov    %eax,(%esp)
  p->context = (struct context*)sp;
80103572:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103575:	e8 26 0e 00 00       	call   801043a0 <memset>
  p->context->eip = (uint)forkret;
8010357a:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010357d:	c7 40 10 b0 35 10 80 	movl   $0x801035b0,0x10(%eax)

  return p;
80103584:	89 d8                	mov    %ebx,%eax
}
80103586:	83 c4 14             	add    $0x14,%esp
80103589:	5b                   	pop    %ebx
8010358a:	5d                   	pop    %ebp
8010358b:	c3                   	ret    
8010358c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103590:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103597:	e8 b4 0d 00 00       	call   80104350 <release>
}
8010359c:	83 c4 14             	add    $0x14,%esp
  return 0;
8010359f:	31 c0                	xor    %eax,%eax
}
801035a1:	5b                   	pop    %ebx
801035a2:	5d                   	pop    %ebp
801035a3:	c3                   	ret    
    p->state = UNUSED;
801035a4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801035ab:	eb d9                	jmp    80103586 <allocproc+0xb6>
801035ad:	8d 76 00             	lea    0x0(%esi),%esi

801035b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035b6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035bd:	e8 8e 0d 00 00       	call   80104350 <release>

  if (first) {
801035c2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801035c7:	85 c0                	test   %eax,%eax
801035c9:	75 05                	jne    801035d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035cb:	c9                   	leave  
801035cc:	c3                   	ret    
801035cd:	8d 76 00             	lea    0x0(%esi),%esi
    iinit(ROOTDEV);
801035d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
801035d7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035de:	00 00 00 
    iinit(ROOTDEV);
801035e1:	e8 9a de ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
801035e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035ed:	e8 8e f4 ff ff       	call   80102a80 <initlog>
}
801035f2:	c9                   	leave  
801035f3:	c3                   	ret    
801035f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103600 <pinit>:
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103606:	c7 44 24 04 75 72 10 	movl   $0x80107275,0x4(%esp)
8010360d:	80 
8010360e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103615:	e8 56 0b 00 00       	call   80104170 <initlock>
}
8010361a:	c9                   	leave  
8010361b:	c3                   	ret    
8010361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103620 <mycpu>:
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	56                   	push   %esi
80103624:	53                   	push   %ebx
80103625:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103628:	9c                   	pushf  
80103629:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010362a:	f6 c4 02             	test   $0x2,%ah
8010362d:	75 57                	jne    80103686 <mycpu+0x66>
  apicid = lapicid();
8010362f:	e8 3c f1 ff ff       	call   80102770 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103634:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010363a:	85 f6                	test   %esi,%esi
8010363c:	7e 3c                	jle    8010367a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010363e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103645:	39 c2                	cmp    %eax,%edx
80103647:	74 2d                	je     80103676 <mycpu+0x56>
80103649:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010364e:	31 d2                	xor    %edx,%edx
80103650:	83 c2 01             	add    $0x1,%edx
80103653:	39 f2                	cmp    %esi,%edx
80103655:	74 23                	je     8010367a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103657:	0f b6 19             	movzbl (%ecx),%ebx
8010365a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103660:	39 c3                	cmp    %eax,%ebx
80103662:	75 ec                	jne    80103650 <mycpu+0x30>
      return &cpus[i];
80103664:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
}
8010366a:	83 c4 10             	add    $0x10,%esp
8010366d:	5b                   	pop    %ebx
8010366e:	5e                   	pop    %esi
8010366f:	5d                   	pop    %ebp
      return &cpus[i];
80103670:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103675:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
80103676:	31 d2                	xor    %edx,%edx
80103678:	eb ea                	jmp    80103664 <mycpu+0x44>
  panic("unknown apicid\n");
8010367a:	c7 04 24 7c 72 10 80 	movl   $0x8010727c,(%esp)
80103681:	e8 da cc ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
80103686:	c7 04 24 80 73 10 80 	movl   $0x80107380,(%esp)
8010368d:	e8 ce cc ff ff       	call   80100360 <panic>
80103692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036a0 <cpuid>:
cpuid() {
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801036a6:	e8 75 ff ff ff       	call   80103620 <mycpu>
}
801036ab:	c9                   	leave  
  return mycpu()-cpus;
801036ac:	2d 80 27 11 80       	sub    $0x80112780,%eax
801036b1:	c1 f8 04             	sar    $0x4,%eax
801036b4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036ba:	c3                   	ret    
801036bb:	90                   	nop
801036bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036c0 <myproc>:
myproc(void) {
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	53                   	push   %ebx
801036c4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801036c7:	e8 24 0b 00 00       	call   801041f0 <pushcli>
  c = mycpu();
801036cc:	e8 4f ff ff ff       	call   80103620 <mycpu>
  p = c->proc;
801036d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036d7:	e8 54 0b 00 00       	call   80104230 <popcli>
}
801036dc:	83 c4 04             	add    $0x4,%esp
801036df:	89 d8                	mov    %ebx,%eax
801036e1:	5b                   	pop    %ebx
801036e2:	5d                   	pop    %ebp
801036e3:	c3                   	ret    
801036e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036f0 <userinit>:
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	53                   	push   %ebx
801036f4:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
801036f7:	e8 d4 fd ff ff       	call   801034d0 <allocproc>
801036fc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801036fe:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103703:	e8 78 33 00 00       	call   80106a80 <setupkvm>
80103708:	85 c0                	test   %eax,%eax
8010370a:	89 43 04             	mov    %eax,0x4(%ebx)
8010370d:	0f 84 d4 00 00 00    	je     801037e7 <userinit+0xf7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103713:	89 04 24             	mov    %eax,(%esp)
80103716:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010371d:	00 
8010371e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103725:	80 
80103726:	e8 85 30 00 00       	call   801067b0 <inituvm>
  p->sz = PGSIZE;
8010372b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103731:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103738:	00 
80103739:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103740:	00 
80103741:	8b 43 18             	mov    0x18(%ebx),%eax
80103744:	89 04 24             	mov    %eax,(%esp)
80103747:	e8 54 0c 00 00       	call   801043a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010374c:	8b 43 18             	mov    0x18(%ebx),%eax
8010374f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103754:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103759:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010375d:	8b 43 18             	mov    0x18(%ebx),%eax
80103760:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103764:	8b 43 18             	mov    0x18(%ebx),%eax
80103767:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010376b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010376f:	8b 43 18             	mov    0x18(%ebx),%eax
80103772:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103776:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010377a:	8b 43 18             	mov    0x18(%ebx),%eax
8010377d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103784:	8b 43 18             	mov    0x18(%ebx),%eax
80103787:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010378e:	8b 43 18             	mov    0x18(%ebx),%eax
80103791:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103798:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010379b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801037a2:	00 
801037a3:	c7 44 24 04 a5 72 10 	movl   $0x801072a5,0x4(%esp)
801037aa:	80 
801037ab:	89 04 24             	mov    %eax,(%esp)
801037ae:	e8 cd 0d 00 00       	call   80104580 <safestrcpy>
  p->cwd = namei("/");
801037b3:	c7 04 24 ae 72 10 80 	movl   $0x801072ae,(%esp)
801037ba:	e8 51 e7 ff ff       	call   80101f10 <namei>
801037bf:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801037c2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037c9:	e8 12 0b 00 00       	call   801042e0 <acquire>
  p->state = RUNNABLE;
801037ce:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801037d5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037dc:	e8 6f 0b 00 00       	call   80104350 <release>
}
801037e1:	83 c4 14             	add    $0x14,%esp
801037e4:	5b                   	pop    %ebx
801037e5:	5d                   	pop    %ebp
801037e6:	c3                   	ret    
    panic("userinit: out of memory?");
801037e7:	c7 04 24 8c 72 10 80 	movl   $0x8010728c,(%esp)
801037ee:	e8 6d cb ff ff       	call   80100360 <panic>
801037f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103800 <growproc>:
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	56                   	push   %esi
80103804:	53                   	push   %ebx
80103805:	83 ec 10             	sub    $0x10,%esp
80103808:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010380b:	e8 b0 fe ff ff       	call   801036c0 <myproc>
  if(n > 0){
80103810:	83 fe 00             	cmp    $0x0,%esi
  struct proc *curproc = myproc();
80103813:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103815:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103817:	7e 2f                	jle    80103848 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103819:	01 c6                	add    %eax,%esi
8010381b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010381f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103823:	8b 43 04             	mov    0x4(%ebx),%eax
80103826:	89 04 24             	mov    %eax,(%esp)
80103829:	e8 c2 30 00 00       	call   801068f0 <allocuvm>
8010382e:	85 c0                	test   %eax,%eax
80103830:	74 36                	je     80103868 <growproc+0x68>
  curproc->sz = sz;
80103832:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103834:	89 1c 24             	mov    %ebx,(%esp)
80103837:	e8 64 2e 00 00       	call   801066a0 <switchuvm>
  return 0;
8010383c:	31 c0                	xor    %eax,%eax
}
8010383e:	83 c4 10             	add    $0x10,%esp
80103841:	5b                   	pop    %ebx
80103842:	5e                   	pop    %esi
80103843:	5d                   	pop    %ebp
80103844:	c3                   	ret    
80103845:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(n < 0){
80103848:	74 e8                	je     80103832 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010384a:	01 c6                	add    %eax,%esi
8010384c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103850:	89 44 24 04          	mov    %eax,0x4(%esp)
80103854:	8b 43 04             	mov    0x4(%ebx),%eax
80103857:	89 04 24             	mov    %eax,(%esp)
8010385a:	e8 81 31 00 00       	call   801069e0 <deallocuvm>
8010385f:	85 c0                	test   %eax,%eax
80103861:	75 cf                	jne    80103832 <growproc+0x32>
80103863:	90                   	nop
80103864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80103868:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010386d:	eb cf                	jmp    8010383e <growproc+0x3e>
8010386f:	90                   	nop

80103870 <fork>:
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	57                   	push   %edi
80103874:	56                   	push   %esi
80103875:	53                   	push   %ebx
80103876:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103879:	e8 42 fe ff ff       	call   801036c0 <myproc>
8010387e:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103880:	e8 4b fc ff ff       	call   801034d0 <allocproc>
80103885:	85 c0                	test   %eax,%eax
80103887:	89 c7                	mov    %eax,%edi
80103889:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010388c:	0f 84 cc 00 00 00    	je     8010395e <fork+0xee>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103892:	8b 03                	mov    (%ebx),%eax
80103894:	89 44 24 04          	mov    %eax,0x4(%esp)
80103898:	8b 43 04             	mov    0x4(%ebx),%eax
8010389b:	89 04 24             	mov    %eax,(%esp)
8010389e:	e8 bd 32 00 00       	call   80106b60 <copyuvm>
801038a3:	85 c0                	test   %eax,%eax
801038a5:	89 47 04             	mov    %eax,0x4(%edi)
801038a8:	0f 84 b7 00 00 00    	je     80103965 <fork+0xf5>
  np->sz = curproc->sz;
801038ae:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
801038b0:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
801038b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038b8:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
801038ba:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
801038bd:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
801038c0:	8b 73 18             	mov    0x18(%ebx),%esi
801038c3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801038c5:	31 f6                	xor    %esi,%esi
  np->prior_val = curproc->prior_val;     // Kevin Prada
801038c7:	8b 43 7c             	mov    0x7c(%ebx),%eax
  np->T_burst = 0;
801038ca:	c7 82 88 00 00 00 00 	movl   $0x0,0x88(%edx)
801038d1:	00 00 00 
  np->prior_val = curproc->prior_val;     // Kevin Prada
801038d4:	89 42 7c             	mov    %eax,0x7c(%edx)
  np->tf->eax = 0;
801038d7:	8b 42 18             	mov    0x18(%edx),%eax
801038da:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801038e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
801038e8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801038ec:	85 c0                	test   %eax,%eax
801038ee:	74 0f                	je     801038ff <fork+0x8f>
      np->ofile[i] = filedup(curproc->ofile[i]);
801038f0:	89 04 24             	mov    %eax,(%esp)
801038f3:	e8 f8 d4 ff ff       	call   80100df0 <filedup>
801038f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038fb:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801038ff:	83 c6 01             	add    $0x1,%esi
80103902:	83 fe 10             	cmp    $0x10,%esi
80103905:	75 e1                	jne    801038e8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103907:	8b 43 68             	mov    0x68(%ebx),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010390a:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010390d:	89 04 24             	mov    %eax,(%esp)
80103910:	e8 7b dd ff ff       	call   80101690 <idup>
80103915:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103918:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010391b:	8d 47 6c             	lea    0x6c(%edi),%eax
8010391e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103922:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103929:	00 
8010392a:	89 04 24             	mov    %eax,(%esp)
8010392d:	e8 4e 0c 00 00       	call   80104580 <safestrcpy>
  pid = np->pid;
80103932:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103935:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010393c:	e8 9f 09 00 00       	call   801042e0 <acquire>
  np->state = RUNNABLE;
80103941:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103948:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010394f:	e8 fc 09 00 00       	call   80104350 <release>
  return pid;
80103954:	89 d8                	mov    %ebx,%eax
}
80103956:	83 c4 1c             	add    $0x1c,%esp
80103959:	5b                   	pop    %ebx
8010395a:	5e                   	pop    %esi
8010395b:	5f                   	pop    %edi
8010395c:	5d                   	pop    %ebp
8010395d:	c3                   	ret    
    return -1;
8010395e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103963:	eb f1                	jmp    80103956 <fork+0xe6>
    kfree(np->kstack);
80103965:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103968:	8b 43 08             	mov    0x8(%ebx),%eax
8010396b:	89 04 24             	mov    %eax,(%esp)
8010396e:	e8 8d e9 ff ff       	call   80102300 <kfree>
    return -1;
80103973:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    np->kstack = 0;
80103978:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
8010397f:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103986:	eb ce                	jmp    80103956 <fork+0xe6>
80103988:	90                   	nop
80103989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103990 <scheduler>:
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	57                   	push   %edi
80103994:	56                   	push   %esi
80103995:	53                   	push   %ebx
80103996:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103999:	e8 82 fc ff ff       	call   80103620 <mycpu>
8010399e:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
801039a0:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801039a7:	00 00 00 
801039aa:	8d 70 04             	lea    0x4(%eax),%esi
801039ad:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801039b0:	fb                   	sti    
    acquire(&ptable.lock);
801039b1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039b8:	e8 23 09 00 00       	call   801042e0 <acquire>
801039bd:	b9 20 00 00 00       	mov    $0x20,%ecx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039c2:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
801039c7:	eb 15                	jmp    801039de <scheduler+0x4e>
801039c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039d0:	81 c2 8c 00 00 00    	add    $0x8c,%edx
801039d6:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
801039dc:	74 29                	je     80103a07 <scheduler+0x77>
      if(p->state != RUNNABLE)
801039de:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
801039e2:	75 ec                	jne    801039d0 <scheduler+0x40>
      if(p->prior_val < maxPriority)  // KP lines 354 - 364
801039e4:	8b 42 7c             	mov    0x7c(%edx),%eax
801039e7:	39 c8                	cmp    %ecx,%eax
801039e9:	7d 04                	jge    801039ef <scheduler+0x5f>
801039eb:	89 d7                	mov    %edx,%edi
801039ed:	89 c1                	mov    %eax,%ecx
      if(p->prior_val >= 1)
801039ef:	85 c0                	test   %eax,%eax
801039f1:	7e dd                	jle    801039d0 <scheduler+0x40>
        p->prior_val = p->prior_val - 1;
801039f3:	83 e8 01             	sub    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039f6:	81 c2 8c 00 00 00    	add    $0x8c,%edx
        p->prior_val = p->prior_val - 1;
801039fc:	89 42 f0             	mov    %eax,-0x10(%edx)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039ff:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
80103a05:	75 d7                	jne    801039de <scheduler+0x4e>
      if(maxPriority == 32)
80103a07:	83 f9 20             	cmp    $0x20,%ecx
80103a0a:	74 63                	je     80103a6f <scheduler+0xdf>
      if(priorityProc->prior_val == 0){
80103a0c:	8b 47 7c             	mov    0x7c(%edi),%eax
80103a0f:	85 c0                	test   %eax,%eax
80103a11:	75 54                	jne    80103a67 <scheduler+0xd7>
        priorityProc->prior_val = priorityProc->prior_val + 1;
80103a13:	c7 47 7c 01 00 00 00 	movl   $0x1,0x7c(%edi)
      c->proc = p;
80103a1a:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(p);
80103a20:	89 3c 24             	mov    %edi,(%esp)
80103a23:	e8 78 2c 00 00       	call   801066a0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103a28:	8b 47 1c             	mov    0x1c(%edi),%eax
      p->T_burst = p->T_burst + 1;
80103a2b:	83 87 88 00 00 00 01 	addl   $0x1,0x88(%edi)
      p->state = RUNNING;
80103a32:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      priorityProc = 0;
80103a39:	31 ff                	xor    %edi,%edi
      swtch(&(c->scheduler), p->context);
80103a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a3f:	89 34 24             	mov    %esi,(%esp)
80103a42:	e8 94 0b 00 00       	call   801045db <swtch>
      switchkvm();
80103a47:	e8 34 2c 00 00       	call   80106680 <switchkvm>
      c->proc = 0;
80103a4c:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103a53:	00 00 00 
    release(&ptable.lock);
80103a56:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a5d:	e8 ee 08 00 00       	call   80104350 <release>
80103a62:	e9 49 ff ff ff       	jmp    801039b0 <scheduler+0x20>
        priorityProc->prior_val = priorityProc->prior_val + 2;
80103a67:	83 c0 02             	add    $0x2,%eax
80103a6a:	89 47 7c             	mov    %eax,0x7c(%edi)
80103a6d:	eb ab                	jmp    80103a1a <scheduler+0x8a>
        release(&ptable.lock);
80103a6f:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a76:	e8 d5 08 00 00       	call   80104350 <release>
        continue;
80103a7b:	e9 30 ff ff ff       	jmp    801039b0 <scheduler+0x20>

80103a80 <sched>:
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	56                   	push   %esi
80103a84:	53                   	push   %ebx
80103a85:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
80103a88:	e8 33 fc ff ff       	call   801036c0 <myproc>
  if(!holding(&ptable.lock))
80103a8d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *p = myproc();
80103a94:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103a96:	e8 05 08 00 00       	call   801042a0 <holding>
80103a9b:	85 c0                	test   %eax,%eax
80103a9d:	74 4f                	je     80103aee <sched+0x6e>
  if(mycpu()->ncli != 1)
80103a9f:	e8 7c fb ff ff       	call   80103620 <mycpu>
80103aa4:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103aab:	75 65                	jne    80103b12 <sched+0x92>
  if(p->state == RUNNING)
80103aad:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ab1:	74 53                	je     80103b06 <sched+0x86>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ab3:	9c                   	pushf  
80103ab4:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ab5:	f6 c4 02             	test   $0x2,%ah
80103ab8:	75 40                	jne    80103afa <sched+0x7a>
  intena = mycpu()->intena;
80103aba:	e8 61 fb ff ff       	call   80103620 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103abf:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ac2:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ac8:	e8 53 fb ff ff       	call   80103620 <mycpu>
80103acd:	8b 40 04             	mov    0x4(%eax),%eax
80103ad0:	89 1c 24             	mov    %ebx,(%esp)
80103ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ad7:	e8 ff 0a 00 00       	call   801045db <swtch>
  mycpu()->intena = intena;
80103adc:	e8 3f fb ff ff       	call   80103620 <mycpu>
80103ae1:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ae7:	83 c4 10             	add    $0x10,%esp
80103aea:	5b                   	pop    %ebx
80103aeb:	5e                   	pop    %esi
80103aec:	5d                   	pop    %ebp
80103aed:	c3                   	ret    
    panic("sched ptable.lock");
80103aee:	c7 04 24 b0 72 10 80 	movl   $0x801072b0,(%esp)
80103af5:	e8 66 c8 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103afa:	c7 04 24 dc 72 10 80 	movl   $0x801072dc,(%esp)
80103b01:	e8 5a c8 ff ff       	call   80100360 <panic>
    panic("sched running");
80103b06:	c7 04 24 ce 72 10 80 	movl   $0x801072ce,(%esp)
80103b0d:	e8 4e c8 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103b12:	c7 04 24 c2 72 10 80 	movl   $0x801072c2,(%esp)
80103b19:	e8 42 c8 ff ff       	call   80100360 <panic>
80103b1e:	66 90                	xchg   %ax,%ax

80103b20 <exit>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	56                   	push   %esi
  if(curproc == initproc)
80103b24:	31 f6                	xor    %esi,%esi
{
80103b26:	53                   	push   %ebx
80103b27:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103b2a:	e8 91 fb ff ff       	call   801036c0 <myproc>
  if(curproc == initproc)
80103b2f:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
  struct proc *curproc = myproc();
80103b35:	89 c3                	mov    %eax,%ebx
  if(curproc == initproc)
80103b37:	0f 84 35 01 00 00    	je     80103c72 <exit+0x152>
80103b3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103b40:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103b44:	85 c0                	test   %eax,%eax
80103b46:	74 10                	je     80103b58 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103b48:	89 04 24             	mov    %eax,(%esp)
80103b4b:	e8 f0 d2 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103b50:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103b57:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103b58:	83 c6 01             	add    $0x1,%esi
80103b5b:	83 fe 10             	cmp    $0x10,%esi
80103b5e:	75 e0                	jne    80103b40 <exit+0x20>
  begin_op();
80103b60:	e8 bb ef ff ff       	call   80102b20 <begin_op>
  iput(curproc->cwd);
80103b65:	8b 43 68             	mov    0x68(%ebx),%eax
80103b68:	89 04 24             	mov    %eax,(%esp)
80103b6b:	e8 70 dc ff ff       	call   801017e0 <iput>
  end_op();
80103b70:	e8 1b f0 ff ff       	call   80102b90 <end_op>
  curproc->cwd = 0;
80103b75:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103b7c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b83:	e8 58 07 00 00       	call   801042e0 <acquire>
  wakeup1(curproc->parent);
80103b88:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b8b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b90:	eb 14                	jmp    80103ba6 <exit+0x86>
80103b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b98:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103b9e:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
80103ba4:	74 20                	je     80103bc6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103ba6:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103baa:	75 ec                	jne    80103b98 <exit+0x78>
80103bac:	3b 42 20             	cmp    0x20(%edx),%eax
80103baf:	75 e7                	jne    80103b98 <exit+0x78>
      p->state = RUNNABLE;
80103bb1:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bb8:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103bbe:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
80103bc4:	75 e0                	jne    80103ba6 <exit+0x86>
      p->parent = initproc;
80103bc6:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103bcb:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103bd0:	eb 14                	jmp    80103be6 <exit+0xc6>
80103bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bd8:	81 c1 8c 00 00 00    	add    $0x8c,%ecx
80103bde:	81 f9 54 50 11 80    	cmp    $0x80115054,%ecx
80103be4:	74 3c                	je     80103c22 <exit+0x102>
    if(p->parent == curproc){
80103be6:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103be9:	75 ed                	jne    80103bd8 <exit+0xb8>
      if(p->state == ZOMBIE)
80103beb:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
      p->parent = initproc;
80103bef:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103bf2:	75 e4                	jne    80103bd8 <exit+0xb8>
80103bf4:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103bf9:	eb 13                	jmp    80103c0e <exit+0xee>
80103bfb:	90                   	nop
80103bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c00:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103c06:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
80103c0c:	74 ca                	je     80103bd8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103c0e:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103c12:	75 ec                	jne    80103c00 <exit+0xe0>
80103c14:	3b 42 20             	cmp    0x20(%edx),%eax
80103c17:	75 e7                	jne    80103c00 <exit+0xe0>
      p->state = RUNNABLE;
80103c19:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103c20:	eb de                	jmp    80103c00 <exit+0xe0>
  curproc->T_finish = ticks; // KP set finish time
80103c22:	8b 35 a0 58 11 80    	mov    0x801158a0,%esi
  curproc->state = ZOMBIE;
80103c28:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  curproc->T_finish = ticks; // KP set finish time
80103c2f:	89 b3 84 00 00 00    	mov    %esi,0x84(%ebx)
  uint turnaround = curproc->T_finish - curproc->T_start;
80103c35:	2b b3 80 00 00 00    	sub    0x80(%ebx),%esi
  cprintf("Turnaround time: %d\n", turnaround);
80103c3b:	c7 04 24 fd 72 10 80 	movl   $0x801072fd,(%esp)
80103c42:	89 74 24 04          	mov    %esi,0x4(%esp)
80103c46:	e8 05 ca ff ff       	call   80100650 <cprintf>
  uint waitingTime = turnaround - curproc->T_burst;
80103c4b:	2b b3 88 00 00 00    	sub    0x88(%ebx),%esi
  cprintf("Waiting time: %d\n", waitingTime);
80103c51:	c7 04 24 12 73 10 80 	movl   $0x80107312,(%esp)
80103c58:	89 74 24 04          	mov    %esi,0x4(%esp)
80103c5c:	e8 ef c9 ff ff       	call   80100650 <cprintf>
  sched();
80103c61:	e8 1a fe ff ff       	call   80103a80 <sched>
  panic("zombie exit");
80103c66:	c7 04 24 24 73 10 80 	movl   $0x80107324,(%esp)
80103c6d:	e8 ee c6 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103c72:	c7 04 24 f0 72 10 80 	movl   $0x801072f0,(%esp)
80103c79:	e8 e2 c6 ff ff       	call   80100360 <panic>
80103c7e:	66 90                	xchg   %ax,%ax

80103c80 <yield>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103c86:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c8d:	e8 4e 06 00 00       	call   801042e0 <acquire>
  myproc()->state = RUNNABLE;
80103c92:	e8 29 fa ff ff       	call   801036c0 <myproc>
80103c97:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103c9e:	e8 dd fd ff ff       	call   80103a80 <sched>
  release(&ptable.lock);
80103ca3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103caa:	e8 a1 06 00 00       	call   80104350 <release>
}
80103caf:	c9                   	leave  
80103cb0:	c3                   	ret    
80103cb1:	eb 0d                	jmp    80103cc0 <sleep>
80103cb3:	90                   	nop
80103cb4:	90                   	nop
80103cb5:	90                   	nop
80103cb6:	90                   	nop
80103cb7:	90                   	nop
80103cb8:	90                   	nop
80103cb9:	90                   	nop
80103cba:	90                   	nop
80103cbb:	90                   	nop
80103cbc:	90                   	nop
80103cbd:	90                   	nop
80103cbe:	90                   	nop
80103cbf:	90                   	nop

80103cc0 <sleep>:
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	57                   	push   %edi
80103cc4:	56                   	push   %esi
80103cc5:	53                   	push   %ebx
80103cc6:	83 ec 1c             	sub    $0x1c,%esp
80103cc9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103ccc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103ccf:	e8 ec f9 ff ff       	call   801036c0 <myproc>
  if(p == 0)
80103cd4:	85 c0                	test   %eax,%eax
  struct proc *p = myproc();
80103cd6:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103cd8:	0f 84 7c 00 00 00    	je     80103d5a <sleep+0x9a>
  if(lk == 0)
80103cde:	85 f6                	test   %esi,%esi
80103ce0:	74 6c                	je     80103d4e <sleep+0x8e>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103ce2:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103ce8:	74 46                	je     80103d30 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103cea:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cf1:	e8 ea 05 00 00       	call   801042e0 <acquire>
    release(lk);
80103cf6:	89 34 24             	mov    %esi,(%esp)
80103cf9:	e8 52 06 00 00       	call   80104350 <release>
  p->chan = chan;
80103cfe:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103d01:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103d08:	e8 73 fd ff ff       	call   80103a80 <sched>
  p->chan = 0;
80103d0d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103d14:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d1b:	e8 30 06 00 00       	call   80104350 <release>
    acquire(lk);
80103d20:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103d23:	83 c4 1c             	add    $0x1c,%esp
80103d26:	5b                   	pop    %ebx
80103d27:	5e                   	pop    %esi
80103d28:	5f                   	pop    %edi
80103d29:	5d                   	pop    %ebp
    acquire(lk);
80103d2a:	e9 b1 05 00 00       	jmp    801042e0 <acquire>
80103d2f:	90                   	nop
  p->chan = chan;
80103d30:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103d33:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103d3a:	e8 41 fd ff ff       	call   80103a80 <sched>
  p->chan = 0;
80103d3f:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103d46:	83 c4 1c             	add    $0x1c,%esp
80103d49:	5b                   	pop    %ebx
80103d4a:	5e                   	pop    %esi
80103d4b:	5f                   	pop    %edi
80103d4c:	5d                   	pop    %ebp
80103d4d:	c3                   	ret    
    panic("sleep without lk");
80103d4e:	c7 04 24 36 73 10 80 	movl   $0x80107336,(%esp)
80103d55:	e8 06 c6 ff ff       	call   80100360 <panic>
    panic("sleep");
80103d5a:	c7 04 24 30 73 10 80 	movl   $0x80107330,(%esp)
80103d61:	e8 fa c5 ff ff       	call   80100360 <panic>
80103d66:	8d 76 00             	lea    0x0(%esi),%esi
80103d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d70 <wait>:
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	56                   	push   %esi
80103d74:	53                   	push   %ebx
80103d75:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103d78:	e8 43 f9 ff ff       	call   801036c0 <myproc>
  acquire(&ptable.lock);
80103d7d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
80103d84:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103d86:	e8 55 05 00 00       	call   801042e0 <acquire>
    havekids = 0;
80103d8b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d8d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103d92:	eb 12                	jmp    80103da6 <wait+0x36>
80103d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d98:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103d9e:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80103da4:	74 22                	je     80103dc8 <wait+0x58>
      if(p->parent != curproc)
80103da6:	39 73 14             	cmp    %esi,0x14(%ebx)
80103da9:	75 ed                	jne    80103d98 <wait+0x28>
      if(p->state == ZOMBIE){
80103dab:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103daf:	74 34                	je     80103de5 <wait+0x75>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103db1:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      havekids = 1;
80103db7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dbc:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80103dc2:	75 e2                	jne    80103da6 <wait+0x36>
80103dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(!havekids || curproc->killed){
80103dc8:	85 c0                	test   %eax,%eax
80103dca:	74 6e                	je     80103e3a <wait+0xca>
80103dcc:	8b 46 24             	mov    0x24(%esi),%eax
80103dcf:	85 c0                	test   %eax,%eax
80103dd1:	75 67                	jne    80103e3a <wait+0xca>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103dd3:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103dda:	80 
80103ddb:	89 34 24             	mov    %esi,(%esp)
80103dde:	e8 dd fe ff ff       	call   80103cc0 <sleep>
  }
80103de3:	eb a6                	jmp    80103d8b <wait+0x1b>
        kfree(p->kstack);
80103de5:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
80103de8:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103deb:	89 04 24             	mov    %eax,(%esp)
80103dee:	e8 0d e5 ff ff       	call   80102300 <kfree>
        freevm(p->pgdir);
80103df3:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80103df6:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103dfd:	89 04 24             	mov    %eax,(%esp)
80103e00:	e8 fb 2b 00 00       	call   80106a00 <freevm>
        release(&ptable.lock);
80103e05:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103e0c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103e13:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103e1a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103e1e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103e25:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103e2c:	e8 1f 05 00 00       	call   80104350 <release>
}
80103e31:	83 c4 10             	add    $0x10,%esp
        return pid;
80103e34:	89 f0                	mov    %esi,%eax
}
80103e36:	5b                   	pop    %ebx
80103e37:	5e                   	pop    %esi
80103e38:	5d                   	pop    %ebp
80103e39:	c3                   	ret    
      release(&ptable.lock);
80103e3a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e41:	e8 0a 05 00 00       	call   80104350 <release>
}
80103e46:	83 c4 10             	add    $0x10,%esp
      return -1;
80103e49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e4e:	5b                   	pop    %ebx
80103e4f:	5e                   	pop    %esi
80103e50:	5d                   	pop    %ebp
80103e51:	c3                   	ret    
80103e52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e60 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	53                   	push   %ebx
80103e64:	83 ec 14             	sub    $0x14,%esp
80103e67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103e6a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e71:	e8 6a 04 00 00       	call   801042e0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e76:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e7b:	eb 0f                	jmp    80103e8c <wakeup+0x2c>
80103e7d:	8d 76 00             	lea    0x0(%esi),%esi
80103e80:	05 8c 00 00 00       	add    $0x8c,%eax
80103e85:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103e8a:	74 24                	je     80103eb0 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
80103e8c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e90:	75 ee                	jne    80103e80 <wakeup+0x20>
80103e92:	3b 58 20             	cmp    0x20(%eax),%ebx
80103e95:	75 e9                	jne    80103e80 <wakeup+0x20>
      p->state = RUNNABLE;
80103e97:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e9e:	05 8c 00 00 00       	add    $0x8c,%eax
80103ea3:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103ea8:	75 e2                	jne    80103e8c <wakeup+0x2c>
80103eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  wakeup1(chan);
  release(&ptable.lock);
80103eb0:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103eb7:	83 c4 14             	add    $0x14,%esp
80103eba:	5b                   	pop    %ebx
80103ebb:	5d                   	pop    %ebp
  release(&ptable.lock);
80103ebc:	e9 8f 04 00 00       	jmp    80104350 <release>
80103ec1:	eb 0d                	jmp    80103ed0 <kill>
80103ec3:	90                   	nop
80103ec4:	90                   	nop
80103ec5:	90                   	nop
80103ec6:	90                   	nop
80103ec7:	90                   	nop
80103ec8:	90                   	nop
80103ec9:	90                   	nop
80103eca:	90                   	nop
80103ecb:	90                   	nop
80103ecc:	90                   	nop
80103ecd:	90                   	nop
80103ece:	90                   	nop
80103ecf:	90                   	nop

80103ed0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	53                   	push   %ebx
80103ed4:	83 ec 14             	sub    $0x14,%esp
80103ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103eda:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ee1:	e8 fa 03 00 00       	call   801042e0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ee6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103eeb:	eb 0f                	jmp    80103efc <kill+0x2c>
80103eed:	8d 76 00             	lea    0x0(%esi),%esi
80103ef0:	05 8c 00 00 00       	add    $0x8c,%eax
80103ef5:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103efa:	74 3c                	je     80103f38 <kill+0x68>
    if(p->pid == pid){
80103efc:	39 58 10             	cmp    %ebx,0x10(%eax)
80103eff:	75 ef                	jne    80103ef0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f01:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103f05:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103f0c:	74 1a                	je     80103f28 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103f0e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f15:	e8 36 04 00 00       	call   80104350 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f1a:	83 c4 14             	add    $0x14,%esp
      return 0;
80103f1d:	31 c0                	xor    %eax,%eax
}
80103f1f:	5b                   	pop    %ebx
80103f20:	5d                   	pop    %ebp
80103f21:	c3                   	ret    
80103f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        p->state = RUNNABLE;
80103f28:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f2f:	eb dd                	jmp    80103f0e <kill+0x3e>
80103f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103f38:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f3f:	e8 0c 04 00 00       	call   80104350 <release>
}
80103f44:	83 c4 14             	add    $0x14,%esp
  return -1;
80103f47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f4c:	5b                   	pop    %ebx
80103f4d:	5d                   	pop    %ebp
80103f4e:	c3                   	ret    
80103f4f:	90                   	nop

80103f50 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	57                   	push   %edi
80103f54:	56                   	push   %esi
80103f55:	53                   	push   %ebx
80103f56:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103f5b:	83 ec 4c             	sub    $0x4c,%esp
80103f5e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103f61:	eb 23                	jmp    80103f86 <procdump+0x36>
80103f63:	90                   	nop
80103f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103f68:	c7 04 24 bb 76 10 80 	movl   $0x801076bb,(%esp)
80103f6f:	e8 dc c6 ff ff       	call   80100650 <cprintf>
80103f74:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f7a:	81 fb c0 50 11 80    	cmp    $0x801150c0,%ebx
80103f80:	0f 84 8a 00 00 00    	je     80104010 <procdump+0xc0>
    if(p->state == UNUSED)
80103f86:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103f89:	85 c0                	test   %eax,%eax
80103f8b:	74 e7                	je     80103f74 <procdump+0x24>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f8d:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80103f90:	ba 47 73 10 80       	mov    $0x80107347,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f95:	77 11                	ja     80103fa8 <procdump+0x58>
80103f97:	8b 14 85 a8 73 10 80 	mov    -0x7fef8c58(,%eax,4),%edx
      state = "???";
80103f9e:	b8 47 73 10 80       	mov    $0x80107347,%eax
80103fa3:	85 d2                	test   %edx,%edx
80103fa5:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103fa8:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103fab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103faf:	89 54 24 08          	mov    %edx,0x8(%esp)
80103fb3:	c7 04 24 4b 73 10 80 	movl   $0x8010734b,(%esp)
80103fba:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fbe:	e8 8d c6 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103fc3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103fc7:	75 9f                	jne    80103f68 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103fc9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103fcc:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fd0:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103fd3:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103fd6:	8b 40 0c             	mov    0xc(%eax),%eax
80103fd9:	83 c0 08             	add    $0x8,%eax
80103fdc:	89 04 24             	mov    %eax,(%esp)
80103fdf:	e8 ac 01 00 00       	call   80104190 <getcallerpcs>
80103fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103fe8:	8b 17                	mov    (%edi),%edx
80103fea:	85 d2                	test   %edx,%edx
80103fec:	0f 84 76 ff ff ff    	je     80103f68 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103ff2:	89 54 24 04          	mov    %edx,0x4(%esp)
80103ff6:	83 c7 04             	add    $0x4,%edi
80103ff9:	c7 04 24 61 6d 10 80 	movl   $0x80106d61,(%esp)
80104000:	e8 4b c6 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104005:	39 f7                	cmp    %esi,%edi
80104007:	75 df                	jne    80103fe8 <procdump+0x98>
80104009:	e9 5a ff ff ff       	jmp    80103f68 <procdump+0x18>
8010400e:	66 90                	xchg   %ax,%ax
  }
}
80104010:	83 c4 4c             	add    $0x4c,%esp
80104013:	5b                   	pop    %ebx
80104014:	5e                   	pop    %esi
80104015:	5f                   	pop    %edi
80104016:	5d                   	pop    %ebp
80104017:	c3                   	ret    
80104018:	90                   	nop
80104019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104020 <setpriority>:

int 
setpriority(int prior_val){
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104026:	e8 95 f6 ff ff       	call   801036c0 <myproc>
  curproc->prior_val = prior_val;
8010402b:	8b 55 08             	mov    0x8(%ebp),%edx
8010402e:	89 50 7c             	mov    %edx,0x7c(%eax)
  yield();
80104031:	e8 4a fc ff ff       	call   80103c80 <yield>
  
  return 1;
}
80104036:	b8 01 00 00 00       	mov    $0x1,%eax
8010403b:	c9                   	leave  
8010403c:	c3                   	ret    
8010403d:	66 90                	xchg   %ax,%ax
8010403f:	90                   	nop

80104040 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	53                   	push   %ebx
80104044:	83 ec 14             	sub    $0x14,%esp
80104047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010404a:	c7 44 24 04 c0 73 10 	movl   $0x801073c0,0x4(%esp)
80104051:	80 
80104052:	8d 43 04             	lea    0x4(%ebx),%eax
80104055:	89 04 24             	mov    %eax,(%esp)
80104058:	e8 13 01 00 00       	call   80104170 <initlock>
  lk->name = name;
8010405d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104060:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104066:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010406d:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104070:	83 c4 14             	add    $0x14,%esp
80104073:	5b                   	pop    %ebx
80104074:	5d                   	pop    %ebp
80104075:	c3                   	ret    
80104076:	8d 76 00             	lea    0x0(%esi),%esi
80104079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104080 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	56                   	push   %esi
80104084:	53                   	push   %ebx
80104085:	83 ec 10             	sub    $0x10,%esp
80104088:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010408b:	8d 73 04             	lea    0x4(%ebx),%esi
8010408e:	89 34 24             	mov    %esi,(%esp)
80104091:	e8 4a 02 00 00       	call   801042e0 <acquire>
  while (lk->locked) {
80104096:	8b 13                	mov    (%ebx),%edx
80104098:	85 d2                	test   %edx,%edx
8010409a:	74 16                	je     801040b2 <acquiresleep+0x32>
8010409c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801040a0:	89 74 24 04          	mov    %esi,0x4(%esp)
801040a4:	89 1c 24             	mov    %ebx,(%esp)
801040a7:	e8 14 fc ff ff       	call   80103cc0 <sleep>
  while (lk->locked) {
801040ac:	8b 03                	mov    (%ebx),%eax
801040ae:	85 c0                	test   %eax,%eax
801040b0:	75 ee                	jne    801040a0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801040b2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801040b8:	e8 03 f6 ff ff       	call   801036c0 <myproc>
801040bd:	8b 40 10             	mov    0x10(%eax),%eax
801040c0:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801040c3:	89 75 08             	mov    %esi,0x8(%ebp)
}
801040c6:	83 c4 10             	add    $0x10,%esp
801040c9:	5b                   	pop    %ebx
801040ca:	5e                   	pop    %esi
801040cb:	5d                   	pop    %ebp
  release(&lk->lk);
801040cc:	e9 7f 02 00 00       	jmp    80104350 <release>
801040d1:	eb 0d                	jmp    801040e0 <releasesleep>
801040d3:	90                   	nop
801040d4:	90                   	nop
801040d5:	90                   	nop
801040d6:	90                   	nop
801040d7:	90                   	nop
801040d8:	90                   	nop
801040d9:	90                   	nop
801040da:	90                   	nop
801040db:	90                   	nop
801040dc:	90                   	nop
801040dd:	90                   	nop
801040de:	90                   	nop
801040df:	90                   	nop

801040e0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	56                   	push   %esi
801040e4:	53                   	push   %ebx
801040e5:	83 ec 10             	sub    $0x10,%esp
801040e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801040eb:	8d 73 04             	lea    0x4(%ebx),%esi
801040ee:	89 34 24             	mov    %esi,(%esp)
801040f1:	e8 ea 01 00 00       	call   801042e0 <acquire>
  lk->locked = 0;
801040f6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801040fc:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104103:	89 1c 24             	mov    %ebx,(%esp)
80104106:	e8 55 fd ff ff       	call   80103e60 <wakeup>
  release(&lk->lk);
8010410b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010410e:	83 c4 10             	add    $0x10,%esp
80104111:	5b                   	pop    %ebx
80104112:	5e                   	pop    %esi
80104113:	5d                   	pop    %ebp
  release(&lk->lk);
80104114:	e9 37 02 00 00       	jmp    80104350 <release>
80104119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104120 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	57                   	push   %edi
  int r;
  
  acquire(&lk->lk);
  r = lk->locked && (lk->pid == myproc()->pid);
80104124:	31 ff                	xor    %edi,%edi
{
80104126:	56                   	push   %esi
80104127:	53                   	push   %ebx
80104128:	83 ec 1c             	sub    $0x1c,%esp
8010412b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010412e:	8d 73 04             	lea    0x4(%ebx),%esi
80104131:	89 34 24             	mov    %esi,(%esp)
80104134:	e8 a7 01 00 00       	call   801042e0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104139:	8b 03                	mov    (%ebx),%eax
8010413b:	85 c0                	test   %eax,%eax
8010413d:	74 13                	je     80104152 <holdingsleep+0x32>
8010413f:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104142:	e8 79 f5 ff ff       	call   801036c0 <myproc>
80104147:	3b 58 10             	cmp    0x10(%eax),%ebx
8010414a:	0f 94 c0             	sete   %al
8010414d:	0f b6 c0             	movzbl %al,%eax
80104150:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104152:	89 34 24             	mov    %esi,(%esp)
80104155:	e8 f6 01 00 00       	call   80104350 <release>
  return r;
}
8010415a:	83 c4 1c             	add    $0x1c,%esp
8010415d:	89 f8                	mov    %edi,%eax
8010415f:	5b                   	pop    %ebx
80104160:	5e                   	pop    %esi
80104161:	5f                   	pop    %edi
80104162:	5d                   	pop    %ebp
80104163:	c3                   	ret    
80104164:	66 90                	xchg   %ax,%ax
80104166:	66 90                	xchg   %ax,%ax
80104168:	66 90                	xchg   %ax,%ax
8010416a:	66 90                	xchg   %ax,%ax
8010416c:	66 90                	xchg   %ax,%ax
8010416e:	66 90                	xchg   %ax,%ax

80104170 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104176:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104179:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010417f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104182:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104189:	5d                   	pop    %ebp
8010418a:	c3                   	ret    
8010418b:	90                   	nop
8010418c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104190 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104193:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104196:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104199:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010419a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010419d:	31 c0                	xor    %eax,%eax
8010419f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801041a0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801041a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801041ac:	77 1a                	ja     801041c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801041ae:	8b 5a 04             	mov    0x4(%edx),%ebx
801041b1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801041b4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801041b7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801041b9:	83 f8 0a             	cmp    $0xa,%eax
801041bc:	75 e2                	jne    801041a0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801041be:	5b                   	pop    %ebx
801041bf:	5d                   	pop    %ebp
801041c0:	c3                   	ret    
801041c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801041c8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801041cf:	83 c0 01             	add    $0x1,%eax
801041d2:	83 f8 0a             	cmp    $0xa,%eax
801041d5:	74 e7                	je     801041be <getcallerpcs+0x2e>
    pcs[i] = 0;
801041d7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801041de:	83 c0 01             	add    $0x1,%eax
801041e1:	83 f8 0a             	cmp    $0xa,%eax
801041e4:	75 e2                	jne    801041c8 <getcallerpcs+0x38>
801041e6:	eb d6                	jmp    801041be <getcallerpcs+0x2e>
801041e8:	90                   	nop
801041e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041f0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	53                   	push   %ebx
801041f4:	83 ec 04             	sub    $0x4,%esp
801041f7:	9c                   	pushf  
801041f8:	5b                   	pop    %ebx
  asm volatile("cli");
801041f9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801041fa:	e8 21 f4 ff ff       	call   80103620 <mycpu>
801041ff:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104205:	85 c0                	test   %eax,%eax
80104207:	75 11                	jne    8010421a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104209:	e8 12 f4 ff ff       	call   80103620 <mycpu>
8010420e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104214:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010421a:	e8 01 f4 ff ff       	call   80103620 <mycpu>
8010421f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104226:	83 c4 04             	add    $0x4,%esp
80104229:	5b                   	pop    %ebx
8010422a:	5d                   	pop    %ebp
8010422b:	c3                   	ret    
8010422c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104230 <popcli>:

void
popcli(void)
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104236:	9c                   	pushf  
80104237:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104238:	f6 c4 02             	test   $0x2,%ah
8010423b:	75 49                	jne    80104286 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010423d:	e8 de f3 ff ff       	call   80103620 <mycpu>
80104242:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104248:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010424b:	85 d2                	test   %edx,%edx
8010424d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104253:	78 25                	js     8010427a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104255:	e8 c6 f3 ff ff       	call   80103620 <mycpu>
8010425a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104260:	85 d2                	test   %edx,%edx
80104262:	74 04                	je     80104268 <popcli+0x38>
    sti();
}
80104264:	c9                   	leave  
80104265:	c3                   	ret    
80104266:	66 90                	xchg   %ax,%ax
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104268:	e8 b3 f3 ff ff       	call   80103620 <mycpu>
8010426d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104273:	85 c0                	test   %eax,%eax
80104275:	74 ed                	je     80104264 <popcli+0x34>
  asm volatile("sti");
80104277:	fb                   	sti    
}
80104278:	c9                   	leave  
80104279:	c3                   	ret    
    panic("popcli");
8010427a:	c7 04 24 e2 73 10 80 	movl   $0x801073e2,(%esp)
80104281:	e8 da c0 ff ff       	call   80100360 <panic>
    panic("popcli - interruptible");
80104286:	c7 04 24 cb 73 10 80 	movl   $0x801073cb,(%esp)
8010428d:	e8 ce c0 ff ff       	call   80100360 <panic>
80104292:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042a0 <holding>:
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	56                   	push   %esi
  r = lock->locked && lock->cpu == mycpu();
801042a4:	31 f6                	xor    %esi,%esi
{
801042a6:	53                   	push   %ebx
801042a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801042aa:	e8 41 ff ff ff       	call   801041f0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801042af:	8b 03                	mov    (%ebx),%eax
801042b1:	85 c0                	test   %eax,%eax
801042b3:	74 12                	je     801042c7 <holding+0x27>
801042b5:	8b 5b 08             	mov    0x8(%ebx),%ebx
801042b8:	e8 63 f3 ff ff       	call   80103620 <mycpu>
801042bd:	39 c3                	cmp    %eax,%ebx
801042bf:	0f 94 c0             	sete   %al
801042c2:	0f b6 c0             	movzbl %al,%eax
801042c5:	89 c6                	mov    %eax,%esi
  popcli();
801042c7:	e8 64 ff ff ff       	call   80104230 <popcli>
}
801042cc:	89 f0                	mov    %esi,%eax
801042ce:	5b                   	pop    %ebx
801042cf:	5e                   	pop    %esi
801042d0:	5d                   	pop    %ebp
801042d1:	c3                   	ret    
801042d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042e0 <acquire>:
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801042e7:	e8 04 ff ff ff       	call   801041f0 <pushcli>
  if(holding(lk))
801042ec:	8b 45 08             	mov    0x8(%ebp),%eax
801042ef:	89 04 24             	mov    %eax,(%esp)
801042f2:	e8 a9 ff ff ff       	call   801042a0 <holding>
801042f7:	85 c0                	test   %eax,%eax
801042f9:	75 3a                	jne    80104335 <acquire+0x55>
  asm volatile("lock; xchgl %0, %1" :
801042fb:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
80104300:	8b 55 08             	mov    0x8(%ebp),%edx
80104303:	89 c8                	mov    %ecx,%eax
80104305:	f0 87 02             	lock xchg %eax,(%edx)
80104308:	85 c0                	test   %eax,%eax
8010430a:	75 f4                	jne    80104300 <acquire+0x20>
  __sync_synchronize();
8010430c:	0f ae f0             	mfence 
  lk->cpu = mycpu();
8010430f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104312:	e8 09 f3 ff ff       	call   80103620 <mycpu>
80104317:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010431a:	8b 45 08             	mov    0x8(%ebp),%eax
8010431d:	83 c0 0c             	add    $0xc,%eax
80104320:	89 44 24 04          	mov    %eax,0x4(%esp)
80104324:	8d 45 08             	lea    0x8(%ebp),%eax
80104327:	89 04 24             	mov    %eax,(%esp)
8010432a:	e8 61 fe ff ff       	call   80104190 <getcallerpcs>
}
8010432f:	83 c4 14             	add    $0x14,%esp
80104332:	5b                   	pop    %ebx
80104333:	5d                   	pop    %ebp
80104334:	c3                   	ret    
    panic("acquire");
80104335:	c7 04 24 e9 73 10 80 	movl   $0x801073e9,(%esp)
8010433c:	e8 1f c0 ff ff       	call   80100360 <panic>
80104341:	eb 0d                	jmp    80104350 <release>
80104343:	90                   	nop
80104344:	90                   	nop
80104345:	90                   	nop
80104346:	90                   	nop
80104347:	90                   	nop
80104348:	90                   	nop
80104349:	90                   	nop
8010434a:	90                   	nop
8010434b:	90                   	nop
8010434c:	90                   	nop
8010434d:	90                   	nop
8010434e:	90                   	nop
8010434f:	90                   	nop

80104350 <release>:
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	83 ec 14             	sub    $0x14,%esp
80104357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010435a:	89 1c 24             	mov    %ebx,(%esp)
8010435d:	e8 3e ff ff ff       	call   801042a0 <holding>
80104362:	85 c0                	test   %eax,%eax
80104364:	74 21                	je     80104387 <release+0x37>
  lk->pcs[0] = 0;
80104366:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010436d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104374:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104377:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
8010437d:	83 c4 14             	add    $0x14,%esp
80104380:	5b                   	pop    %ebx
80104381:	5d                   	pop    %ebp
  popcli();
80104382:	e9 a9 fe ff ff       	jmp    80104230 <popcli>
    panic("release");
80104387:	c7 04 24 f1 73 10 80 	movl   $0x801073f1,(%esp)
8010438e:	e8 cd bf ff ff       	call   80100360 <panic>
80104393:	66 90                	xchg   %ax,%ax
80104395:	66 90                	xchg   %ax,%ax
80104397:	66 90                	xchg   %ax,%ax
80104399:	66 90                	xchg   %ax,%ax
8010439b:	66 90                	xchg   %ax,%ax
8010439d:	66 90                	xchg   %ax,%ax
8010439f:	90                   	nop

801043a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	8b 55 08             	mov    0x8(%ebp),%edx
801043a6:	57                   	push   %edi
801043a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801043aa:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801043ab:	f6 c2 03             	test   $0x3,%dl
801043ae:	75 05                	jne    801043b5 <memset+0x15>
801043b0:	f6 c1 03             	test   $0x3,%cl
801043b3:	74 13                	je     801043c8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801043b5:	89 d7                	mov    %edx,%edi
801043b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801043ba:	fc                   	cld    
801043bb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801043bd:	5b                   	pop    %ebx
801043be:	89 d0                	mov    %edx,%eax
801043c0:	5f                   	pop    %edi
801043c1:	5d                   	pop    %ebp
801043c2:	c3                   	ret    
801043c3:	90                   	nop
801043c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801043c8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801043cc:	c1 e9 02             	shr    $0x2,%ecx
801043cf:	89 f8                	mov    %edi,%eax
801043d1:	89 fb                	mov    %edi,%ebx
801043d3:	c1 e0 18             	shl    $0x18,%eax
801043d6:	c1 e3 10             	shl    $0x10,%ebx
801043d9:	09 d8                	or     %ebx,%eax
801043db:	09 f8                	or     %edi,%eax
801043dd:	c1 e7 08             	shl    $0x8,%edi
801043e0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801043e2:	89 d7                	mov    %edx,%edi
801043e4:	fc                   	cld    
801043e5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801043e7:	5b                   	pop    %ebx
801043e8:	89 d0                	mov    %edx,%eax
801043ea:	5f                   	pop    %edi
801043eb:	5d                   	pop    %ebp
801043ec:	c3                   	ret    
801043ed:	8d 76 00             	lea    0x0(%esi),%esi

801043f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	8b 45 10             	mov    0x10(%ebp),%eax
801043f6:	57                   	push   %edi
801043f7:	56                   	push   %esi
801043f8:	8b 75 0c             	mov    0xc(%ebp),%esi
801043fb:	53                   	push   %ebx
801043fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801043ff:	85 c0                	test   %eax,%eax
80104401:	8d 78 ff             	lea    -0x1(%eax),%edi
80104404:	74 26                	je     8010442c <memcmp+0x3c>
    if(*s1 != *s2)
80104406:	0f b6 03             	movzbl (%ebx),%eax
80104409:	31 d2                	xor    %edx,%edx
8010440b:	0f b6 0e             	movzbl (%esi),%ecx
8010440e:	38 c8                	cmp    %cl,%al
80104410:	74 16                	je     80104428 <memcmp+0x38>
80104412:	eb 24                	jmp    80104438 <memcmp+0x48>
80104414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104418:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010441d:	83 c2 01             	add    $0x1,%edx
80104420:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104424:	38 c8                	cmp    %cl,%al
80104426:	75 10                	jne    80104438 <memcmp+0x48>
  while(n-- > 0){
80104428:	39 fa                	cmp    %edi,%edx
8010442a:	75 ec                	jne    80104418 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010442c:	5b                   	pop    %ebx
  return 0;
8010442d:	31 c0                	xor    %eax,%eax
}
8010442f:	5e                   	pop    %esi
80104430:	5f                   	pop    %edi
80104431:	5d                   	pop    %ebp
80104432:	c3                   	ret    
80104433:	90                   	nop
80104434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104438:	5b                   	pop    %ebx
      return *s1 - *s2;
80104439:	29 c8                	sub    %ecx,%eax
}
8010443b:	5e                   	pop    %esi
8010443c:	5f                   	pop    %edi
8010443d:	5d                   	pop    %ebp
8010443e:	c3                   	ret    
8010443f:	90                   	nop

80104440 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	57                   	push   %edi
80104444:	8b 45 08             	mov    0x8(%ebp),%eax
80104447:	56                   	push   %esi
80104448:	8b 75 0c             	mov    0xc(%ebp),%esi
8010444b:	53                   	push   %ebx
8010444c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010444f:	39 c6                	cmp    %eax,%esi
80104451:	73 35                	jae    80104488 <memmove+0x48>
80104453:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104456:	39 c8                	cmp    %ecx,%eax
80104458:	73 2e                	jae    80104488 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010445a:	85 db                	test   %ebx,%ebx
    d += n;
8010445c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010445f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104462:	74 1b                	je     8010447f <memmove+0x3f>
80104464:	f7 db                	neg    %ebx
80104466:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104469:	01 fb                	add    %edi,%ebx
8010446b:	90                   	nop
8010446c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104470:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104474:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    while(n-- > 0)
80104477:	83 ea 01             	sub    $0x1,%edx
8010447a:	83 fa ff             	cmp    $0xffffffff,%edx
8010447d:	75 f1                	jne    80104470 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010447f:	5b                   	pop    %ebx
80104480:	5e                   	pop    %esi
80104481:	5f                   	pop    %edi
80104482:	5d                   	pop    %ebp
80104483:	c3                   	ret    
80104484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104488:	31 d2                	xor    %edx,%edx
8010448a:	85 db                	test   %ebx,%ebx
8010448c:	74 f1                	je     8010447f <memmove+0x3f>
8010448e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104490:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104494:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104497:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010449a:	39 da                	cmp    %ebx,%edx
8010449c:	75 f2                	jne    80104490 <memmove+0x50>
}
8010449e:	5b                   	pop    %ebx
8010449f:	5e                   	pop    %esi
801044a0:	5f                   	pop    %edi
801044a1:	5d                   	pop    %ebp
801044a2:	c3                   	ret    
801044a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801044b3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801044b4:	eb 8a                	jmp    80104440 <memmove>
801044b6:	8d 76 00             	lea    0x0(%esi),%esi
801044b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044c0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	56                   	push   %esi
801044c4:	8b 75 10             	mov    0x10(%ebp),%esi
801044c7:	53                   	push   %ebx
801044c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801044cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801044ce:	85 f6                	test   %esi,%esi
801044d0:	74 30                	je     80104502 <strncmp+0x42>
801044d2:	0f b6 01             	movzbl (%ecx),%eax
801044d5:	84 c0                	test   %al,%al
801044d7:	74 2f                	je     80104508 <strncmp+0x48>
801044d9:	0f b6 13             	movzbl (%ebx),%edx
801044dc:	38 d0                	cmp    %dl,%al
801044de:	75 46                	jne    80104526 <strncmp+0x66>
801044e0:	8d 51 01             	lea    0x1(%ecx),%edx
801044e3:	01 ce                	add    %ecx,%esi
801044e5:	eb 14                	jmp    801044fb <strncmp+0x3b>
801044e7:	90                   	nop
801044e8:	0f b6 02             	movzbl (%edx),%eax
801044eb:	84 c0                	test   %al,%al
801044ed:	74 31                	je     80104520 <strncmp+0x60>
801044ef:	0f b6 19             	movzbl (%ecx),%ebx
801044f2:	83 c2 01             	add    $0x1,%edx
801044f5:	38 d8                	cmp    %bl,%al
801044f7:	75 17                	jne    80104510 <strncmp+0x50>
    n--, p++, q++;
801044f9:	89 cb                	mov    %ecx,%ebx
  while(n > 0 && *p && *p == *q)
801044fb:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801044fd:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(n > 0 && *p && *p == *q)
80104500:	75 e6                	jne    801044e8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104502:	5b                   	pop    %ebx
    return 0;
80104503:	31 c0                	xor    %eax,%eax
}
80104505:	5e                   	pop    %esi
80104506:	5d                   	pop    %ebp
80104507:	c3                   	ret    
80104508:	0f b6 1b             	movzbl (%ebx),%ebx
  while(n > 0 && *p && *p == *q)
8010450b:	31 c0                	xor    %eax,%eax
8010450d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
80104510:	0f b6 d3             	movzbl %bl,%edx
80104513:	29 d0                	sub    %edx,%eax
}
80104515:	5b                   	pop    %ebx
80104516:	5e                   	pop    %esi
80104517:	5d                   	pop    %ebp
80104518:	c3                   	ret    
80104519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104520:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104524:	eb ea                	jmp    80104510 <strncmp+0x50>
  while(n > 0 && *p && *p == *q)
80104526:	89 d3                	mov    %edx,%ebx
80104528:	eb e6                	jmp    80104510 <strncmp+0x50>
8010452a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104530 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	8b 45 08             	mov    0x8(%ebp),%eax
80104536:	56                   	push   %esi
80104537:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010453a:	53                   	push   %ebx
8010453b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010453e:	89 c2                	mov    %eax,%edx
80104540:	eb 19                	jmp    8010455b <strncpy+0x2b>
80104542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104548:	83 c3 01             	add    $0x1,%ebx
8010454b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010454f:	83 c2 01             	add    $0x1,%edx
80104552:	84 c9                	test   %cl,%cl
80104554:	88 4a ff             	mov    %cl,-0x1(%edx)
80104557:	74 09                	je     80104562 <strncpy+0x32>
80104559:	89 f1                	mov    %esi,%ecx
8010455b:	85 c9                	test   %ecx,%ecx
8010455d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104560:	7f e6                	jg     80104548 <strncpy+0x18>
    ;
  while(n-- > 0)
80104562:	31 c9                	xor    %ecx,%ecx
80104564:	85 f6                	test   %esi,%esi
80104566:	7e 0f                	jle    80104577 <strncpy+0x47>
    *s++ = 0;
80104568:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010456c:	89 f3                	mov    %esi,%ebx
8010456e:	83 c1 01             	add    $0x1,%ecx
80104571:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104573:	85 db                	test   %ebx,%ebx
80104575:	7f f1                	jg     80104568 <strncpy+0x38>
  return os;
}
80104577:	5b                   	pop    %ebx
80104578:	5e                   	pop    %esi
80104579:	5d                   	pop    %ebp
8010457a:	c3                   	ret    
8010457b:	90                   	nop
8010457c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104580 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104586:	56                   	push   %esi
80104587:	8b 45 08             	mov    0x8(%ebp),%eax
8010458a:	53                   	push   %ebx
8010458b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010458e:	85 c9                	test   %ecx,%ecx
80104590:	7e 26                	jle    801045b8 <safestrcpy+0x38>
80104592:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104596:	89 c1                	mov    %eax,%ecx
80104598:	eb 17                	jmp    801045b1 <safestrcpy+0x31>
8010459a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801045a0:	83 c2 01             	add    $0x1,%edx
801045a3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801045a7:	83 c1 01             	add    $0x1,%ecx
801045aa:	84 db                	test   %bl,%bl
801045ac:	88 59 ff             	mov    %bl,-0x1(%ecx)
801045af:	74 04                	je     801045b5 <safestrcpy+0x35>
801045b1:	39 f2                	cmp    %esi,%edx
801045b3:	75 eb                	jne    801045a0 <safestrcpy+0x20>
    ;
  *s = 0;
801045b5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801045b8:	5b                   	pop    %ebx
801045b9:	5e                   	pop    %esi
801045ba:	5d                   	pop    %ebp
801045bb:	c3                   	ret    
801045bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045c0 <strlen>:

int
strlen(const char *s)
{
801045c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801045c1:	31 c0                	xor    %eax,%eax
{
801045c3:	89 e5                	mov    %esp,%ebp
801045c5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801045c8:	80 3a 00             	cmpb   $0x0,(%edx)
801045cb:	74 0c                	je     801045d9 <strlen+0x19>
801045cd:	8d 76 00             	lea    0x0(%esi),%esi
801045d0:	83 c0 01             	add    $0x1,%eax
801045d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801045d7:	75 f7                	jne    801045d0 <strlen+0x10>
    ;
  return n;
}
801045d9:	5d                   	pop    %ebp
801045da:	c3                   	ret    

801045db <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801045db:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801045df:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801045e3:	55                   	push   %ebp
  pushl %ebx
801045e4:	53                   	push   %ebx
  pushl %esi
801045e5:	56                   	push   %esi
  pushl %edi
801045e6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801045e7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801045e9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801045eb:	5f                   	pop    %edi
  popl %esi
801045ec:	5e                   	pop    %esi
  popl %ebx
801045ed:	5b                   	pop    %ebx
  popl %ebp
801045ee:	5d                   	pop    %ebp
  ret
801045ef:	c3                   	ret    

801045f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	53                   	push   %ebx
801045f4:	83 ec 04             	sub    $0x4,%esp
801045f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801045fa:	e8 c1 f0 ff ff       	call   801036c0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801045ff:	8b 00                	mov    (%eax),%eax
80104601:	39 d8                	cmp    %ebx,%eax
80104603:	76 1b                	jbe    80104620 <fetchint+0x30>
80104605:	8d 53 04             	lea    0x4(%ebx),%edx
80104608:	39 d0                	cmp    %edx,%eax
8010460a:	72 14                	jb     80104620 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010460c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010460f:	8b 13                	mov    (%ebx),%edx
80104611:	89 10                	mov    %edx,(%eax)
  return 0;
80104613:	31 c0                	xor    %eax,%eax
}
80104615:	83 c4 04             	add    $0x4,%esp
80104618:	5b                   	pop    %ebx
80104619:	5d                   	pop    %ebp
8010461a:	c3                   	ret    
8010461b:	90                   	nop
8010461c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104625:	eb ee                	jmp    80104615 <fetchint+0x25>
80104627:	89 f6                	mov    %esi,%esi
80104629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104630 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	53                   	push   %ebx
80104634:	83 ec 04             	sub    $0x4,%esp
80104637:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010463a:	e8 81 f0 ff ff       	call   801036c0 <myproc>

  if(addr >= curproc->sz)
8010463f:	39 18                	cmp    %ebx,(%eax)
80104641:	76 26                	jbe    80104669 <fetchstr+0x39>
    return -1;
  *pp = (char*)addr;
80104643:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104646:	89 da                	mov    %ebx,%edx
80104648:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010464a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010464c:	39 c3                	cmp    %eax,%ebx
8010464e:	73 19                	jae    80104669 <fetchstr+0x39>
    if(*s == 0)
80104650:	80 3b 00             	cmpb   $0x0,(%ebx)
80104653:	75 0d                	jne    80104662 <fetchstr+0x32>
80104655:	eb 21                	jmp    80104678 <fetchstr+0x48>
80104657:	90                   	nop
80104658:	80 3a 00             	cmpb   $0x0,(%edx)
8010465b:	90                   	nop
8010465c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104660:	74 16                	je     80104678 <fetchstr+0x48>
  for(s = *pp; s < ep; s++){
80104662:	83 c2 01             	add    $0x1,%edx
80104665:	39 d0                	cmp    %edx,%eax
80104667:	77 ef                	ja     80104658 <fetchstr+0x28>
      return s - *pp;
  }
  return -1;
}
80104669:	83 c4 04             	add    $0x4,%esp
    return -1;
8010466c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104671:	5b                   	pop    %ebx
80104672:	5d                   	pop    %ebp
80104673:	c3                   	ret    
80104674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104678:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010467b:	89 d0                	mov    %edx,%eax
8010467d:	29 d8                	sub    %ebx,%eax
}
8010467f:	5b                   	pop    %ebx
80104680:	5d                   	pop    %ebp
80104681:	c3                   	ret    
80104682:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104690 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	56                   	push   %esi
80104694:	8b 75 0c             	mov    0xc(%ebp),%esi
80104697:	53                   	push   %ebx
80104698:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010469b:	e8 20 f0 ff ff       	call   801036c0 <myproc>
801046a0:	89 75 0c             	mov    %esi,0xc(%ebp)
801046a3:	8b 40 18             	mov    0x18(%eax),%eax
801046a6:	8b 40 44             	mov    0x44(%eax),%eax
801046a9:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
801046ad:	89 45 08             	mov    %eax,0x8(%ebp)
}
801046b0:	5b                   	pop    %ebx
801046b1:	5e                   	pop    %esi
801046b2:	5d                   	pop    %ebp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801046b3:	e9 38 ff ff ff       	jmp    801045f0 <fetchint>
801046b8:	90                   	nop
801046b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046c0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	56                   	push   %esi
801046c4:	53                   	push   %ebx
801046c5:	83 ec 20             	sub    $0x20,%esp
801046c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801046cb:	e8 f0 ef ff ff       	call   801036c0 <myproc>
801046d0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801046d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801046d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801046d9:	8b 45 08             	mov    0x8(%ebp),%eax
801046dc:	89 04 24             	mov    %eax,(%esp)
801046df:	e8 ac ff ff ff       	call   80104690 <argint>
801046e4:	85 c0                	test   %eax,%eax
801046e6:	78 28                	js     80104710 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801046e8:	85 db                	test   %ebx,%ebx
801046ea:	78 24                	js     80104710 <argptr+0x50>
801046ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
801046ef:	8b 06                	mov    (%esi),%eax
801046f1:	39 c2                	cmp    %eax,%edx
801046f3:	73 1b                	jae    80104710 <argptr+0x50>
801046f5:	01 d3                	add    %edx,%ebx
801046f7:	39 d8                	cmp    %ebx,%eax
801046f9:	72 15                	jb     80104710 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801046fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801046fe:	89 10                	mov    %edx,(%eax)
  return 0;
}
80104700:	83 c4 20             	add    $0x20,%esp
  return 0;
80104703:	31 c0                	xor    %eax,%eax
}
80104705:	5b                   	pop    %ebx
80104706:	5e                   	pop    %esi
80104707:	5d                   	pop    %ebp
80104708:	c3                   	ret    
80104709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104710:	83 c4 20             	add    $0x20,%esp
    return -1;
80104713:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104718:	5b                   	pop    %ebx
80104719:	5e                   	pop    %esi
8010471a:	5d                   	pop    %ebp
8010471b:	c3                   	ret    
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104720 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104726:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104729:	89 44 24 04          	mov    %eax,0x4(%esp)
8010472d:	8b 45 08             	mov    0x8(%ebp),%eax
80104730:	89 04 24             	mov    %eax,(%esp)
80104733:	e8 58 ff ff ff       	call   80104690 <argint>
80104738:	85 c0                	test   %eax,%eax
8010473a:	78 14                	js     80104750 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010473c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010473f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104743:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104746:	89 04 24             	mov    %eax,(%esp)
80104749:	e8 e2 fe ff ff       	call   80104630 <fetchstr>
}
8010474e:	c9                   	leave  
8010474f:	c3                   	ret    
    return -1;
80104750:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104755:	c9                   	leave  
80104756:	c3                   	ret    
80104757:	89 f6                	mov    %esi,%esi
80104759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104760 <syscall>:
[SYS_setpriority] sys_setpriority,
};

void
syscall(void)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	56                   	push   %esi
80104764:	53                   	push   %ebx
80104765:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104768:	e8 53 ef ff ff       	call   801036c0 <myproc>

  num = curproc->tf->eax;
8010476d:	8b 70 18             	mov    0x18(%eax),%esi
  struct proc *curproc = myproc();
80104770:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80104772:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104775:	8d 50 ff             	lea    -0x1(%eax),%edx
80104778:	83 fa 15             	cmp    $0x15,%edx
8010477b:	77 1b                	ja     80104798 <syscall+0x38>
8010477d:	8b 14 85 20 74 10 80 	mov    -0x7fef8be0(,%eax,4),%edx
80104784:	85 d2                	test   %edx,%edx
80104786:	74 10                	je     80104798 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104788:	ff d2                	call   *%edx
8010478a:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010478d:	83 c4 10             	add    $0x10,%esp
80104790:	5b                   	pop    %ebx
80104791:	5e                   	pop    %esi
80104792:	5d                   	pop    %ebp
80104793:	c3                   	ret    
80104794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104798:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
8010479c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010479f:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
801047a3:	8b 43 10             	mov    0x10(%ebx),%eax
801047a6:	c7 04 24 f9 73 10 80 	movl   $0x801073f9,(%esp)
801047ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801047b1:	e8 9a be ff ff       	call   80100650 <cprintf>
    curproc->tf->eax = -1;
801047b6:	8b 43 18             	mov    0x18(%ebx),%eax
801047b9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801047c0:	83 c4 10             	add    $0x10,%esp
801047c3:	5b                   	pop    %ebx
801047c4:	5e                   	pop    %esi
801047c5:	5d                   	pop    %ebp
801047c6:	c3                   	ret    
801047c7:	66 90                	xchg   %ax,%ax
801047c9:	66 90                	xchg   %ax,%ax
801047cb:	66 90                	xchg   %ax,%ax
801047cd:	66 90                	xchg   %ax,%ax
801047cf:	90                   	nop

801047d0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	53                   	push   %ebx
801047d4:	89 c3                	mov    %eax,%ebx
801047d6:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
801047d9:	e8 e2 ee ff ff       	call   801036c0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801047de:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
801047e0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801047e4:	85 c9                	test   %ecx,%ecx
801047e6:	74 18                	je     80104800 <fdalloc+0x30>
  for(fd = 0; fd < NOFILE; fd++){
801047e8:	83 c2 01             	add    $0x1,%edx
801047eb:	83 fa 10             	cmp    $0x10,%edx
801047ee:	75 f0                	jne    801047e0 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
801047f0:	83 c4 04             	add    $0x4,%esp
  return -1;
801047f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801047f8:	5b                   	pop    %ebx
801047f9:	5d                   	pop    %ebp
801047fa:	c3                   	ret    
801047fb:	90                   	nop
801047fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80104800:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
80104804:	83 c4 04             	add    $0x4,%esp
      return fd;
80104807:	89 d0                	mov    %edx,%eax
}
80104809:	5b                   	pop    %ebx
8010480a:	5d                   	pop    %ebp
8010480b:	c3                   	ret    
8010480c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104810 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	57                   	push   %edi
80104814:	56                   	push   %esi
80104815:	53                   	push   %ebx
80104816:	83 ec 3c             	sub    $0x3c,%esp
80104819:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010481c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010481f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104822:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104826:	89 04 24             	mov    %eax,(%esp)
{
80104829:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010482c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010482f:	e8 fc d6 ff ff       	call   80101f30 <nameiparent>
80104834:	85 c0                	test   %eax,%eax
80104836:	89 c7                	mov    %eax,%edi
80104838:	0f 84 da 00 00 00    	je     80104918 <create+0x108>
    return 0;
  ilock(dp);
8010483e:	89 04 24             	mov    %eax,(%esp)
80104841:	e8 7a ce ff ff       	call   801016c0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104846:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010484d:	00 
8010484e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104852:	89 3c 24             	mov    %edi,(%esp)
80104855:	e8 76 d3 ff ff       	call   80101bd0 <dirlookup>
8010485a:	85 c0                	test   %eax,%eax
8010485c:	89 c6                	mov    %eax,%esi
8010485e:	74 40                	je     801048a0 <create+0x90>
    iunlockput(dp);
80104860:	89 3c 24             	mov    %edi,(%esp)
80104863:	e8 b8 d0 ff ff       	call   80101920 <iunlockput>
    ilock(ip);
80104868:	89 34 24             	mov    %esi,(%esp)
8010486b:	e8 50 ce ff ff       	call   801016c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104870:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104875:	75 11                	jne    80104888 <create+0x78>
80104877:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010487c:	89 f0                	mov    %esi,%eax
8010487e:	75 08                	jne    80104888 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104880:	83 c4 3c             	add    $0x3c,%esp
80104883:	5b                   	pop    %ebx
80104884:	5e                   	pop    %esi
80104885:	5f                   	pop    %edi
80104886:	5d                   	pop    %ebp
80104887:	c3                   	ret    
    iunlockput(ip);
80104888:	89 34 24             	mov    %esi,(%esp)
8010488b:	e8 90 d0 ff ff       	call   80101920 <iunlockput>
}
80104890:	83 c4 3c             	add    $0x3c,%esp
    return 0;
80104893:	31 c0                	xor    %eax,%eax
}
80104895:	5b                   	pop    %ebx
80104896:	5e                   	pop    %esi
80104897:	5f                   	pop    %edi
80104898:	5d                   	pop    %ebp
80104899:	c3                   	ret    
8010489a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
801048a0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801048a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801048a8:	8b 07                	mov    (%edi),%eax
801048aa:	89 04 24             	mov    %eax,(%esp)
801048ad:	e8 7e cc ff ff       	call   80101530 <ialloc>
801048b2:	85 c0                	test   %eax,%eax
801048b4:	89 c6                	mov    %eax,%esi
801048b6:	0f 84 bf 00 00 00    	je     8010497b <create+0x16b>
  ilock(ip);
801048bc:	89 04 24             	mov    %eax,(%esp)
801048bf:	e8 fc cd ff ff       	call   801016c0 <ilock>
  ip->major = major;
801048c4:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801048c8:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
801048cc:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801048d0:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801048d4:	b8 01 00 00 00       	mov    $0x1,%eax
801048d9:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801048dd:	89 34 24             	mov    %esi,(%esp)
801048e0:	e8 1b cd ff ff       	call   80101600 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801048e5:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801048ea:	74 34                	je     80104920 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
801048ec:	8b 46 04             	mov    0x4(%esi),%eax
801048ef:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801048f3:	89 3c 24             	mov    %edi,(%esp)
801048f6:	89 44 24 08          	mov    %eax,0x8(%esp)
801048fa:	e8 31 d5 ff ff       	call   80101e30 <dirlink>
801048ff:	85 c0                	test   %eax,%eax
80104901:	78 6c                	js     8010496f <create+0x15f>
  iunlockput(dp);
80104903:	89 3c 24             	mov    %edi,(%esp)
80104906:	e8 15 d0 ff ff       	call   80101920 <iunlockput>
}
8010490b:	83 c4 3c             	add    $0x3c,%esp
  return ip;
8010490e:	89 f0                	mov    %esi,%eax
}
80104910:	5b                   	pop    %ebx
80104911:	5e                   	pop    %esi
80104912:	5f                   	pop    %edi
80104913:	5d                   	pop    %ebp
80104914:	c3                   	ret    
80104915:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
80104918:	31 c0                	xor    %eax,%eax
8010491a:	e9 61 ff ff ff       	jmp    80104880 <create+0x70>
8010491f:	90                   	nop
    dp->nlink++;  // for ".."
80104920:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104925:	89 3c 24             	mov    %edi,(%esp)
80104928:	e8 d3 cc ff ff       	call   80101600 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010492d:	8b 46 04             	mov    0x4(%esi),%eax
80104930:	c7 44 24 04 98 74 10 	movl   $0x80107498,0x4(%esp)
80104937:	80 
80104938:	89 34 24             	mov    %esi,(%esp)
8010493b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010493f:	e8 ec d4 ff ff       	call   80101e30 <dirlink>
80104944:	85 c0                	test   %eax,%eax
80104946:	78 1b                	js     80104963 <create+0x153>
80104948:	8b 47 04             	mov    0x4(%edi),%eax
8010494b:	c7 44 24 04 97 74 10 	movl   $0x80107497,0x4(%esp)
80104952:	80 
80104953:	89 34 24             	mov    %esi,(%esp)
80104956:	89 44 24 08          	mov    %eax,0x8(%esp)
8010495a:	e8 d1 d4 ff ff       	call   80101e30 <dirlink>
8010495f:	85 c0                	test   %eax,%eax
80104961:	79 89                	jns    801048ec <create+0xdc>
      panic("create dots");
80104963:	c7 04 24 8b 74 10 80 	movl   $0x8010748b,(%esp)
8010496a:	e8 f1 b9 ff ff       	call   80100360 <panic>
    panic("create: dirlink");
8010496f:	c7 04 24 9a 74 10 80 	movl   $0x8010749a,(%esp)
80104976:	e8 e5 b9 ff ff       	call   80100360 <panic>
    panic("create: ialloc");
8010497b:	c7 04 24 7c 74 10 80 	movl   $0x8010747c,(%esp)
80104982:	e8 d9 b9 ff ff       	call   80100360 <panic>
80104987:	89 f6                	mov    %esi,%esi
80104989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104990 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	56                   	push   %esi
80104994:	89 c6                	mov    %eax,%esi
80104996:	53                   	push   %ebx
80104997:	89 d3                	mov    %edx,%ebx
80104999:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
8010499c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010499f:	89 44 24 04          	mov    %eax,0x4(%esp)
801049a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801049aa:	e8 e1 fc ff ff       	call   80104690 <argint>
801049af:	85 c0                	test   %eax,%eax
801049b1:	78 2d                	js     801049e0 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801049b3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801049b7:	77 27                	ja     801049e0 <argfd.constprop.0+0x50>
801049b9:	e8 02 ed ff ff       	call   801036c0 <myproc>
801049be:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049c1:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801049c5:	85 c0                	test   %eax,%eax
801049c7:	74 17                	je     801049e0 <argfd.constprop.0+0x50>
  if(pfd)
801049c9:	85 f6                	test   %esi,%esi
801049cb:	74 02                	je     801049cf <argfd.constprop.0+0x3f>
    *pfd = fd;
801049cd:	89 16                	mov    %edx,(%esi)
  if(pf)
801049cf:	85 db                	test   %ebx,%ebx
801049d1:	74 1d                	je     801049f0 <argfd.constprop.0+0x60>
    *pf = f;
801049d3:	89 03                	mov    %eax,(%ebx)
  return 0;
801049d5:	31 c0                	xor    %eax,%eax
}
801049d7:	83 c4 20             	add    $0x20,%esp
801049da:	5b                   	pop    %ebx
801049db:	5e                   	pop    %esi
801049dc:	5d                   	pop    %ebp
801049dd:	c3                   	ret    
801049de:	66 90                	xchg   %ax,%ax
801049e0:	83 c4 20             	add    $0x20,%esp
    return -1;
801049e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049e8:	5b                   	pop    %ebx
801049e9:	5e                   	pop    %esi
801049ea:	5d                   	pop    %ebp
801049eb:	c3                   	ret    
801049ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
801049f0:	31 c0                	xor    %eax,%eax
801049f2:	eb e3                	jmp    801049d7 <argfd.constprop.0+0x47>
801049f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104a00 <sys_dup>:
{
80104a00:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104a01:	31 c0                	xor    %eax,%eax
{
80104a03:	89 e5                	mov    %esp,%ebp
80104a05:	53                   	push   %ebx
80104a06:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
80104a09:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104a0c:	e8 7f ff ff ff       	call   80104990 <argfd.constprop.0>
80104a11:	85 c0                	test   %eax,%eax
80104a13:	78 23                	js     80104a38 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a18:	e8 b3 fd ff ff       	call   801047d0 <fdalloc>
80104a1d:	85 c0                	test   %eax,%eax
80104a1f:	89 c3                	mov    %eax,%ebx
80104a21:	78 15                	js     80104a38 <sys_dup+0x38>
  filedup(f);
80104a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a26:	89 04 24             	mov    %eax,(%esp)
80104a29:	e8 c2 c3 ff ff       	call   80100df0 <filedup>
  return fd;
80104a2e:	89 d8                	mov    %ebx,%eax
}
80104a30:	83 c4 24             	add    $0x24,%esp
80104a33:	5b                   	pop    %ebx
80104a34:	5d                   	pop    %ebp
80104a35:	c3                   	ret    
80104a36:	66 90                	xchg   %ax,%ax
    return -1;
80104a38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a3d:	eb f1                	jmp    80104a30 <sys_dup+0x30>
80104a3f:	90                   	nop

80104a40 <sys_read>:
{
80104a40:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a41:	31 c0                	xor    %eax,%eax
{
80104a43:	89 e5                	mov    %esp,%ebp
80104a45:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a48:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104a4b:	e8 40 ff ff ff       	call   80104990 <argfd.constprop.0>
80104a50:	85 c0                	test   %eax,%eax
80104a52:	78 54                	js     80104aa8 <sys_read+0x68>
80104a54:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a57:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a5b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104a62:	e8 29 fc ff ff       	call   80104690 <argint>
80104a67:	85 c0                	test   %eax,%eax
80104a69:	78 3d                	js     80104aa8 <sys_read+0x68>
80104a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a6e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a75:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a80:	e8 3b fc ff ff       	call   801046c0 <argptr>
80104a85:	85 c0                	test   %eax,%eax
80104a87:	78 1f                	js     80104aa8 <sys_read+0x68>
  return fileread(f, p, n);
80104a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a8c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a93:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a97:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a9a:	89 04 24             	mov    %eax,(%esp)
80104a9d:	e8 ae c4 ff ff       	call   80100f50 <fileread>
}
80104aa2:	c9                   	leave  
80104aa3:	c3                   	ret    
80104aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104aa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104aad:	c9                   	leave  
80104aae:	c3                   	ret    
80104aaf:	90                   	nop

80104ab0 <sys_write>:
{
80104ab0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ab1:	31 c0                	xor    %eax,%eax
{
80104ab3:	89 e5                	mov    %esp,%ebp
80104ab5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ab8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104abb:	e8 d0 fe ff ff       	call   80104990 <argfd.constprop.0>
80104ac0:	85 c0                	test   %eax,%eax
80104ac2:	78 54                	js     80104b18 <sys_write+0x68>
80104ac4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ac7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104acb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104ad2:	e8 b9 fb ff ff       	call   80104690 <argint>
80104ad7:	85 c0                	test   %eax,%eax
80104ad9:	78 3d                	js     80104b18 <sys_write+0x68>
80104adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ade:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ae5:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ae9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104aec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104af0:	e8 cb fb ff ff       	call   801046c0 <argptr>
80104af5:	85 c0                	test   %eax,%eax
80104af7:	78 1f                	js     80104b18 <sys_write+0x68>
  return filewrite(f, p, n);
80104af9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104afc:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b03:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b07:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b0a:	89 04 24             	mov    %eax,(%esp)
80104b0d:	e8 de c4 ff ff       	call   80100ff0 <filewrite>
}
80104b12:	c9                   	leave  
80104b13:	c3                   	ret    
80104b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b1d:	c9                   	leave  
80104b1e:	c3                   	ret    
80104b1f:	90                   	nop

80104b20 <sys_close>:
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
80104b26:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104b29:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b2c:	e8 5f fe ff ff       	call   80104990 <argfd.constprop.0>
80104b31:	85 c0                	test   %eax,%eax
80104b33:	78 23                	js     80104b58 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
80104b35:	e8 86 eb ff ff       	call   801036c0 <myproc>
80104b3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104b3d:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104b44:	00 
  fileclose(f);
80104b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b48:	89 04 24             	mov    %eax,(%esp)
80104b4b:	e8 f0 c2 ff ff       	call   80100e40 <fileclose>
  return 0;
80104b50:	31 c0                	xor    %eax,%eax
}
80104b52:	c9                   	leave  
80104b53:	c3                   	ret    
80104b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b5d:	c9                   	leave  
80104b5e:	c3                   	ret    
80104b5f:	90                   	nop

80104b60 <sys_fstat>:
{
80104b60:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b61:	31 c0                	xor    %eax,%eax
{
80104b63:	89 e5                	mov    %esp,%ebp
80104b65:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b68:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104b6b:	e8 20 fe ff ff       	call   80104990 <argfd.constprop.0>
80104b70:	85 c0                	test   %eax,%eax
80104b72:	78 34                	js     80104ba8 <sys_fstat+0x48>
80104b74:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b77:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104b7e:	00 
80104b7f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b83:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b8a:	e8 31 fb ff ff       	call   801046c0 <argptr>
80104b8f:	85 c0                	test   %eax,%eax
80104b91:	78 15                	js     80104ba8 <sys_fstat+0x48>
  return filestat(f, st);
80104b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b96:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b9d:	89 04 24             	mov    %eax,(%esp)
80104ba0:	e8 5b c3 ff ff       	call   80100f00 <filestat>
}
80104ba5:	c9                   	leave  
80104ba6:	c3                   	ret    
80104ba7:	90                   	nop
    return -1;
80104ba8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bad:	c9                   	leave  
80104bae:	c3                   	ret    
80104baf:	90                   	nop

80104bb0 <sys_link>:
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	57                   	push   %edi
80104bb4:	56                   	push   %esi
80104bb5:	53                   	push   %ebx
80104bb6:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104bb9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bc0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104bc7:	e8 54 fb ff ff       	call   80104720 <argstr>
80104bcc:	85 c0                	test   %eax,%eax
80104bce:	0f 88 e6 00 00 00    	js     80104cba <sys_link+0x10a>
80104bd4:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bdb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104be2:	e8 39 fb ff ff       	call   80104720 <argstr>
80104be7:	85 c0                	test   %eax,%eax
80104be9:	0f 88 cb 00 00 00    	js     80104cba <sys_link+0x10a>
  begin_op();
80104bef:	e8 2c df ff ff       	call   80102b20 <begin_op>
  if((ip = namei(old)) == 0){
80104bf4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104bf7:	89 04 24             	mov    %eax,(%esp)
80104bfa:	e8 11 d3 ff ff       	call   80101f10 <namei>
80104bff:	85 c0                	test   %eax,%eax
80104c01:	89 c3                	mov    %eax,%ebx
80104c03:	0f 84 ac 00 00 00    	je     80104cb5 <sys_link+0x105>
  ilock(ip);
80104c09:	89 04 24             	mov    %eax,(%esp)
80104c0c:	e8 af ca ff ff       	call   801016c0 <ilock>
  if(ip->type == T_DIR){
80104c11:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c16:	0f 84 91 00 00 00    	je     80104cad <sys_link+0xfd>
  ip->nlink++;
80104c1c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104c21:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104c24:	89 1c 24             	mov    %ebx,(%esp)
80104c27:	e8 d4 c9 ff ff       	call   80101600 <iupdate>
  iunlock(ip);
80104c2c:	89 1c 24             	mov    %ebx,(%esp)
80104c2f:	e8 6c cb ff ff       	call   801017a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104c34:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104c37:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c3b:	89 04 24             	mov    %eax,(%esp)
80104c3e:	e8 ed d2 ff ff       	call   80101f30 <nameiparent>
80104c43:	85 c0                	test   %eax,%eax
80104c45:	89 c6                	mov    %eax,%esi
80104c47:	74 4f                	je     80104c98 <sys_link+0xe8>
  ilock(dp);
80104c49:	89 04 24             	mov    %eax,(%esp)
80104c4c:	e8 6f ca ff ff       	call   801016c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104c51:	8b 03                	mov    (%ebx),%eax
80104c53:	39 06                	cmp    %eax,(%esi)
80104c55:	75 39                	jne    80104c90 <sys_link+0xe0>
80104c57:	8b 43 04             	mov    0x4(%ebx),%eax
80104c5a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104c5e:	89 34 24             	mov    %esi,(%esp)
80104c61:	89 44 24 08          	mov    %eax,0x8(%esp)
80104c65:	e8 c6 d1 ff ff       	call   80101e30 <dirlink>
80104c6a:	85 c0                	test   %eax,%eax
80104c6c:	78 22                	js     80104c90 <sys_link+0xe0>
  iunlockput(dp);
80104c6e:	89 34 24             	mov    %esi,(%esp)
80104c71:	e8 aa cc ff ff       	call   80101920 <iunlockput>
  iput(ip);
80104c76:	89 1c 24             	mov    %ebx,(%esp)
80104c79:	e8 62 cb ff ff       	call   801017e0 <iput>
  end_op();
80104c7e:	e8 0d df ff ff       	call   80102b90 <end_op>
}
80104c83:	83 c4 3c             	add    $0x3c,%esp
  return 0;
80104c86:	31 c0                	xor    %eax,%eax
}
80104c88:	5b                   	pop    %ebx
80104c89:	5e                   	pop    %esi
80104c8a:	5f                   	pop    %edi
80104c8b:	5d                   	pop    %ebp
80104c8c:	c3                   	ret    
80104c8d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104c90:	89 34 24             	mov    %esi,(%esp)
80104c93:	e8 88 cc ff ff       	call   80101920 <iunlockput>
  ilock(ip);
80104c98:	89 1c 24             	mov    %ebx,(%esp)
80104c9b:	e8 20 ca ff ff       	call   801016c0 <ilock>
  ip->nlink--;
80104ca0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ca5:	89 1c 24             	mov    %ebx,(%esp)
80104ca8:	e8 53 c9 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
80104cad:	89 1c 24             	mov    %ebx,(%esp)
80104cb0:	e8 6b cc ff ff       	call   80101920 <iunlockput>
  end_op();
80104cb5:	e8 d6 de ff ff       	call   80102b90 <end_op>
}
80104cba:	83 c4 3c             	add    $0x3c,%esp
  return -1;
80104cbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cc2:	5b                   	pop    %ebx
80104cc3:	5e                   	pop    %esi
80104cc4:	5f                   	pop    %edi
80104cc5:	5d                   	pop    %ebp
80104cc6:	c3                   	ret    
80104cc7:	89 f6                	mov    %esi,%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cd0 <sys_unlink>:
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	57                   	push   %edi
80104cd4:	56                   	push   %esi
80104cd5:	53                   	push   %ebx
80104cd6:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
80104cd9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104cdc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ce0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ce7:	e8 34 fa ff ff       	call   80104720 <argstr>
80104cec:	85 c0                	test   %eax,%eax
80104cee:	0f 88 76 01 00 00    	js     80104e6a <sys_unlink+0x19a>
  begin_op();
80104cf4:	e8 27 de ff ff       	call   80102b20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104cf9:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104cfc:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104cff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d03:	89 04 24             	mov    %eax,(%esp)
80104d06:	e8 25 d2 ff ff       	call   80101f30 <nameiparent>
80104d0b:	85 c0                	test   %eax,%eax
80104d0d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104d10:	0f 84 4f 01 00 00    	je     80104e65 <sys_unlink+0x195>
  ilock(dp);
80104d16:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104d19:	89 34 24             	mov    %esi,(%esp)
80104d1c:	e8 9f c9 ff ff       	call   801016c0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104d21:	c7 44 24 04 98 74 10 	movl   $0x80107498,0x4(%esp)
80104d28:	80 
80104d29:	89 1c 24             	mov    %ebx,(%esp)
80104d2c:	e8 6f ce ff ff       	call   80101ba0 <namecmp>
80104d31:	85 c0                	test   %eax,%eax
80104d33:	0f 84 21 01 00 00    	je     80104e5a <sys_unlink+0x18a>
80104d39:	c7 44 24 04 97 74 10 	movl   $0x80107497,0x4(%esp)
80104d40:	80 
80104d41:	89 1c 24             	mov    %ebx,(%esp)
80104d44:	e8 57 ce ff ff       	call   80101ba0 <namecmp>
80104d49:	85 c0                	test   %eax,%eax
80104d4b:	0f 84 09 01 00 00    	je     80104e5a <sys_unlink+0x18a>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104d51:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104d54:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d58:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d5c:	89 34 24             	mov    %esi,(%esp)
80104d5f:	e8 6c ce ff ff       	call   80101bd0 <dirlookup>
80104d64:	85 c0                	test   %eax,%eax
80104d66:	89 c3                	mov    %eax,%ebx
80104d68:	0f 84 ec 00 00 00    	je     80104e5a <sys_unlink+0x18a>
  ilock(ip);
80104d6e:	89 04 24             	mov    %eax,(%esp)
80104d71:	e8 4a c9 ff ff       	call   801016c0 <ilock>
  if(ip->nlink < 1)
80104d76:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104d7b:	0f 8e 24 01 00 00    	jle    80104ea5 <sys_unlink+0x1d5>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104d81:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d86:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104d89:	74 7d                	je     80104e08 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
80104d8b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104d92:	00 
80104d93:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104d9a:	00 
80104d9b:	89 34 24             	mov    %esi,(%esp)
80104d9e:	e8 fd f5 ff ff       	call   801043a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104da3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104da6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104dad:	00 
80104dae:	89 74 24 04          	mov    %esi,0x4(%esp)
80104db2:	89 44 24 08          	mov    %eax,0x8(%esp)
80104db6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104db9:	89 04 24             	mov    %eax,(%esp)
80104dbc:	e8 af cc ff ff       	call   80101a70 <writei>
80104dc1:	83 f8 10             	cmp    $0x10,%eax
80104dc4:	0f 85 cf 00 00 00    	jne    80104e99 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80104dca:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104dcf:	0f 84 a3 00 00 00    	je     80104e78 <sys_unlink+0x1a8>
  iunlockput(dp);
80104dd5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104dd8:	89 04 24             	mov    %eax,(%esp)
80104ddb:	e8 40 cb ff ff       	call   80101920 <iunlockput>
  ip->nlink--;
80104de0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104de5:	89 1c 24             	mov    %ebx,(%esp)
80104de8:	e8 13 c8 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
80104ded:	89 1c 24             	mov    %ebx,(%esp)
80104df0:	e8 2b cb ff ff       	call   80101920 <iunlockput>
  end_op();
80104df5:	e8 96 dd ff ff       	call   80102b90 <end_op>
}
80104dfa:	83 c4 5c             	add    $0x5c,%esp
  return 0;
80104dfd:	31 c0                	xor    %eax,%eax
}
80104dff:	5b                   	pop    %ebx
80104e00:	5e                   	pop    %esi
80104e01:	5f                   	pop    %edi
80104e02:	5d                   	pop    %ebp
80104e03:	c3                   	ret    
80104e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104e08:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104e0c:	0f 86 79 ff ff ff    	jbe    80104d8b <sys_unlink+0xbb>
80104e12:	bf 20 00 00 00       	mov    $0x20,%edi
80104e17:	eb 15                	jmp    80104e2e <sys_unlink+0x15e>
80104e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e20:	8d 57 10             	lea    0x10(%edi),%edx
80104e23:	3b 53 58             	cmp    0x58(%ebx),%edx
80104e26:	0f 83 5f ff ff ff    	jae    80104d8b <sys_unlink+0xbb>
80104e2c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104e2e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104e35:	00 
80104e36:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104e3a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104e3e:	89 1c 24             	mov    %ebx,(%esp)
80104e41:	e8 2a cb ff ff       	call   80101970 <readi>
80104e46:	83 f8 10             	cmp    $0x10,%eax
80104e49:	75 42                	jne    80104e8d <sys_unlink+0x1bd>
    if(de.inum != 0)
80104e4b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104e50:	74 ce                	je     80104e20 <sys_unlink+0x150>
    iunlockput(ip);
80104e52:	89 1c 24             	mov    %ebx,(%esp)
80104e55:	e8 c6 ca ff ff       	call   80101920 <iunlockput>
  iunlockput(dp);
80104e5a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e5d:	89 04 24             	mov    %eax,(%esp)
80104e60:	e8 bb ca ff ff       	call   80101920 <iunlockput>
  end_op();
80104e65:	e8 26 dd ff ff       	call   80102b90 <end_op>
}
80104e6a:	83 c4 5c             	add    $0x5c,%esp
  return -1;
80104e6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e72:	5b                   	pop    %ebx
80104e73:	5e                   	pop    %esi
80104e74:	5f                   	pop    %edi
80104e75:	5d                   	pop    %ebp
80104e76:	c3                   	ret    
80104e77:	90                   	nop
    dp->nlink--;
80104e78:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e7b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104e80:	89 04 24             	mov    %eax,(%esp)
80104e83:	e8 78 c7 ff ff       	call   80101600 <iupdate>
80104e88:	e9 48 ff ff ff       	jmp    80104dd5 <sys_unlink+0x105>
      panic("isdirempty: readi");
80104e8d:	c7 04 24 bc 74 10 80 	movl   $0x801074bc,(%esp)
80104e94:	e8 c7 b4 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
80104e99:	c7 04 24 ce 74 10 80 	movl   $0x801074ce,(%esp)
80104ea0:	e8 bb b4 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
80104ea5:	c7 04 24 aa 74 10 80 	movl   $0x801074aa,(%esp)
80104eac:	e8 af b4 ff ff       	call   80100360 <panic>
80104eb1:	eb 0d                	jmp    80104ec0 <sys_open>
80104eb3:	90                   	nop
80104eb4:	90                   	nop
80104eb5:	90                   	nop
80104eb6:	90                   	nop
80104eb7:	90                   	nop
80104eb8:	90                   	nop
80104eb9:	90                   	nop
80104eba:	90                   	nop
80104ebb:	90                   	nop
80104ebc:	90                   	nop
80104ebd:	90                   	nop
80104ebe:	90                   	nop
80104ebf:	90                   	nop

80104ec0 <sys_open>:

int
sys_open(void)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	57                   	push   %edi
80104ec4:	56                   	push   %esi
80104ec5:	53                   	push   %ebx
80104ec6:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104ec9:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104ecc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ed0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ed7:	e8 44 f8 ff ff       	call   80104720 <argstr>
80104edc:	85 c0                	test   %eax,%eax
80104ede:	0f 88 d1 00 00 00    	js     80104fb5 <sys_open+0xf5>
80104ee4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104ee7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104eeb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ef2:	e8 99 f7 ff ff       	call   80104690 <argint>
80104ef7:	85 c0                	test   %eax,%eax
80104ef9:	0f 88 b6 00 00 00    	js     80104fb5 <sys_open+0xf5>
    return -1;

  begin_op();
80104eff:	e8 1c dc ff ff       	call   80102b20 <begin_op>

  if(omode & O_CREATE){
80104f04:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104f08:	0f 85 82 00 00 00    	jne    80104f90 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104f0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f11:	89 04 24             	mov    %eax,(%esp)
80104f14:	e8 f7 cf ff ff       	call   80101f10 <namei>
80104f19:	85 c0                	test   %eax,%eax
80104f1b:	89 c6                	mov    %eax,%esi
80104f1d:	0f 84 8d 00 00 00    	je     80104fb0 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104f23:	89 04 24             	mov    %eax,(%esp)
80104f26:	e8 95 c7 ff ff       	call   801016c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104f2b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104f30:	0f 84 92 00 00 00    	je     80104fc8 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104f36:	e8 45 be ff ff       	call   80100d80 <filealloc>
80104f3b:	85 c0                	test   %eax,%eax
80104f3d:	89 c3                	mov    %eax,%ebx
80104f3f:	0f 84 93 00 00 00    	je     80104fd8 <sys_open+0x118>
80104f45:	e8 86 f8 ff ff       	call   801047d0 <fdalloc>
80104f4a:	85 c0                	test   %eax,%eax
80104f4c:	89 c7                	mov    %eax,%edi
80104f4e:	0f 88 94 00 00 00    	js     80104fe8 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104f54:	89 34 24             	mov    %esi,(%esp)
80104f57:	e8 44 c8 ff ff       	call   801017a0 <iunlock>
  end_op();
80104f5c:	e8 2f dc ff ff       	call   80102b90 <end_op>

  f->type = FD_INODE;
80104f61:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104f67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->ip = ip;
80104f6a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104f6d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104f74:	89 c2                	mov    %eax,%edx
80104f76:	83 e2 01             	and    $0x1,%edx
80104f79:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104f7c:	a8 03                	test   $0x3,%al
  f->readable = !(omode & O_WRONLY);
80104f7e:	88 53 08             	mov    %dl,0x8(%ebx)
  return fd;
80104f81:	89 f8                	mov    %edi,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104f83:	0f 95 43 09          	setne  0x9(%ebx)
}
80104f87:	83 c4 2c             	add    $0x2c,%esp
80104f8a:	5b                   	pop    %ebx
80104f8b:	5e                   	pop    %esi
80104f8c:	5f                   	pop    %edi
80104f8d:	5d                   	pop    %ebp
80104f8e:	c3                   	ret    
80104f8f:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
80104f90:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104f93:	31 c9                	xor    %ecx,%ecx
80104f95:	ba 02 00 00 00       	mov    $0x2,%edx
80104f9a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fa1:	e8 6a f8 ff ff       	call   80104810 <create>
    if(ip == 0){
80104fa6:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80104fa8:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104faa:	75 8a                	jne    80104f36 <sys_open+0x76>
80104fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80104fb0:	e8 db db ff ff       	call   80102b90 <end_op>
}
80104fb5:	83 c4 2c             	add    $0x2c,%esp
    return -1;
80104fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fbd:	5b                   	pop    %ebx
80104fbe:	5e                   	pop    %esi
80104fbf:	5f                   	pop    %edi
80104fc0:	5d                   	pop    %ebp
80104fc1:	c3                   	ret    
80104fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80104fc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104fcb:	85 c0                	test   %eax,%eax
80104fcd:	0f 84 63 ff ff ff    	je     80104f36 <sys_open+0x76>
80104fd3:	90                   	nop
80104fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80104fd8:	89 34 24             	mov    %esi,(%esp)
80104fdb:	e8 40 c9 ff ff       	call   80101920 <iunlockput>
80104fe0:	eb ce                	jmp    80104fb0 <sys_open+0xf0>
80104fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      fileclose(f);
80104fe8:	89 1c 24             	mov    %ebx,(%esp)
80104feb:	e8 50 be ff ff       	call   80100e40 <fileclose>
80104ff0:	eb e6                	jmp    80104fd8 <sys_open+0x118>
80104ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105000 <sys_mkdir>:

int
sys_mkdir(void)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105006:	e8 15 db ff ff       	call   80102b20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010500b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010500e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105012:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105019:	e8 02 f7 ff ff       	call   80104720 <argstr>
8010501e:	85 c0                	test   %eax,%eax
80105020:	78 2e                	js     80105050 <sys_mkdir+0x50>
80105022:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105025:	31 c9                	xor    %ecx,%ecx
80105027:	ba 01 00 00 00       	mov    $0x1,%edx
8010502c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105033:	e8 d8 f7 ff ff       	call   80104810 <create>
80105038:	85 c0                	test   %eax,%eax
8010503a:	74 14                	je     80105050 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010503c:	89 04 24             	mov    %eax,(%esp)
8010503f:	e8 dc c8 ff ff       	call   80101920 <iunlockput>
  end_op();
80105044:	e8 47 db ff ff       	call   80102b90 <end_op>
  return 0;
80105049:	31 c0                	xor    %eax,%eax
}
8010504b:	c9                   	leave  
8010504c:	c3                   	ret    
8010504d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80105050:	e8 3b db ff ff       	call   80102b90 <end_op>
    return -1;
80105055:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010505a:	c9                   	leave  
8010505b:	c3                   	ret    
8010505c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105060 <sys_mknod>:

int
sys_mknod(void)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105066:	e8 b5 da ff ff       	call   80102b20 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010506b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010506e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105072:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105079:	e8 a2 f6 ff ff       	call   80104720 <argstr>
8010507e:	85 c0                	test   %eax,%eax
80105080:	78 5e                	js     801050e0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105082:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105085:	89 44 24 04          	mov    %eax,0x4(%esp)
80105089:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105090:	e8 fb f5 ff ff       	call   80104690 <argint>
  if((argstr(0, &path)) < 0 ||
80105095:	85 c0                	test   %eax,%eax
80105097:	78 47                	js     801050e0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105099:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010509c:	89 44 24 04          	mov    %eax,0x4(%esp)
801050a0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801050a7:	e8 e4 f5 ff ff       	call   80104690 <argint>
     argint(1, &major) < 0 ||
801050ac:	85 c0                	test   %eax,%eax
801050ae:	78 30                	js     801050e0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801050b0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801050b4:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
801050b9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801050bd:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
801050c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801050c3:	e8 48 f7 ff ff       	call   80104810 <create>
801050c8:	85 c0                	test   %eax,%eax
801050ca:	74 14                	je     801050e0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801050cc:	89 04 24             	mov    %eax,(%esp)
801050cf:	e8 4c c8 ff ff       	call   80101920 <iunlockput>
  end_op();
801050d4:	e8 b7 da ff ff       	call   80102b90 <end_op>
  return 0;
801050d9:	31 c0                	xor    %eax,%eax
}
801050db:	c9                   	leave  
801050dc:	c3                   	ret    
801050dd:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
801050e0:	e8 ab da ff ff       	call   80102b90 <end_op>
    return -1;
801050e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050ea:	c9                   	leave  
801050eb:	c3                   	ret    
801050ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050f0 <sys_chdir>:

int
sys_chdir(void)
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	56                   	push   %esi
801050f4:	53                   	push   %ebx
801050f5:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801050f8:	e8 c3 e5 ff ff       	call   801036c0 <myproc>
801050fd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801050ff:	e8 1c da ff ff       	call   80102b20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105104:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105107:	89 44 24 04          	mov    %eax,0x4(%esp)
8010510b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105112:	e8 09 f6 ff ff       	call   80104720 <argstr>
80105117:	85 c0                	test   %eax,%eax
80105119:	78 4a                	js     80105165 <sys_chdir+0x75>
8010511b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010511e:	89 04 24             	mov    %eax,(%esp)
80105121:	e8 ea cd ff ff       	call   80101f10 <namei>
80105126:	85 c0                	test   %eax,%eax
80105128:	89 c3                	mov    %eax,%ebx
8010512a:	74 39                	je     80105165 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
8010512c:	89 04 24             	mov    %eax,(%esp)
8010512f:	e8 8c c5 ff ff       	call   801016c0 <ilock>
  if(ip->type != T_DIR){
80105134:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105139:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
8010513c:	75 22                	jne    80105160 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
8010513e:	e8 5d c6 ff ff       	call   801017a0 <iunlock>
  iput(curproc->cwd);
80105143:	8b 46 68             	mov    0x68(%esi),%eax
80105146:	89 04 24             	mov    %eax,(%esp)
80105149:	e8 92 c6 ff ff       	call   801017e0 <iput>
  end_op();
8010514e:	e8 3d da ff ff       	call   80102b90 <end_op>
  curproc->cwd = ip;
  return 0;
80105153:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
80105155:	89 5e 68             	mov    %ebx,0x68(%esi)
}
80105158:	83 c4 20             	add    $0x20,%esp
8010515b:	5b                   	pop    %ebx
8010515c:	5e                   	pop    %esi
8010515d:	5d                   	pop    %ebp
8010515e:	c3                   	ret    
8010515f:	90                   	nop
    iunlockput(ip);
80105160:	e8 bb c7 ff ff       	call   80101920 <iunlockput>
    end_op();
80105165:	e8 26 da ff ff       	call   80102b90 <end_op>
}
8010516a:	83 c4 20             	add    $0x20,%esp
    return -1;
8010516d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105172:	5b                   	pop    %ebx
80105173:	5e                   	pop    %esi
80105174:	5d                   	pop    %ebp
80105175:	c3                   	ret    
80105176:	8d 76 00             	lea    0x0(%esi),%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105180 <sys_exec>:

int
sys_exec(void)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	57                   	push   %edi
80105184:	56                   	push   %esi
80105185:	53                   	push   %ebx
80105186:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010518c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105192:	89 44 24 04          	mov    %eax,0x4(%esp)
80105196:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010519d:	e8 7e f5 ff ff       	call   80104720 <argstr>
801051a2:	85 c0                	test   %eax,%eax
801051a4:	0f 88 84 00 00 00    	js     8010522e <sys_exec+0xae>
801051aa:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801051b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801051b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801051bb:	e8 d0 f4 ff ff       	call   80104690 <argint>
801051c0:	85 c0                	test   %eax,%eax
801051c2:	78 6a                	js     8010522e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801051c4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801051ca:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801051cc:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801051d3:	00 
801051d4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801051da:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801051e1:	00 
801051e2:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801051e8:	89 04 24             	mov    %eax,(%esp)
801051eb:	e8 b0 f1 ff ff       	call   801043a0 <memset>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801051f0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801051f6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801051fa:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801051fd:	89 04 24             	mov    %eax,(%esp)
80105200:	e8 eb f3 ff ff       	call   801045f0 <fetchint>
80105205:	85 c0                	test   %eax,%eax
80105207:	78 25                	js     8010522e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105209:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010520f:	85 c0                	test   %eax,%eax
80105211:	74 2d                	je     80105240 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105213:	89 74 24 04          	mov    %esi,0x4(%esp)
80105217:	89 04 24             	mov    %eax,(%esp)
8010521a:	e8 11 f4 ff ff       	call   80104630 <fetchstr>
8010521f:	85 c0                	test   %eax,%eax
80105221:	78 0b                	js     8010522e <sys_exec+0xae>
  for(i=0;; i++){
80105223:	83 c3 01             	add    $0x1,%ebx
80105226:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105229:	83 fb 20             	cmp    $0x20,%ebx
8010522c:	75 c2                	jne    801051f0 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
8010522e:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
80105234:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105239:	5b                   	pop    %ebx
8010523a:	5e                   	pop    %esi
8010523b:	5f                   	pop    %edi
8010523c:	5d                   	pop    %ebp
8010523d:	c3                   	ret    
8010523e:	66 90                	xchg   %ax,%ax
  return exec(path, argv);
80105240:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105246:	89 44 24 04          	mov    %eax,0x4(%esp)
8010524a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
      argv[i] = 0;
80105250:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105257:	00 00 00 00 
  return exec(path, argv);
8010525b:	89 04 24             	mov    %eax,(%esp)
8010525e:	e8 3d b7 ff ff       	call   801009a0 <exec>
}
80105263:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105269:	5b                   	pop    %ebx
8010526a:	5e                   	pop    %esi
8010526b:	5f                   	pop    %edi
8010526c:	5d                   	pop    %ebp
8010526d:	c3                   	ret    
8010526e:	66 90                	xchg   %ax,%ax

80105270 <sys_pipe>:

int
sys_pipe(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	53                   	push   %ebx
80105274:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105277:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010527a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105281:	00 
80105282:	89 44 24 04          	mov    %eax,0x4(%esp)
80105286:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010528d:	e8 2e f4 ff ff       	call   801046c0 <argptr>
80105292:	85 c0                	test   %eax,%eax
80105294:	78 6d                	js     80105303 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105296:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105299:	89 44 24 04          	mov    %eax,0x4(%esp)
8010529d:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052a0:	89 04 24             	mov    %eax,(%esp)
801052a3:	e8 d8 de ff ff       	call   80103180 <pipealloc>
801052a8:	85 c0                	test   %eax,%eax
801052aa:	78 57                	js     80105303 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801052ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052af:	e8 1c f5 ff ff       	call   801047d0 <fdalloc>
801052b4:	85 c0                	test   %eax,%eax
801052b6:	89 c3                	mov    %eax,%ebx
801052b8:	78 33                	js     801052ed <sys_pipe+0x7d>
801052ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052bd:	e8 0e f5 ff ff       	call   801047d0 <fdalloc>
801052c2:	85 c0                	test   %eax,%eax
801052c4:	78 1a                	js     801052e0 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801052c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801052c9:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801052cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801052ce:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
801052d1:	83 c4 24             	add    $0x24,%esp
  return 0;
801052d4:	31 c0                	xor    %eax,%eax
}
801052d6:	5b                   	pop    %ebx
801052d7:	5d                   	pop    %ebp
801052d8:	c3                   	ret    
801052d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801052e0:	e8 db e3 ff ff       	call   801036c0 <myproc>
801052e5:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
801052ec:	00 
    fileclose(rf);
801052ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052f0:	89 04 24             	mov    %eax,(%esp)
801052f3:	e8 48 bb ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
801052f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052fb:	89 04 24             	mov    %eax,(%esp)
801052fe:	e8 3d bb ff ff       	call   80100e40 <fileclose>
}
80105303:	83 c4 24             	add    $0x24,%esp
    return -1;
80105306:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010530b:	5b                   	pop    %ebx
8010530c:	5d                   	pop    %ebp
8010530d:	c3                   	ret    
8010530e:	66 90                	xchg   %ax,%ax

80105310 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105313:	5d                   	pop    %ebp
  return fork();
80105314:	e9 57 e5 ff ff       	jmp    80103870 <fork>
80105319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105320 <sys_exit>:

int
sys_exit(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	83 ec 08             	sub    $0x8,%esp
  exit();
80105326:	e8 f5 e7 ff ff       	call   80103b20 <exit>
  return 0;  // not reached
}
8010532b:	31 c0                	xor    %eax,%eax
8010532d:	c9                   	leave  
8010532e:	c3                   	ret    
8010532f:	90                   	nop

80105330 <sys_wait>:

int
sys_wait(void)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105333:	5d                   	pop    %ebp
  return wait();
80105334:	e9 37 ea ff ff       	jmp    80103d70 <wait>
80105339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105340 <sys_kill>:

int
sys_kill(void)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105346:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105349:	89 44 24 04          	mov    %eax,0x4(%esp)
8010534d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105354:	e8 37 f3 ff ff       	call   80104690 <argint>
80105359:	85 c0                	test   %eax,%eax
8010535b:	78 13                	js     80105370 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010535d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105360:	89 04 24             	mov    %eax,(%esp)
80105363:	e8 68 eb ff ff       	call   80103ed0 <kill>
}
80105368:	c9                   	leave  
80105369:	c3                   	ret    
8010536a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105375:	c9                   	leave  
80105376:	c3                   	ret    
80105377:	89 f6                	mov    %esi,%esi
80105379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105380 <sys_getpid>:

int
sys_getpid(void)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105386:	e8 35 e3 ff ff       	call   801036c0 <myproc>
8010538b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010538e:	c9                   	leave  
8010538f:	c3                   	ret    

80105390 <sys_sbrk>:

int
sys_sbrk(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	53                   	push   %ebx
80105394:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105397:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010539a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010539e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053a5:	e8 e6 f2 ff ff       	call   80104690 <argint>
801053aa:	85 c0                	test   %eax,%eax
801053ac:	78 22                	js     801053d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801053ae:	e8 0d e3 ff ff       	call   801036c0 <myproc>
  if(growproc(n) < 0)
801053b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  addr = myproc()->sz;
801053b6:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801053b8:	89 14 24             	mov    %edx,(%esp)
801053bb:	e8 40 e4 ff ff       	call   80103800 <growproc>
801053c0:	85 c0                	test   %eax,%eax
801053c2:	78 0c                	js     801053d0 <sys_sbrk+0x40>
    return -1;
  return addr;
801053c4:	89 d8                	mov    %ebx,%eax
}
801053c6:	83 c4 24             	add    $0x24,%esp
801053c9:	5b                   	pop    %ebx
801053ca:	5d                   	pop    %ebp
801053cb:	c3                   	ret    
801053cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801053d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053d5:	eb ef                	jmp    801053c6 <sys_sbrk+0x36>
801053d7:	89 f6                	mov    %esi,%esi
801053d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053e0 <sys_sleep>:

int
sys_sleep(void)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	53                   	push   %ebx
801053e4:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801053e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801053ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053f5:	e8 96 f2 ff ff       	call   80104690 <argint>
801053fa:	85 c0                	test   %eax,%eax
801053fc:	78 7e                	js     8010547c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
801053fe:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80105405:	e8 d6 ee ff ff       	call   801042e0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010540a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010540d:	8b 1d a0 58 11 80    	mov    0x801158a0,%ebx
  while(ticks - ticks0 < n){
80105413:	85 d2                	test   %edx,%edx
80105415:	75 29                	jne    80105440 <sys_sleep+0x60>
80105417:	eb 4f                	jmp    80105468 <sys_sleep+0x88>
80105419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105420:	c7 44 24 04 60 50 11 	movl   $0x80115060,0x4(%esp)
80105427:	80 
80105428:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
8010542f:	e8 8c e8 ff ff       	call   80103cc0 <sleep>
  while(ticks - ticks0 < n){
80105434:	a1 a0 58 11 80       	mov    0x801158a0,%eax
80105439:	29 d8                	sub    %ebx,%eax
8010543b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010543e:	73 28                	jae    80105468 <sys_sleep+0x88>
    if(myproc()->killed){
80105440:	e8 7b e2 ff ff       	call   801036c0 <myproc>
80105445:	8b 40 24             	mov    0x24(%eax),%eax
80105448:	85 c0                	test   %eax,%eax
8010544a:	74 d4                	je     80105420 <sys_sleep+0x40>
      release(&tickslock);
8010544c:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80105453:	e8 f8 ee ff ff       	call   80104350 <release>
      return -1;
80105458:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
8010545d:	83 c4 24             	add    $0x24,%esp
80105460:	5b                   	pop    %ebx
80105461:	5d                   	pop    %ebp
80105462:	c3                   	ret    
80105463:	90                   	nop
80105464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
80105468:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
8010546f:	e8 dc ee ff ff       	call   80104350 <release>
}
80105474:	83 c4 24             	add    $0x24,%esp
  return 0;
80105477:	31 c0                	xor    %eax,%eax
}
80105479:	5b                   	pop    %ebx
8010547a:	5d                   	pop    %ebp
8010547b:	c3                   	ret    
    return -1;
8010547c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105481:	eb da                	jmp    8010545d <sys_sleep+0x7d>
80105483:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105490 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	53                   	push   %ebx
80105494:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105497:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
8010549e:	e8 3d ee ff ff       	call   801042e0 <acquire>
  xticks = ticks;
801054a3:	8b 1d a0 58 11 80    	mov    0x801158a0,%ebx
  release(&tickslock);
801054a9:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
801054b0:	e8 9b ee ff ff       	call   80104350 <release>
  return xticks;
}
801054b5:	83 c4 14             	add    $0x14,%esp
801054b8:	89 d8                	mov    %ebx,%eax
801054ba:	5b                   	pop    %ebx
801054bb:	5d                   	pop    %ebp
801054bc:	c3                   	ret    
801054bd:	8d 76 00             	lea    0x0(%esi),%esi

801054c0 <sys_setpriority>:

int sys_setpriority(void) {
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	83 ec 28             	sub    $0x28,%esp
  int prior_val;

  if(argint(0, &prior_val) < 0)
801054c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801054cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054d4:	e8 b7 f1 ff ff       	call   80104690 <argint>
801054d9:	85 c0                	test   %eax,%eax
801054db:	78 13                	js     801054f0 <sys_setpriority+0x30>
    return -1;
  return setpriority(prior_val);
801054dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054e0:	89 04 24             	mov    %eax,(%esp)
801054e3:	e8 38 eb ff ff       	call   80104020 <setpriority>

}
801054e8:	c9                   	leave  
801054e9:	c3                   	ret    
801054ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801054f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054f5:	c9                   	leave  
801054f6:	c3                   	ret    

801054f7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801054f7:	1e                   	push   %ds
  pushl %es
801054f8:	06                   	push   %es
  pushl %fs
801054f9:	0f a0                	push   %fs
  pushl %gs
801054fb:	0f a8                	push   %gs
  pushal
801054fd:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801054fe:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105502:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105504:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105506:	54                   	push   %esp
  call trap
80105507:	e8 e4 00 00 00       	call   801055f0 <trap>
  addl $4, %esp
8010550c:	83 c4 04             	add    $0x4,%esp

8010550f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010550f:	61                   	popa   
  popl %gs
80105510:	0f a9                	pop    %gs
  popl %fs
80105512:	0f a1                	pop    %fs
  popl %es
80105514:	07                   	pop    %es
  popl %ds
80105515:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105516:	83 c4 08             	add    $0x8,%esp
  iret
80105519:	cf                   	iret   
8010551a:	66 90                	xchg   %ax,%ax
8010551c:	66 90                	xchg   %ax,%ax
8010551e:	66 90                	xchg   %ax,%ax

80105520 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105520:	31 c0                	xor    %eax,%eax
80105522:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105528:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010552f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105534:	66 89 0c c5 a2 50 11 	mov    %cx,-0x7feeaf5e(,%eax,8)
8010553b:	80 
8010553c:	c6 04 c5 a4 50 11 80 	movb   $0x0,-0x7feeaf5c(,%eax,8)
80105543:	00 
80105544:	c6 04 c5 a5 50 11 80 	movb   $0x8e,-0x7feeaf5b(,%eax,8)
8010554b:	8e 
8010554c:	66 89 14 c5 a0 50 11 	mov    %dx,-0x7feeaf60(,%eax,8)
80105553:	80 
80105554:	c1 ea 10             	shr    $0x10,%edx
80105557:	66 89 14 c5 a6 50 11 	mov    %dx,-0x7feeaf5a(,%eax,8)
8010555e:	80 
  for(i = 0; i < 256; i++)
8010555f:	83 c0 01             	add    $0x1,%eax
80105562:	3d 00 01 00 00       	cmp    $0x100,%eax
80105567:	75 bf                	jne    80105528 <tvinit+0x8>
{
80105569:	55                   	push   %ebp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010556a:	ba 08 00 00 00       	mov    $0x8,%edx
{
8010556f:	89 e5                	mov    %esp,%ebp
80105571:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105574:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105579:	c7 44 24 04 dd 74 10 	movl   $0x801074dd,0x4(%esp)
80105580:	80 
80105581:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105588:	66 89 15 a2 52 11 80 	mov    %dx,0x801152a2
8010558f:	66 a3 a0 52 11 80    	mov    %ax,0x801152a0
80105595:	c1 e8 10             	shr    $0x10,%eax
80105598:	c6 05 a4 52 11 80 00 	movb   $0x0,0x801152a4
8010559f:	c6 05 a5 52 11 80 ef 	movb   $0xef,0x801152a5
801055a6:	66 a3 a6 52 11 80    	mov    %ax,0x801152a6
  initlock(&tickslock, "time");
801055ac:	e8 bf eb ff ff       	call   80104170 <initlock>
}
801055b1:	c9                   	leave  
801055b2:	c3                   	ret    
801055b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055c0 <idtinit>:

void
idtinit(void)
{
801055c0:	55                   	push   %ebp
  pd[0] = size-1;
801055c1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801055c6:	89 e5                	mov    %esp,%ebp
801055c8:	83 ec 10             	sub    $0x10,%esp
801055cb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801055cf:	b8 a0 50 11 80       	mov    $0x801150a0,%eax
801055d4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801055d8:	c1 e8 10             	shr    $0x10,%eax
801055db:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801055df:	8d 45 fa             	lea    -0x6(%ebp),%eax
801055e2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801055e5:	c9                   	leave  
801055e6:	c3                   	ret    
801055e7:	89 f6                	mov    %esi,%esi
801055e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	57                   	push   %edi
801055f4:	56                   	push   %esi
801055f5:	53                   	push   %ebx
801055f6:	83 ec 3c             	sub    $0x3c,%esp
801055f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801055fc:	8b 43 30             	mov    0x30(%ebx),%eax
801055ff:	83 f8 40             	cmp    $0x40,%eax
80105602:	0f 84 a0 01 00 00    	je     801057a8 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105608:	83 e8 20             	sub    $0x20,%eax
8010560b:	83 f8 1f             	cmp    $0x1f,%eax
8010560e:	77 08                	ja     80105618 <trap+0x28>
80105610:	ff 24 85 84 75 10 80 	jmp    *-0x7fef8a7c(,%eax,4)
80105617:	90                   	nop
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105618:	e8 a3 e0 ff ff       	call   801036c0 <myproc>
8010561d:	85 c0                	test   %eax,%eax
8010561f:	90                   	nop
80105620:	0f 84 fa 01 00 00    	je     80105820 <trap+0x230>
80105626:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010562a:	0f 84 f0 01 00 00    	je     80105820 <trap+0x230>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105630:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105633:	8b 53 38             	mov    0x38(%ebx),%edx
80105636:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105639:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010563c:	e8 5f e0 ff ff       	call   801036a0 <cpuid>
80105641:	8b 73 30             	mov    0x30(%ebx),%esi
80105644:	89 c7                	mov    %eax,%edi
80105646:	8b 43 34             	mov    0x34(%ebx),%eax
80105649:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010564c:	e8 6f e0 ff ff       	call   801036c0 <myproc>
80105651:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105654:	e8 67 e0 ff ff       	call   801036c0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105659:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010565c:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105660:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105663:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105666:	89 7c 24 14          	mov    %edi,0x14(%esp)
8010566a:	89 54 24 18          	mov    %edx,0x18(%esp)
8010566e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            myproc()->pid, myproc()->name, tf->trapno,
80105671:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105674:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105678:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010567c:	89 54 24 10          	mov    %edx,0x10(%esp)
80105680:	8b 40 10             	mov    0x10(%eax),%eax
80105683:	c7 04 24 40 75 10 80 	movl   $0x80107540,(%esp)
8010568a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010568e:	e8 bd af ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105693:	e8 28 e0 ff ff       	call   801036c0 <myproc>
80105698:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010569f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801056a0:	e8 1b e0 ff ff       	call   801036c0 <myproc>
801056a5:	85 c0                	test   %eax,%eax
801056a7:	74 0c                	je     801056b5 <trap+0xc5>
801056a9:	e8 12 e0 ff ff       	call   801036c0 <myproc>
801056ae:	8b 50 24             	mov    0x24(%eax),%edx
801056b1:	85 d2                	test   %edx,%edx
801056b3:	75 4b                	jne    80105700 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801056b5:	e8 06 e0 ff ff       	call   801036c0 <myproc>
801056ba:	85 c0                	test   %eax,%eax
801056bc:	74 0d                	je     801056cb <trap+0xdb>
801056be:	66 90                	xchg   %ax,%ax
801056c0:	e8 fb df ff ff       	call   801036c0 <myproc>
801056c5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801056c9:	74 4d                	je     80105718 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801056cb:	e8 f0 df ff ff       	call   801036c0 <myproc>
801056d0:	85 c0                	test   %eax,%eax
801056d2:	74 1d                	je     801056f1 <trap+0x101>
801056d4:	e8 e7 df ff ff       	call   801036c0 <myproc>
801056d9:	8b 40 24             	mov    0x24(%eax),%eax
801056dc:	85 c0                	test   %eax,%eax
801056de:	74 11                	je     801056f1 <trap+0x101>
801056e0:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801056e4:	83 e0 03             	and    $0x3,%eax
801056e7:	66 83 f8 03          	cmp    $0x3,%ax
801056eb:	0f 84 e8 00 00 00    	je     801057d9 <trap+0x1e9>
    exit();
}
801056f1:	83 c4 3c             	add    $0x3c,%esp
801056f4:	5b                   	pop    %ebx
801056f5:	5e                   	pop    %esi
801056f6:	5f                   	pop    %edi
801056f7:	5d                   	pop    %ebp
801056f8:	c3                   	ret    
801056f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105700:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105704:	83 e0 03             	and    $0x3,%eax
80105707:	66 83 f8 03          	cmp    $0x3,%ax
8010570b:	75 a8                	jne    801056b5 <trap+0xc5>
    exit();
8010570d:	e8 0e e4 ff ff       	call   80103b20 <exit>
80105712:	eb a1                	jmp    801056b5 <trap+0xc5>
80105714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105718:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010571c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105720:	75 a9                	jne    801056cb <trap+0xdb>
    yield();
80105722:	e8 59 e5 ff ff       	call   80103c80 <yield>
80105727:	eb a2                	jmp    801056cb <trap+0xdb>
80105729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105730:	e8 6b df ff ff       	call   801036a0 <cpuid>
80105735:	85 c0                	test   %eax,%eax
80105737:	0f 84 b3 00 00 00    	je     801057f0 <trap+0x200>
8010573d:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
80105740:	e8 4b d0 ff ff       	call   80102790 <lapiceoi>
    break;
80105745:	e9 56 ff ff ff       	jmp    801056a0 <trap+0xb0>
8010574a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kbdintr();
80105750:	e8 8b ce ff ff       	call   801025e0 <kbdintr>
    lapiceoi();
80105755:	e8 36 d0 ff ff       	call   80102790 <lapiceoi>
    break;
8010575a:	e9 41 ff ff ff       	jmp    801056a0 <trap+0xb0>
8010575f:	90                   	nop
    uartintr();
80105760:	e8 1b 02 00 00       	call   80105980 <uartintr>
    lapiceoi();
80105765:	e8 26 d0 ff ff       	call   80102790 <lapiceoi>
    break;
8010576a:	e9 31 ff ff ff       	jmp    801056a0 <trap+0xb0>
8010576f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105770:	8b 7b 38             	mov    0x38(%ebx),%edi
80105773:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105777:	e8 24 df ff ff       	call   801036a0 <cpuid>
8010577c:	c7 04 24 e8 74 10 80 	movl   $0x801074e8,(%esp)
80105783:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105787:	89 74 24 08          	mov    %esi,0x8(%esp)
8010578b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010578f:	e8 bc ae ff ff       	call   80100650 <cprintf>
    lapiceoi();
80105794:	e8 f7 cf ff ff       	call   80102790 <lapiceoi>
    break;
80105799:	e9 02 ff ff ff       	jmp    801056a0 <trap+0xb0>
8010579e:	66 90                	xchg   %ax,%ax
    ideintr();
801057a0:	e8 eb c8 ff ff       	call   80102090 <ideintr>
801057a5:	eb 96                	jmp    8010573d <trap+0x14d>
801057a7:	90                   	nop
801057a8:	90                   	nop
801057a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801057b0:	e8 0b df ff ff       	call   801036c0 <myproc>
801057b5:	8b 70 24             	mov    0x24(%eax),%esi
801057b8:	85 f6                	test   %esi,%esi
801057ba:	75 2c                	jne    801057e8 <trap+0x1f8>
    myproc()->tf = tf;
801057bc:	e8 ff de ff ff       	call   801036c0 <myproc>
801057c1:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801057c4:	e8 97 ef ff ff       	call   80104760 <syscall>
    if(myproc()->killed)
801057c9:	e8 f2 de ff ff       	call   801036c0 <myproc>
801057ce:	8b 48 24             	mov    0x24(%eax),%ecx
801057d1:	85 c9                	test   %ecx,%ecx
801057d3:	0f 84 18 ff ff ff    	je     801056f1 <trap+0x101>
}
801057d9:	83 c4 3c             	add    $0x3c,%esp
801057dc:	5b                   	pop    %ebx
801057dd:	5e                   	pop    %esi
801057de:	5f                   	pop    %edi
801057df:	5d                   	pop    %ebp
      exit();
801057e0:	e9 3b e3 ff ff       	jmp    80103b20 <exit>
801057e5:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
801057e8:	e8 33 e3 ff ff       	call   80103b20 <exit>
801057ed:	eb cd                	jmp    801057bc <trap+0x1cc>
801057ef:	90                   	nop
      acquire(&tickslock);
801057f0:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
801057f7:	e8 e4 ea ff ff       	call   801042e0 <acquire>
      wakeup(&ticks);
801057fc:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
      ticks++;
80105803:	83 05 a0 58 11 80 01 	addl   $0x1,0x801158a0
      wakeup(&ticks);
8010580a:	e8 51 e6 ff ff       	call   80103e60 <wakeup>
      release(&tickslock);
8010580f:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80105816:	e8 35 eb ff ff       	call   80104350 <release>
8010581b:	e9 1d ff ff ff       	jmp    8010573d <trap+0x14d>
80105820:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105823:	8b 73 38             	mov    0x38(%ebx),%esi
80105826:	e8 75 de ff ff       	call   801036a0 <cpuid>
8010582b:	89 7c 24 10          	mov    %edi,0x10(%esp)
8010582f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105833:	89 44 24 08          	mov    %eax,0x8(%esp)
80105837:	8b 43 30             	mov    0x30(%ebx),%eax
8010583a:	c7 04 24 0c 75 10 80 	movl   $0x8010750c,(%esp)
80105841:	89 44 24 04          	mov    %eax,0x4(%esp)
80105845:	e8 06 ae ff ff       	call   80100650 <cprintf>
      panic("trap");
8010584a:	c7 04 24 e2 74 10 80 	movl   $0x801074e2,(%esp)
80105851:	e8 0a ab ff ff       	call   80100360 <panic>
80105856:	66 90                	xchg   %ax,%ax
80105858:	66 90                	xchg   %ax,%ax
8010585a:	66 90                	xchg   %ax,%ax
8010585c:	66 90                	xchg   %ax,%ax
8010585e:	66 90                	xchg   %ax,%ax

80105860 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105860:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105865:	55                   	push   %ebp
80105866:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105868:	85 c0                	test   %eax,%eax
8010586a:	74 14                	je     80105880 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010586c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105871:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105872:	a8 01                	test   $0x1,%al
80105874:	74 0a                	je     80105880 <uartgetc+0x20>
80105876:	b2 f8                	mov    $0xf8,%dl
80105878:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105879:	0f b6 c0             	movzbl %al,%eax
}
8010587c:	5d                   	pop    %ebp
8010587d:	c3                   	ret    
8010587e:	66 90                	xchg   %ax,%ax
    return -1;
80105880:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105885:	5d                   	pop    %ebp
80105886:	c3                   	ret    
80105887:	89 f6                	mov    %esi,%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105890 <uartputc>:
  if(!uart)
80105890:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105895:	85 c0                	test   %eax,%eax
80105897:	74 3f                	je     801058d8 <uartputc+0x48>
{
80105899:	55                   	push   %ebp
8010589a:	89 e5                	mov    %esp,%ebp
8010589c:	56                   	push   %esi
8010589d:	be fd 03 00 00       	mov    $0x3fd,%esi
801058a2:	53                   	push   %ebx
  if(!uart)
801058a3:	bb 80 00 00 00       	mov    $0x80,%ebx
{
801058a8:	83 ec 10             	sub    $0x10,%esp
801058ab:	eb 14                	jmp    801058c1 <uartputc+0x31>
801058ad:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
801058b0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801058b7:	e8 f4 ce ff ff       	call   801027b0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801058bc:	83 eb 01             	sub    $0x1,%ebx
801058bf:	74 07                	je     801058c8 <uartputc+0x38>
801058c1:	89 f2                	mov    %esi,%edx
801058c3:	ec                   	in     (%dx),%al
801058c4:	a8 20                	test   $0x20,%al
801058c6:	74 e8                	je     801058b0 <uartputc+0x20>
  outb(COM1+0, c);
801058c8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801058cc:	ba f8 03 00 00       	mov    $0x3f8,%edx
801058d1:	ee                   	out    %al,(%dx)
}
801058d2:	83 c4 10             	add    $0x10,%esp
801058d5:	5b                   	pop    %ebx
801058d6:	5e                   	pop    %esi
801058d7:	5d                   	pop    %ebp
801058d8:	f3 c3                	repz ret 
801058da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801058e0 <uartinit>:
{
801058e0:	55                   	push   %ebp
801058e1:	31 c9                	xor    %ecx,%ecx
801058e3:	89 e5                	mov    %esp,%ebp
801058e5:	89 c8                	mov    %ecx,%eax
801058e7:	57                   	push   %edi
801058e8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801058ed:	56                   	push   %esi
801058ee:	89 fa                	mov    %edi,%edx
801058f0:	53                   	push   %ebx
801058f1:	83 ec 1c             	sub    $0x1c,%esp
801058f4:	ee                   	out    %al,(%dx)
801058f5:	be fb 03 00 00       	mov    $0x3fb,%esi
801058fa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801058ff:	89 f2                	mov    %esi,%edx
80105901:	ee                   	out    %al,(%dx)
80105902:	b8 0c 00 00 00       	mov    $0xc,%eax
80105907:	b2 f8                	mov    $0xf8,%dl
80105909:	ee                   	out    %al,(%dx)
8010590a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
8010590f:	89 c8                	mov    %ecx,%eax
80105911:	89 da                	mov    %ebx,%edx
80105913:	ee                   	out    %al,(%dx)
80105914:	b8 03 00 00 00       	mov    $0x3,%eax
80105919:	89 f2                	mov    %esi,%edx
8010591b:	ee                   	out    %al,(%dx)
8010591c:	b2 fc                	mov    $0xfc,%dl
8010591e:	89 c8                	mov    %ecx,%eax
80105920:	ee                   	out    %al,(%dx)
80105921:	b8 01 00 00 00       	mov    $0x1,%eax
80105926:	89 da                	mov    %ebx,%edx
80105928:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105929:	b2 fd                	mov    $0xfd,%dl
8010592b:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
8010592c:	3c ff                	cmp    $0xff,%al
8010592e:	74 42                	je     80105972 <uartinit+0x92>
  uart = 1;
80105930:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105937:	00 00 00 
8010593a:	89 fa                	mov    %edi,%edx
8010593c:	ec                   	in     (%dx),%al
8010593d:	b2 f8                	mov    $0xf8,%dl
8010593f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105940:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105947:	00 
  for(p="xv6...\n"; *p; p++)
80105948:	bb 04 76 10 80       	mov    $0x80107604,%ebx
  ioapicenable(IRQ_COM1, 0);
8010594d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105954:	e8 67 c9 ff ff       	call   801022c0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105959:	b8 78 00 00 00       	mov    $0x78,%eax
8010595e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105960:	89 04 24             	mov    %eax,(%esp)
  for(p="xv6...\n"; *p; p++)
80105963:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105966:	e8 25 ff ff ff       	call   80105890 <uartputc>
  for(p="xv6...\n"; *p; p++)
8010596b:	0f be 03             	movsbl (%ebx),%eax
8010596e:	84 c0                	test   %al,%al
80105970:	75 ee                	jne    80105960 <uartinit+0x80>
}
80105972:	83 c4 1c             	add    $0x1c,%esp
80105975:	5b                   	pop    %ebx
80105976:	5e                   	pop    %esi
80105977:	5f                   	pop    %edi
80105978:	5d                   	pop    %ebp
80105979:	c3                   	ret    
8010597a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105980 <uartintr>:

void
uartintr(void)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105986:	c7 04 24 60 58 10 80 	movl   $0x80105860,(%esp)
8010598d:	e8 1e ae ff ff       	call   801007b0 <consoleintr>
}
80105992:	c9                   	leave  
80105993:	c3                   	ret    

80105994 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105994:	6a 00                	push   $0x0
  pushl $0
80105996:	6a 00                	push   $0x0
  jmp alltraps
80105998:	e9 5a fb ff ff       	jmp    801054f7 <alltraps>

8010599d <vector1>:
.globl vector1
vector1:
  pushl $0
8010599d:	6a 00                	push   $0x0
  pushl $1
8010599f:	6a 01                	push   $0x1
  jmp alltraps
801059a1:	e9 51 fb ff ff       	jmp    801054f7 <alltraps>

801059a6 <vector2>:
.globl vector2
vector2:
  pushl $0
801059a6:	6a 00                	push   $0x0
  pushl $2
801059a8:	6a 02                	push   $0x2
  jmp alltraps
801059aa:	e9 48 fb ff ff       	jmp    801054f7 <alltraps>

801059af <vector3>:
.globl vector3
vector3:
  pushl $0
801059af:	6a 00                	push   $0x0
  pushl $3
801059b1:	6a 03                	push   $0x3
  jmp alltraps
801059b3:	e9 3f fb ff ff       	jmp    801054f7 <alltraps>

801059b8 <vector4>:
.globl vector4
vector4:
  pushl $0
801059b8:	6a 00                	push   $0x0
  pushl $4
801059ba:	6a 04                	push   $0x4
  jmp alltraps
801059bc:	e9 36 fb ff ff       	jmp    801054f7 <alltraps>

801059c1 <vector5>:
.globl vector5
vector5:
  pushl $0
801059c1:	6a 00                	push   $0x0
  pushl $5
801059c3:	6a 05                	push   $0x5
  jmp alltraps
801059c5:	e9 2d fb ff ff       	jmp    801054f7 <alltraps>

801059ca <vector6>:
.globl vector6
vector6:
  pushl $0
801059ca:	6a 00                	push   $0x0
  pushl $6
801059cc:	6a 06                	push   $0x6
  jmp alltraps
801059ce:	e9 24 fb ff ff       	jmp    801054f7 <alltraps>

801059d3 <vector7>:
.globl vector7
vector7:
  pushl $0
801059d3:	6a 00                	push   $0x0
  pushl $7
801059d5:	6a 07                	push   $0x7
  jmp alltraps
801059d7:	e9 1b fb ff ff       	jmp    801054f7 <alltraps>

801059dc <vector8>:
.globl vector8
vector8:
  pushl $8
801059dc:	6a 08                	push   $0x8
  jmp alltraps
801059de:	e9 14 fb ff ff       	jmp    801054f7 <alltraps>

801059e3 <vector9>:
.globl vector9
vector9:
  pushl $0
801059e3:	6a 00                	push   $0x0
  pushl $9
801059e5:	6a 09                	push   $0x9
  jmp alltraps
801059e7:	e9 0b fb ff ff       	jmp    801054f7 <alltraps>

801059ec <vector10>:
.globl vector10
vector10:
  pushl $10
801059ec:	6a 0a                	push   $0xa
  jmp alltraps
801059ee:	e9 04 fb ff ff       	jmp    801054f7 <alltraps>

801059f3 <vector11>:
.globl vector11
vector11:
  pushl $11
801059f3:	6a 0b                	push   $0xb
  jmp alltraps
801059f5:	e9 fd fa ff ff       	jmp    801054f7 <alltraps>

801059fa <vector12>:
.globl vector12
vector12:
  pushl $12
801059fa:	6a 0c                	push   $0xc
  jmp alltraps
801059fc:	e9 f6 fa ff ff       	jmp    801054f7 <alltraps>

80105a01 <vector13>:
.globl vector13
vector13:
  pushl $13
80105a01:	6a 0d                	push   $0xd
  jmp alltraps
80105a03:	e9 ef fa ff ff       	jmp    801054f7 <alltraps>

80105a08 <vector14>:
.globl vector14
vector14:
  pushl $14
80105a08:	6a 0e                	push   $0xe
  jmp alltraps
80105a0a:	e9 e8 fa ff ff       	jmp    801054f7 <alltraps>

80105a0f <vector15>:
.globl vector15
vector15:
  pushl $0
80105a0f:	6a 00                	push   $0x0
  pushl $15
80105a11:	6a 0f                	push   $0xf
  jmp alltraps
80105a13:	e9 df fa ff ff       	jmp    801054f7 <alltraps>

80105a18 <vector16>:
.globl vector16
vector16:
  pushl $0
80105a18:	6a 00                	push   $0x0
  pushl $16
80105a1a:	6a 10                	push   $0x10
  jmp alltraps
80105a1c:	e9 d6 fa ff ff       	jmp    801054f7 <alltraps>

80105a21 <vector17>:
.globl vector17
vector17:
  pushl $17
80105a21:	6a 11                	push   $0x11
  jmp alltraps
80105a23:	e9 cf fa ff ff       	jmp    801054f7 <alltraps>

80105a28 <vector18>:
.globl vector18
vector18:
  pushl $0
80105a28:	6a 00                	push   $0x0
  pushl $18
80105a2a:	6a 12                	push   $0x12
  jmp alltraps
80105a2c:	e9 c6 fa ff ff       	jmp    801054f7 <alltraps>

80105a31 <vector19>:
.globl vector19
vector19:
  pushl $0
80105a31:	6a 00                	push   $0x0
  pushl $19
80105a33:	6a 13                	push   $0x13
  jmp alltraps
80105a35:	e9 bd fa ff ff       	jmp    801054f7 <alltraps>

80105a3a <vector20>:
.globl vector20
vector20:
  pushl $0
80105a3a:	6a 00                	push   $0x0
  pushl $20
80105a3c:	6a 14                	push   $0x14
  jmp alltraps
80105a3e:	e9 b4 fa ff ff       	jmp    801054f7 <alltraps>

80105a43 <vector21>:
.globl vector21
vector21:
  pushl $0
80105a43:	6a 00                	push   $0x0
  pushl $21
80105a45:	6a 15                	push   $0x15
  jmp alltraps
80105a47:	e9 ab fa ff ff       	jmp    801054f7 <alltraps>

80105a4c <vector22>:
.globl vector22
vector22:
  pushl $0
80105a4c:	6a 00                	push   $0x0
  pushl $22
80105a4e:	6a 16                	push   $0x16
  jmp alltraps
80105a50:	e9 a2 fa ff ff       	jmp    801054f7 <alltraps>

80105a55 <vector23>:
.globl vector23
vector23:
  pushl $0
80105a55:	6a 00                	push   $0x0
  pushl $23
80105a57:	6a 17                	push   $0x17
  jmp alltraps
80105a59:	e9 99 fa ff ff       	jmp    801054f7 <alltraps>

80105a5e <vector24>:
.globl vector24
vector24:
  pushl $0
80105a5e:	6a 00                	push   $0x0
  pushl $24
80105a60:	6a 18                	push   $0x18
  jmp alltraps
80105a62:	e9 90 fa ff ff       	jmp    801054f7 <alltraps>

80105a67 <vector25>:
.globl vector25
vector25:
  pushl $0
80105a67:	6a 00                	push   $0x0
  pushl $25
80105a69:	6a 19                	push   $0x19
  jmp alltraps
80105a6b:	e9 87 fa ff ff       	jmp    801054f7 <alltraps>

80105a70 <vector26>:
.globl vector26
vector26:
  pushl $0
80105a70:	6a 00                	push   $0x0
  pushl $26
80105a72:	6a 1a                	push   $0x1a
  jmp alltraps
80105a74:	e9 7e fa ff ff       	jmp    801054f7 <alltraps>

80105a79 <vector27>:
.globl vector27
vector27:
  pushl $0
80105a79:	6a 00                	push   $0x0
  pushl $27
80105a7b:	6a 1b                	push   $0x1b
  jmp alltraps
80105a7d:	e9 75 fa ff ff       	jmp    801054f7 <alltraps>

80105a82 <vector28>:
.globl vector28
vector28:
  pushl $0
80105a82:	6a 00                	push   $0x0
  pushl $28
80105a84:	6a 1c                	push   $0x1c
  jmp alltraps
80105a86:	e9 6c fa ff ff       	jmp    801054f7 <alltraps>

80105a8b <vector29>:
.globl vector29
vector29:
  pushl $0
80105a8b:	6a 00                	push   $0x0
  pushl $29
80105a8d:	6a 1d                	push   $0x1d
  jmp alltraps
80105a8f:	e9 63 fa ff ff       	jmp    801054f7 <alltraps>

80105a94 <vector30>:
.globl vector30
vector30:
  pushl $0
80105a94:	6a 00                	push   $0x0
  pushl $30
80105a96:	6a 1e                	push   $0x1e
  jmp alltraps
80105a98:	e9 5a fa ff ff       	jmp    801054f7 <alltraps>

80105a9d <vector31>:
.globl vector31
vector31:
  pushl $0
80105a9d:	6a 00                	push   $0x0
  pushl $31
80105a9f:	6a 1f                	push   $0x1f
  jmp alltraps
80105aa1:	e9 51 fa ff ff       	jmp    801054f7 <alltraps>

80105aa6 <vector32>:
.globl vector32
vector32:
  pushl $0
80105aa6:	6a 00                	push   $0x0
  pushl $32
80105aa8:	6a 20                	push   $0x20
  jmp alltraps
80105aaa:	e9 48 fa ff ff       	jmp    801054f7 <alltraps>

80105aaf <vector33>:
.globl vector33
vector33:
  pushl $0
80105aaf:	6a 00                	push   $0x0
  pushl $33
80105ab1:	6a 21                	push   $0x21
  jmp alltraps
80105ab3:	e9 3f fa ff ff       	jmp    801054f7 <alltraps>

80105ab8 <vector34>:
.globl vector34
vector34:
  pushl $0
80105ab8:	6a 00                	push   $0x0
  pushl $34
80105aba:	6a 22                	push   $0x22
  jmp alltraps
80105abc:	e9 36 fa ff ff       	jmp    801054f7 <alltraps>

80105ac1 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ac1:	6a 00                	push   $0x0
  pushl $35
80105ac3:	6a 23                	push   $0x23
  jmp alltraps
80105ac5:	e9 2d fa ff ff       	jmp    801054f7 <alltraps>

80105aca <vector36>:
.globl vector36
vector36:
  pushl $0
80105aca:	6a 00                	push   $0x0
  pushl $36
80105acc:	6a 24                	push   $0x24
  jmp alltraps
80105ace:	e9 24 fa ff ff       	jmp    801054f7 <alltraps>

80105ad3 <vector37>:
.globl vector37
vector37:
  pushl $0
80105ad3:	6a 00                	push   $0x0
  pushl $37
80105ad5:	6a 25                	push   $0x25
  jmp alltraps
80105ad7:	e9 1b fa ff ff       	jmp    801054f7 <alltraps>

80105adc <vector38>:
.globl vector38
vector38:
  pushl $0
80105adc:	6a 00                	push   $0x0
  pushl $38
80105ade:	6a 26                	push   $0x26
  jmp alltraps
80105ae0:	e9 12 fa ff ff       	jmp    801054f7 <alltraps>

80105ae5 <vector39>:
.globl vector39
vector39:
  pushl $0
80105ae5:	6a 00                	push   $0x0
  pushl $39
80105ae7:	6a 27                	push   $0x27
  jmp alltraps
80105ae9:	e9 09 fa ff ff       	jmp    801054f7 <alltraps>

80105aee <vector40>:
.globl vector40
vector40:
  pushl $0
80105aee:	6a 00                	push   $0x0
  pushl $40
80105af0:	6a 28                	push   $0x28
  jmp alltraps
80105af2:	e9 00 fa ff ff       	jmp    801054f7 <alltraps>

80105af7 <vector41>:
.globl vector41
vector41:
  pushl $0
80105af7:	6a 00                	push   $0x0
  pushl $41
80105af9:	6a 29                	push   $0x29
  jmp alltraps
80105afb:	e9 f7 f9 ff ff       	jmp    801054f7 <alltraps>

80105b00 <vector42>:
.globl vector42
vector42:
  pushl $0
80105b00:	6a 00                	push   $0x0
  pushl $42
80105b02:	6a 2a                	push   $0x2a
  jmp alltraps
80105b04:	e9 ee f9 ff ff       	jmp    801054f7 <alltraps>

80105b09 <vector43>:
.globl vector43
vector43:
  pushl $0
80105b09:	6a 00                	push   $0x0
  pushl $43
80105b0b:	6a 2b                	push   $0x2b
  jmp alltraps
80105b0d:	e9 e5 f9 ff ff       	jmp    801054f7 <alltraps>

80105b12 <vector44>:
.globl vector44
vector44:
  pushl $0
80105b12:	6a 00                	push   $0x0
  pushl $44
80105b14:	6a 2c                	push   $0x2c
  jmp alltraps
80105b16:	e9 dc f9 ff ff       	jmp    801054f7 <alltraps>

80105b1b <vector45>:
.globl vector45
vector45:
  pushl $0
80105b1b:	6a 00                	push   $0x0
  pushl $45
80105b1d:	6a 2d                	push   $0x2d
  jmp alltraps
80105b1f:	e9 d3 f9 ff ff       	jmp    801054f7 <alltraps>

80105b24 <vector46>:
.globl vector46
vector46:
  pushl $0
80105b24:	6a 00                	push   $0x0
  pushl $46
80105b26:	6a 2e                	push   $0x2e
  jmp alltraps
80105b28:	e9 ca f9 ff ff       	jmp    801054f7 <alltraps>

80105b2d <vector47>:
.globl vector47
vector47:
  pushl $0
80105b2d:	6a 00                	push   $0x0
  pushl $47
80105b2f:	6a 2f                	push   $0x2f
  jmp alltraps
80105b31:	e9 c1 f9 ff ff       	jmp    801054f7 <alltraps>

80105b36 <vector48>:
.globl vector48
vector48:
  pushl $0
80105b36:	6a 00                	push   $0x0
  pushl $48
80105b38:	6a 30                	push   $0x30
  jmp alltraps
80105b3a:	e9 b8 f9 ff ff       	jmp    801054f7 <alltraps>

80105b3f <vector49>:
.globl vector49
vector49:
  pushl $0
80105b3f:	6a 00                	push   $0x0
  pushl $49
80105b41:	6a 31                	push   $0x31
  jmp alltraps
80105b43:	e9 af f9 ff ff       	jmp    801054f7 <alltraps>

80105b48 <vector50>:
.globl vector50
vector50:
  pushl $0
80105b48:	6a 00                	push   $0x0
  pushl $50
80105b4a:	6a 32                	push   $0x32
  jmp alltraps
80105b4c:	e9 a6 f9 ff ff       	jmp    801054f7 <alltraps>

80105b51 <vector51>:
.globl vector51
vector51:
  pushl $0
80105b51:	6a 00                	push   $0x0
  pushl $51
80105b53:	6a 33                	push   $0x33
  jmp alltraps
80105b55:	e9 9d f9 ff ff       	jmp    801054f7 <alltraps>

80105b5a <vector52>:
.globl vector52
vector52:
  pushl $0
80105b5a:	6a 00                	push   $0x0
  pushl $52
80105b5c:	6a 34                	push   $0x34
  jmp alltraps
80105b5e:	e9 94 f9 ff ff       	jmp    801054f7 <alltraps>

80105b63 <vector53>:
.globl vector53
vector53:
  pushl $0
80105b63:	6a 00                	push   $0x0
  pushl $53
80105b65:	6a 35                	push   $0x35
  jmp alltraps
80105b67:	e9 8b f9 ff ff       	jmp    801054f7 <alltraps>

80105b6c <vector54>:
.globl vector54
vector54:
  pushl $0
80105b6c:	6a 00                	push   $0x0
  pushl $54
80105b6e:	6a 36                	push   $0x36
  jmp alltraps
80105b70:	e9 82 f9 ff ff       	jmp    801054f7 <alltraps>

80105b75 <vector55>:
.globl vector55
vector55:
  pushl $0
80105b75:	6a 00                	push   $0x0
  pushl $55
80105b77:	6a 37                	push   $0x37
  jmp alltraps
80105b79:	e9 79 f9 ff ff       	jmp    801054f7 <alltraps>

80105b7e <vector56>:
.globl vector56
vector56:
  pushl $0
80105b7e:	6a 00                	push   $0x0
  pushl $56
80105b80:	6a 38                	push   $0x38
  jmp alltraps
80105b82:	e9 70 f9 ff ff       	jmp    801054f7 <alltraps>

80105b87 <vector57>:
.globl vector57
vector57:
  pushl $0
80105b87:	6a 00                	push   $0x0
  pushl $57
80105b89:	6a 39                	push   $0x39
  jmp alltraps
80105b8b:	e9 67 f9 ff ff       	jmp    801054f7 <alltraps>

80105b90 <vector58>:
.globl vector58
vector58:
  pushl $0
80105b90:	6a 00                	push   $0x0
  pushl $58
80105b92:	6a 3a                	push   $0x3a
  jmp alltraps
80105b94:	e9 5e f9 ff ff       	jmp    801054f7 <alltraps>

80105b99 <vector59>:
.globl vector59
vector59:
  pushl $0
80105b99:	6a 00                	push   $0x0
  pushl $59
80105b9b:	6a 3b                	push   $0x3b
  jmp alltraps
80105b9d:	e9 55 f9 ff ff       	jmp    801054f7 <alltraps>

80105ba2 <vector60>:
.globl vector60
vector60:
  pushl $0
80105ba2:	6a 00                	push   $0x0
  pushl $60
80105ba4:	6a 3c                	push   $0x3c
  jmp alltraps
80105ba6:	e9 4c f9 ff ff       	jmp    801054f7 <alltraps>

80105bab <vector61>:
.globl vector61
vector61:
  pushl $0
80105bab:	6a 00                	push   $0x0
  pushl $61
80105bad:	6a 3d                	push   $0x3d
  jmp alltraps
80105baf:	e9 43 f9 ff ff       	jmp    801054f7 <alltraps>

80105bb4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105bb4:	6a 00                	push   $0x0
  pushl $62
80105bb6:	6a 3e                	push   $0x3e
  jmp alltraps
80105bb8:	e9 3a f9 ff ff       	jmp    801054f7 <alltraps>

80105bbd <vector63>:
.globl vector63
vector63:
  pushl $0
80105bbd:	6a 00                	push   $0x0
  pushl $63
80105bbf:	6a 3f                	push   $0x3f
  jmp alltraps
80105bc1:	e9 31 f9 ff ff       	jmp    801054f7 <alltraps>

80105bc6 <vector64>:
.globl vector64
vector64:
  pushl $0
80105bc6:	6a 00                	push   $0x0
  pushl $64
80105bc8:	6a 40                	push   $0x40
  jmp alltraps
80105bca:	e9 28 f9 ff ff       	jmp    801054f7 <alltraps>

80105bcf <vector65>:
.globl vector65
vector65:
  pushl $0
80105bcf:	6a 00                	push   $0x0
  pushl $65
80105bd1:	6a 41                	push   $0x41
  jmp alltraps
80105bd3:	e9 1f f9 ff ff       	jmp    801054f7 <alltraps>

80105bd8 <vector66>:
.globl vector66
vector66:
  pushl $0
80105bd8:	6a 00                	push   $0x0
  pushl $66
80105bda:	6a 42                	push   $0x42
  jmp alltraps
80105bdc:	e9 16 f9 ff ff       	jmp    801054f7 <alltraps>

80105be1 <vector67>:
.globl vector67
vector67:
  pushl $0
80105be1:	6a 00                	push   $0x0
  pushl $67
80105be3:	6a 43                	push   $0x43
  jmp alltraps
80105be5:	e9 0d f9 ff ff       	jmp    801054f7 <alltraps>

80105bea <vector68>:
.globl vector68
vector68:
  pushl $0
80105bea:	6a 00                	push   $0x0
  pushl $68
80105bec:	6a 44                	push   $0x44
  jmp alltraps
80105bee:	e9 04 f9 ff ff       	jmp    801054f7 <alltraps>

80105bf3 <vector69>:
.globl vector69
vector69:
  pushl $0
80105bf3:	6a 00                	push   $0x0
  pushl $69
80105bf5:	6a 45                	push   $0x45
  jmp alltraps
80105bf7:	e9 fb f8 ff ff       	jmp    801054f7 <alltraps>

80105bfc <vector70>:
.globl vector70
vector70:
  pushl $0
80105bfc:	6a 00                	push   $0x0
  pushl $70
80105bfe:	6a 46                	push   $0x46
  jmp alltraps
80105c00:	e9 f2 f8 ff ff       	jmp    801054f7 <alltraps>

80105c05 <vector71>:
.globl vector71
vector71:
  pushl $0
80105c05:	6a 00                	push   $0x0
  pushl $71
80105c07:	6a 47                	push   $0x47
  jmp alltraps
80105c09:	e9 e9 f8 ff ff       	jmp    801054f7 <alltraps>

80105c0e <vector72>:
.globl vector72
vector72:
  pushl $0
80105c0e:	6a 00                	push   $0x0
  pushl $72
80105c10:	6a 48                	push   $0x48
  jmp alltraps
80105c12:	e9 e0 f8 ff ff       	jmp    801054f7 <alltraps>

80105c17 <vector73>:
.globl vector73
vector73:
  pushl $0
80105c17:	6a 00                	push   $0x0
  pushl $73
80105c19:	6a 49                	push   $0x49
  jmp alltraps
80105c1b:	e9 d7 f8 ff ff       	jmp    801054f7 <alltraps>

80105c20 <vector74>:
.globl vector74
vector74:
  pushl $0
80105c20:	6a 00                	push   $0x0
  pushl $74
80105c22:	6a 4a                	push   $0x4a
  jmp alltraps
80105c24:	e9 ce f8 ff ff       	jmp    801054f7 <alltraps>

80105c29 <vector75>:
.globl vector75
vector75:
  pushl $0
80105c29:	6a 00                	push   $0x0
  pushl $75
80105c2b:	6a 4b                	push   $0x4b
  jmp alltraps
80105c2d:	e9 c5 f8 ff ff       	jmp    801054f7 <alltraps>

80105c32 <vector76>:
.globl vector76
vector76:
  pushl $0
80105c32:	6a 00                	push   $0x0
  pushl $76
80105c34:	6a 4c                	push   $0x4c
  jmp alltraps
80105c36:	e9 bc f8 ff ff       	jmp    801054f7 <alltraps>

80105c3b <vector77>:
.globl vector77
vector77:
  pushl $0
80105c3b:	6a 00                	push   $0x0
  pushl $77
80105c3d:	6a 4d                	push   $0x4d
  jmp alltraps
80105c3f:	e9 b3 f8 ff ff       	jmp    801054f7 <alltraps>

80105c44 <vector78>:
.globl vector78
vector78:
  pushl $0
80105c44:	6a 00                	push   $0x0
  pushl $78
80105c46:	6a 4e                	push   $0x4e
  jmp alltraps
80105c48:	e9 aa f8 ff ff       	jmp    801054f7 <alltraps>

80105c4d <vector79>:
.globl vector79
vector79:
  pushl $0
80105c4d:	6a 00                	push   $0x0
  pushl $79
80105c4f:	6a 4f                	push   $0x4f
  jmp alltraps
80105c51:	e9 a1 f8 ff ff       	jmp    801054f7 <alltraps>

80105c56 <vector80>:
.globl vector80
vector80:
  pushl $0
80105c56:	6a 00                	push   $0x0
  pushl $80
80105c58:	6a 50                	push   $0x50
  jmp alltraps
80105c5a:	e9 98 f8 ff ff       	jmp    801054f7 <alltraps>

80105c5f <vector81>:
.globl vector81
vector81:
  pushl $0
80105c5f:	6a 00                	push   $0x0
  pushl $81
80105c61:	6a 51                	push   $0x51
  jmp alltraps
80105c63:	e9 8f f8 ff ff       	jmp    801054f7 <alltraps>

80105c68 <vector82>:
.globl vector82
vector82:
  pushl $0
80105c68:	6a 00                	push   $0x0
  pushl $82
80105c6a:	6a 52                	push   $0x52
  jmp alltraps
80105c6c:	e9 86 f8 ff ff       	jmp    801054f7 <alltraps>

80105c71 <vector83>:
.globl vector83
vector83:
  pushl $0
80105c71:	6a 00                	push   $0x0
  pushl $83
80105c73:	6a 53                	push   $0x53
  jmp alltraps
80105c75:	e9 7d f8 ff ff       	jmp    801054f7 <alltraps>

80105c7a <vector84>:
.globl vector84
vector84:
  pushl $0
80105c7a:	6a 00                	push   $0x0
  pushl $84
80105c7c:	6a 54                	push   $0x54
  jmp alltraps
80105c7e:	e9 74 f8 ff ff       	jmp    801054f7 <alltraps>

80105c83 <vector85>:
.globl vector85
vector85:
  pushl $0
80105c83:	6a 00                	push   $0x0
  pushl $85
80105c85:	6a 55                	push   $0x55
  jmp alltraps
80105c87:	e9 6b f8 ff ff       	jmp    801054f7 <alltraps>

80105c8c <vector86>:
.globl vector86
vector86:
  pushl $0
80105c8c:	6a 00                	push   $0x0
  pushl $86
80105c8e:	6a 56                	push   $0x56
  jmp alltraps
80105c90:	e9 62 f8 ff ff       	jmp    801054f7 <alltraps>

80105c95 <vector87>:
.globl vector87
vector87:
  pushl $0
80105c95:	6a 00                	push   $0x0
  pushl $87
80105c97:	6a 57                	push   $0x57
  jmp alltraps
80105c99:	e9 59 f8 ff ff       	jmp    801054f7 <alltraps>

80105c9e <vector88>:
.globl vector88
vector88:
  pushl $0
80105c9e:	6a 00                	push   $0x0
  pushl $88
80105ca0:	6a 58                	push   $0x58
  jmp alltraps
80105ca2:	e9 50 f8 ff ff       	jmp    801054f7 <alltraps>

80105ca7 <vector89>:
.globl vector89
vector89:
  pushl $0
80105ca7:	6a 00                	push   $0x0
  pushl $89
80105ca9:	6a 59                	push   $0x59
  jmp alltraps
80105cab:	e9 47 f8 ff ff       	jmp    801054f7 <alltraps>

80105cb0 <vector90>:
.globl vector90
vector90:
  pushl $0
80105cb0:	6a 00                	push   $0x0
  pushl $90
80105cb2:	6a 5a                	push   $0x5a
  jmp alltraps
80105cb4:	e9 3e f8 ff ff       	jmp    801054f7 <alltraps>

80105cb9 <vector91>:
.globl vector91
vector91:
  pushl $0
80105cb9:	6a 00                	push   $0x0
  pushl $91
80105cbb:	6a 5b                	push   $0x5b
  jmp alltraps
80105cbd:	e9 35 f8 ff ff       	jmp    801054f7 <alltraps>

80105cc2 <vector92>:
.globl vector92
vector92:
  pushl $0
80105cc2:	6a 00                	push   $0x0
  pushl $92
80105cc4:	6a 5c                	push   $0x5c
  jmp alltraps
80105cc6:	e9 2c f8 ff ff       	jmp    801054f7 <alltraps>

80105ccb <vector93>:
.globl vector93
vector93:
  pushl $0
80105ccb:	6a 00                	push   $0x0
  pushl $93
80105ccd:	6a 5d                	push   $0x5d
  jmp alltraps
80105ccf:	e9 23 f8 ff ff       	jmp    801054f7 <alltraps>

80105cd4 <vector94>:
.globl vector94
vector94:
  pushl $0
80105cd4:	6a 00                	push   $0x0
  pushl $94
80105cd6:	6a 5e                	push   $0x5e
  jmp alltraps
80105cd8:	e9 1a f8 ff ff       	jmp    801054f7 <alltraps>

80105cdd <vector95>:
.globl vector95
vector95:
  pushl $0
80105cdd:	6a 00                	push   $0x0
  pushl $95
80105cdf:	6a 5f                	push   $0x5f
  jmp alltraps
80105ce1:	e9 11 f8 ff ff       	jmp    801054f7 <alltraps>

80105ce6 <vector96>:
.globl vector96
vector96:
  pushl $0
80105ce6:	6a 00                	push   $0x0
  pushl $96
80105ce8:	6a 60                	push   $0x60
  jmp alltraps
80105cea:	e9 08 f8 ff ff       	jmp    801054f7 <alltraps>

80105cef <vector97>:
.globl vector97
vector97:
  pushl $0
80105cef:	6a 00                	push   $0x0
  pushl $97
80105cf1:	6a 61                	push   $0x61
  jmp alltraps
80105cf3:	e9 ff f7 ff ff       	jmp    801054f7 <alltraps>

80105cf8 <vector98>:
.globl vector98
vector98:
  pushl $0
80105cf8:	6a 00                	push   $0x0
  pushl $98
80105cfa:	6a 62                	push   $0x62
  jmp alltraps
80105cfc:	e9 f6 f7 ff ff       	jmp    801054f7 <alltraps>

80105d01 <vector99>:
.globl vector99
vector99:
  pushl $0
80105d01:	6a 00                	push   $0x0
  pushl $99
80105d03:	6a 63                	push   $0x63
  jmp alltraps
80105d05:	e9 ed f7 ff ff       	jmp    801054f7 <alltraps>

80105d0a <vector100>:
.globl vector100
vector100:
  pushl $0
80105d0a:	6a 00                	push   $0x0
  pushl $100
80105d0c:	6a 64                	push   $0x64
  jmp alltraps
80105d0e:	e9 e4 f7 ff ff       	jmp    801054f7 <alltraps>

80105d13 <vector101>:
.globl vector101
vector101:
  pushl $0
80105d13:	6a 00                	push   $0x0
  pushl $101
80105d15:	6a 65                	push   $0x65
  jmp alltraps
80105d17:	e9 db f7 ff ff       	jmp    801054f7 <alltraps>

80105d1c <vector102>:
.globl vector102
vector102:
  pushl $0
80105d1c:	6a 00                	push   $0x0
  pushl $102
80105d1e:	6a 66                	push   $0x66
  jmp alltraps
80105d20:	e9 d2 f7 ff ff       	jmp    801054f7 <alltraps>

80105d25 <vector103>:
.globl vector103
vector103:
  pushl $0
80105d25:	6a 00                	push   $0x0
  pushl $103
80105d27:	6a 67                	push   $0x67
  jmp alltraps
80105d29:	e9 c9 f7 ff ff       	jmp    801054f7 <alltraps>

80105d2e <vector104>:
.globl vector104
vector104:
  pushl $0
80105d2e:	6a 00                	push   $0x0
  pushl $104
80105d30:	6a 68                	push   $0x68
  jmp alltraps
80105d32:	e9 c0 f7 ff ff       	jmp    801054f7 <alltraps>

80105d37 <vector105>:
.globl vector105
vector105:
  pushl $0
80105d37:	6a 00                	push   $0x0
  pushl $105
80105d39:	6a 69                	push   $0x69
  jmp alltraps
80105d3b:	e9 b7 f7 ff ff       	jmp    801054f7 <alltraps>

80105d40 <vector106>:
.globl vector106
vector106:
  pushl $0
80105d40:	6a 00                	push   $0x0
  pushl $106
80105d42:	6a 6a                	push   $0x6a
  jmp alltraps
80105d44:	e9 ae f7 ff ff       	jmp    801054f7 <alltraps>

80105d49 <vector107>:
.globl vector107
vector107:
  pushl $0
80105d49:	6a 00                	push   $0x0
  pushl $107
80105d4b:	6a 6b                	push   $0x6b
  jmp alltraps
80105d4d:	e9 a5 f7 ff ff       	jmp    801054f7 <alltraps>

80105d52 <vector108>:
.globl vector108
vector108:
  pushl $0
80105d52:	6a 00                	push   $0x0
  pushl $108
80105d54:	6a 6c                	push   $0x6c
  jmp alltraps
80105d56:	e9 9c f7 ff ff       	jmp    801054f7 <alltraps>

80105d5b <vector109>:
.globl vector109
vector109:
  pushl $0
80105d5b:	6a 00                	push   $0x0
  pushl $109
80105d5d:	6a 6d                	push   $0x6d
  jmp alltraps
80105d5f:	e9 93 f7 ff ff       	jmp    801054f7 <alltraps>

80105d64 <vector110>:
.globl vector110
vector110:
  pushl $0
80105d64:	6a 00                	push   $0x0
  pushl $110
80105d66:	6a 6e                	push   $0x6e
  jmp alltraps
80105d68:	e9 8a f7 ff ff       	jmp    801054f7 <alltraps>

80105d6d <vector111>:
.globl vector111
vector111:
  pushl $0
80105d6d:	6a 00                	push   $0x0
  pushl $111
80105d6f:	6a 6f                	push   $0x6f
  jmp alltraps
80105d71:	e9 81 f7 ff ff       	jmp    801054f7 <alltraps>

80105d76 <vector112>:
.globl vector112
vector112:
  pushl $0
80105d76:	6a 00                	push   $0x0
  pushl $112
80105d78:	6a 70                	push   $0x70
  jmp alltraps
80105d7a:	e9 78 f7 ff ff       	jmp    801054f7 <alltraps>

80105d7f <vector113>:
.globl vector113
vector113:
  pushl $0
80105d7f:	6a 00                	push   $0x0
  pushl $113
80105d81:	6a 71                	push   $0x71
  jmp alltraps
80105d83:	e9 6f f7 ff ff       	jmp    801054f7 <alltraps>

80105d88 <vector114>:
.globl vector114
vector114:
  pushl $0
80105d88:	6a 00                	push   $0x0
  pushl $114
80105d8a:	6a 72                	push   $0x72
  jmp alltraps
80105d8c:	e9 66 f7 ff ff       	jmp    801054f7 <alltraps>

80105d91 <vector115>:
.globl vector115
vector115:
  pushl $0
80105d91:	6a 00                	push   $0x0
  pushl $115
80105d93:	6a 73                	push   $0x73
  jmp alltraps
80105d95:	e9 5d f7 ff ff       	jmp    801054f7 <alltraps>

80105d9a <vector116>:
.globl vector116
vector116:
  pushl $0
80105d9a:	6a 00                	push   $0x0
  pushl $116
80105d9c:	6a 74                	push   $0x74
  jmp alltraps
80105d9e:	e9 54 f7 ff ff       	jmp    801054f7 <alltraps>

80105da3 <vector117>:
.globl vector117
vector117:
  pushl $0
80105da3:	6a 00                	push   $0x0
  pushl $117
80105da5:	6a 75                	push   $0x75
  jmp alltraps
80105da7:	e9 4b f7 ff ff       	jmp    801054f7 <alltraps>

80105dac <vector118>:
.globl vector118
vector118:
  pushl $0
80105dac:	6a 00                	push   $0x0
  pushl $118
80105dae:	6a 76                	push   $0x76
  jmp alltraps
80105db0:	e9 42 f7 ff ff       	jmp    801054f7 <alltraps>

80105db5 <vector119>:
.globl vector119
vector119:
  pushl $0
80105db5:	6a 00                	push   $0x0
  pushl $119
80105db7:	6a 77                	push   $0x77
  jmp alltraps
80105db9:	e9 39 f7 ff ff       	jmp    801054f7 <alltraps>

80105dbe <vector120>:
.globl vector120
vector120:
  pushl $0
80105dbe:	6a 00                	push   $0x0
  pushl $120
80105dc0:	6a 78                	push   $0x78
  jmp alltraps
80105dc2:	e9 30 f7 ff ff       	jmp    801054f7 <alltraps>

80105dc7 <vector121>:
.globl vector121
vector121:
  pushl $0
80105dc7:	6a 00                	push   $0x0
  pushl $121
80105dc9:	6a 79                	push   $0x79
  jmp alltraps
80105dcb:	e9 27 f7 ff ff       	jmp    801054f7 <alltraps>

80105dd0 <vector122>:
.globl vector122
vector122:
  pushl $0
80105dd0:	6a 00                	push   $0x0
  pushl $122
80105dd2:	6a 7a                	push   $0x7a
  jmp alltraps
80105dd4:	e9 1e f7 ff ff       	jmp    801054f7 <alltraps>

80105dd9 <vector123>:
.globl vector123
vector123:
  pushl $0
80105dd9:	6a 00                	push   $0x0
  pushl $123
80105ddb:	6a 7b                	push   $0x7b
  jmp alltraps
80105ddd:	e9 15 f7 ff ff       	jmp    801054f7 <alltraps>

80105de2 <vector124>:
.globl vector124
vector124:
  pushl $0
80105de2:	6a 00                	push   $0x0
  pushl $124
80105de4:	6a 7c                	push   $0x7c
  jmp alltraps
80105de6:	e9 0c f7 ff ff       	jmp    801054f7 <alltraps>

80105deb <vector125>:
.globl vector125
vector125:
  pushl $0
80105deb:	6a 00                	push   $0x0
  pushl $125
80105ded:	6a 7d                	push   $0x7d
  jmp alltraps
80105def:	e9 03 f7 ff ff       	jmp    801054f7 <alltraps>

80105df4 <vector126>:
.globl vector126
vector126:
  pushl $0
80105df4:	6a 00                	push   $0x0
  pushl $126
80105df6:	6a 7e                	push   $0x7e
  jmp alltraps
80105df8:	e9 fa f6 ff ff       	jmp    801054f7 <alltraps>

80105dfd <vector127>:
.globl vector127
vector127:
  pushl $0
80105dfd:	6a 00                	push   $0x0
  pushl $127
80105dff:	6a 7f                	push   $0x7f
  jmp alltraps
80105e01:	e9 f1 f6 ff ff       	jmp    801054f7 <alltraps>

80105e06 <vector128>:
.globl vector128
vector128:
  pushl $0
80105e06:	6a 00                	push   $0x0
  pushl $128
80105e08:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105e0d:	e9 e5 f6 ff ff       	jmp    801054f7 <alltraps>

80105e12 <vector129>:
.globl vector129
vector129:
  pushl $0
80105e12:	6a 00                	push   $0x0
  pushl $129
80105e14:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105e19:	e9 d9 f6 ff ff       	jmp    801054f7 <alltraps>

80105e1e <vector130>:
.globl vector130
vector130:
  pushl $0
80105e1e:	6a 00                	push   $0x0
  pushl $130
80105e20:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105e25:	e9 cd f6 ff ff       	jmp    801054f7 <alltraps>

80105e2a <vector131>:
.globl vector131
vector131:
  pushl $0
80105e2a:	6a 00                	push   $0x0
  pushl $131
80105e2c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105e31:	e9 c1 f6 ff ff       	jmp    801054f7 <alltraps>

80105e36 <vector132>:
.globl vector132
vector132:
  pushl $0
80105e36:	6a 00                	push   $0x0
  pushl $132
80105e38:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105e3d:	e9 b5 f6 ff ff       	jmp    801054f7 <alltraps>

80105e42 <vector133>:
.globl vector133
vector133:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $133
80105e44:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105e49:	e9 a9 f6 ff ff       	jmp    801054f7 <alltraps>

80105e4e <vector134>:
.globl vector134
vector134:
  pushl $0
80105e4e:	6a 00                	push   $0x0
  pushl $134
80105e50:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105e55:	e9 9d f6 ff ff       	jmp    801054f7 <alltraps>

80105e5a <vector135>:
.globl vector135
vector135:
  pushl $0
80105e5a:	6a 00                	push   $0x0
  pushl $135
80105e5c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105e61:	e9 91 f6 ff ff       	jmp    801054f7 <alltraps>

80105e66 <vector136>:
.globl vector136
vector136:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $136
80105e68:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105e6d:	e9 85 f6 ff ff       	jmp    801054f7 <alltraps>

80105e72 <vector137>:
.globl vector137
vector137:
  pushl $0
80105e72:	6a 00                	push   $0x0
  pushl $137
80105e74:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105e79:	e9 79 f6 ff ff       	jmp    801054f7 <alltraps>

80105e7e <vector138>:
.globl vector138
vector138:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $138
80105e80:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105e85:	e9 6d f6 ff ff       	jmp    801054f7 <alltraps>

80105e8a <vector139>:
.globl vector139
vector139:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $139
80105e8c:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105e91:	e9 61 f6 ff ff       	jmp    801054f7 <alltraps>

80105e96 <vector140>:
.globl vector140
vector140:
  pushl $0
80105e96:	6a 00                	push   $0x0
  pushl $140
80105e98:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105e9d:	e9 55 f6 ff ff       	jmp    801054f7 <alltraps>

80105ea2 <vector141>:
.globl vector141
vector141:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $141
80105ea4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105ea9:	e9 49 f6 ff ff       	jmp    801054f7 <alltraps>

80105eae <vector142>:
.globl vector142
vector142:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $142
80105eb0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105eb5:	e9 3d f6 ff ff       	jmp    801054f7 <alltraps>

80105eba <vector143>:
.globl vector143
vector143:
  pushl $0
80105eba:	6a 00                	push   $0x0
  pushl $143
80105ebc:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105ec1:	e9 31 f6 ff ff       	jmp    801054f7 <alltraps>

80105ec6 <vector144>:
.globl vector144
vector144:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $144
80105ec8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105ecd:	e9 25 f6 ff ff       	jmp    801054f7 <alltraps>

80105ed2 <vector145>:
.globl vector145
vector145:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $145
80105ed4:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105ed9:	e9 19 f6 ff ff       	jmp    801054f7 <alltraps>

80105ede <vector146>:
.globl vector146
vector146:
  pushl $0
80105ede:	6a 00                	push   $0x0
  pushl $146
80105ee0:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105ee5:	e9 0d f6 ff ff       	jmp    801054f7 <alltraps>

80105eea <vector147>:
.globl vector147
vector147:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $147
80105eec:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105ef1:	e9 01 f6 ff ff       	jmp    801054f7 <alltraps>

80105ef6 <vector148>:
.globl vector148
vector148:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $148
80105ef8:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105efd:	e9 f5 f5 ff ff       	jmp    801054f7 <alltraps>

80105f02 <vector149>:
.globl vector149
vector149:
  pushl $0
80105f02:	6a 00                	push   $0x0
  pushl $149
80105f04:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105f09:	e9 e9 f5 ff ff       	jmp    801054f7 <alltraps>

80105f0e <vector150>:
.globl vector150
vector150:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $150
80105f10:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105f15:	e9 dd f5 ff ff       	jmp    801054f7 <alltraps>

80105f1a <vector151>:
.globl vector151
vector151:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $151
80105f1c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105f21:	e9 d1 f5 ff ff       	jmp    801054f7 <alltraps>

80105f26 <vector152>:
.globl vector152
vector152:
  pushl $0
80105f26:	6a 00                	push   $0x0
  pushl $152
80105f28:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105f2d:	e9 c5 f5 ff ff       	jmp    801054f7 <alltraps>

80105f32 <vector153>:
.globl vector153
vector153:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $153
80105f34:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105f39:	e9 b9 f5 ff ff       	jmp    801054f7 <alltraps>

80105f3e <vector154>:
.globl vector154
vector154:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $154
80105f40:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80105f45:	e9 ad f5 ff ff       	jmp    801054f7 <alltraps>

80105f4a <vector155>:
.globl vector155
vector155:
  pushl $0
80105f4a:	6a 00                	push   $0x0
  pushl $155
80105f4c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80105f51:	e9 a1 f5 ff ff       	jmp    801054f7 <alltraps>

80105f56 <vector156>:
.globl vector156
vector156:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $156
80105f58:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105f5d:	e9 95 f5 ff ff       	jmp    801054f7 <alltraps>

80105f62 <vector157>:
.globl vector157
vector157:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $157
80105f64:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105f69:	e9 89 f5 ff ff       	jmp    801054f7 <alltraps>

80105f6e <vector158>:
.globl vector158
vector158:
  pushl $0
80105f6e:	6a 00                	push   $0x0
  pushl $158
80105f70:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105f75:	e9 7d f5 ff ff       	jmp    801054f7 <alltraps>

80105f7a <vector159>:
.globl vector159
vector159:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $159
80105f7c:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105f81:	e9 71 f5 ff ff       	jmp    801054f7 <alltraps>

80105f86 <vector160>:
.globl vector160
vector160:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $160
80105f88:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105f8d:	e9 65 f5 ff ff       	jmp    801054f7 <alltraps>

80105f92 <vector161>:
.globl vector161
vector161:
  pushl $0
80105f92:	6a 00                	push   $0x0
  pushl $161
80105f94:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105f99:	e9 59 f5 ff ff       	jmp    801054f7 <alltraps>

80105f9e <vector162>:
.globl vector162
vector162:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $162
80105fa0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105fa5:	e9 4d f5 ff ff       	jmp    801054f7 <alltraps>

80105faa <vector163>:
.globl vector163
vector163:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $163
80105fac:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105fb1:	e9 41 f5 ff ff       	jmp    801054f7 <alltraps>

80105fb6 <vector164>:
.globl vector164
vector164:
  pushl $0
80105fb6:	6a 00                	push   $0x0
  pushl $164
80105fb8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105fbd:	e9 35 f5 ff ff       	jmp    801054f7 <alltraps>

80105fc2 <vector165>:
.globl vector165
vector165:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $165
80105fc4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105fc9:	e9 29 f5 ff ff       	jmp    801054f7 <alltraps>

80105fce <vector166>:
.globl vector166
vector166:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $166
80105fd0:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105fd5:	e9 1d f5 ff ff       	jmp    801054f7 <alltraps>

80105fda <vector167>:
.globl vector167
vector167:
  pushl $0
80105fda:	6a 00                	push   $0x0
  pushl $167
80105fdc:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105fe1:	e9 11 f5 ff ff       	jmp    801054f7 <alltraps>

80105fe6 <vector168>:
.globl vector168
vector168:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $168
80105fe8:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105fed:	e9 05 f5 ff ff       	jmp    801054f7 <alltraps>

80105ff2 <vector169>:
.globl vector169
vector169:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $169
80105ff4:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105ff9:	e9 f9 f4 ff ff       	jmp    801054f7 <alltraps>

80105ffe <vector170>:
.globl vector170
vector170:
  pushl $0
80105ffe:	6a 00                	push   $0x0
  pushl $170
80106000:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106005:	e9 ed f4 ff ff       	jmp    801054f7 <alltraps>

8010600a <vector171>:
.globl vector171
vector171:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $171
8010600c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106011:	e9 e1 f4 ff ff       	jmp    801054f7 <alltraps>

80106016 <vector172>:
.globl vector172
vector172:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $172
80106018:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010601d:	e9 d5 f4 ff ff       	jmp    801054f7 <alltraps>

80106022 <vector173>:
.globl vector173
vector173:
  pushl $0
80106022:	6a 00                	push   $0x0
  pushl $173
80106024:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106029:	e9 c9 f4 ff ff       	jmp    801054f7 <alltraps>

8010602e <vector174>:
.globl vector174
vector174:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $174
80106030:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106035:	e9 bd f4 ff ff       	jmp    801054f7 <alltraps>

8010603a <vector175>:
.globl vector175
vector175:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $175
8010603c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106041:	e9 b1 f4 ff ff       	jmp    801054f7 <alltraps>

80106046 <vector176>:
.globl vector176
vector176:
  pushl $0
80106046:	6a 00                	push   $0x0
  pushl $176
80106048:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010604d:	e9 a5 f4 ff ff       	jmp    801054f7 <alltraps>

80106052 <vector177>:
.globl vector177
vector177:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $177
80106054:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106059:	e9 99 f4 ff ff       	jmp    801054f7 <alltraps>

8010605e <vector178>:
.globl vector178
vector178:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $178
80106060:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106065:	e9 8d f4 ff ff       	jmp    801054f7 <alltraps>

8010606a <vector179>:
.globl vector179
vector179:
  pushl $0
8010606a:	6a 00                	push   $0x0
  pushl $179
8010606c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106071:	e9 81 f4 ff ff       	jmp    801054f7 <alltraps>

80106076 <vector180>:
.globl vector180
vector180:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $180
80106078:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010607d:	e9 75 f4 ff ff       	jmp    801054f7 <alltraps>

80106082 <vector181>:
.globl vector181
vector181:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $181
80106084:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106089:	e9 69 f4 ff ff       	jmp    801054f7 <alltraps>

8010608e <vector182>:
.globl vector182
vector182:
  pushl $0
8010608e:	6a 00                	push   $0x0
  pushl $182
80106090:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106095:	e9 5d f4 ff ff       	jmp    801054f7 <alltraps>

8010609a <vector183>:
.globl vector183
vector183:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $183
8010609c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801060a1:	e9 51 f4 ff ff       	jmp    801054f7 <alltraps>

801060a6 <vector184>:
.globl vector184
vector184:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $184
801060a8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801060ad:	e9 45 f4 ff ff       	jmp    801054f7 <alltraps>

801060b2 <vector185>:
.globl vector185
vector185:
  pushl $0
801060b2:	6a 00                	push   $0x0
  pushl $185
801060b4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801060b9:	e9 39 f4 ff ff       	jmp    801054f7 <alltraps>

801060be <vector186>:
.globl vector186
vector186:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $186
801060c0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801060c5:	e9 2d f4 ff ff       	jmp    801054f7 <alltraps>

801060ca <vector187>:
.globl vector187
vector187:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $187
801060cc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801060d1:	e9 21 f4 ff ff       	jmp    801054f7 <alltraps>

801060d6 <vector188>:
.globl vector188
vector188:
  pushl $0
801060d6:	6a 00                	push   $0x0
  pushl $188
801060d8:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801060dd:	e9 15 f4 ff ff       	jmp    801054f7 <alltraps>

801060e2 <vector189>:
.globl vector189
vector189:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $189
801060e4:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801060e9:	e9 09 f4 ff ff       	jmp    801054f7 <alltraps>

801060ee <vector190>:
.globl vector190
vector190:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $190
801060f0:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801060f5:	e9 fd f3 ff ff       	jmp    801054f7 <alltraps>

801060fa <vector191>:
.globl vector191
vector191:
  pushl $0
801060fa:	6a 00                	push   $0x0
  pushl $191
801060fc:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106101:	e9 f1 f3 ff ff       	jmp    801054f7 <alltraps>

80106106 <vector192>:
.globl vector192
vector192:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $192
80106108:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010610d:	e9 e5 f3 ff ff       	jmp    801054f7 <alltraps>

80106112 <vector193>:
.globl vector193
vector193:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $193
80106114:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106119:	e9 d9 f3 ff ff       	jmp    801054f7 <alltraps>

8010611e <vector194>:
.globl vector194
vector194:
  pushl $0
8010611e:	6a 00                	push   $0x0
  pushl $194
80106120:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106125:	e9 cd f3 ff ff       	jmp    801054f7 <alltraps>

8010612a <vector195>:
.globl vector195
vector195:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $195
8010612c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106131:	e9 c1 f3 ff ff       	jmp    801054f7 <alltraps>

80106136 <vector196>:
.globl vector196
vector196:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $196
80106138:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010613d:	e9 b5 f3 ff ff       	jmp    801054f7 <alltraps>

80106142 <vector197>:
.globl vector197
vector197:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $197
80106144:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106149:	e9 a9 f3 ff ff       	jmp    801054f7 <alltraps>

8010614e <vector198>:
.globl vector198
vector198:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $198
80106150:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106155:	e9 9d f3 ff ff       	jmp    801054f7 <alltraps>

8010615a <vector199>:
.globl vector199
vector199:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $199
8010615c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106161:	e9 91 f3 ff ff       	jmp    801054f7 <alltraps>

80106166 <vector200>:
.globl vector200
vector200:
  pushl $0
80106166:	6a 00                	push   $0x0
  pushl $200
80106168:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010616d:	e9 85 f3 ff ff       	jmp    801054f7 <alltraps>

80106172 <vector201>:
.globl vector201
vector201:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $201
80106174:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106179:	e9 79 f3 ff ff       	jmp    801054f7 <alltraps>

8010617e <vector202>:
.globl vector202
vector202:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $202
80106180:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106185:	e9 6d f3 ff ff       	jmp    801054f7 <alltraps>

8010618a <vector203>:
.globl vector203
vector203:
  pushl $0
8010618a:	6a 00                	push   $0x0
  pushl $203
8010618c:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106191:	e9 61 f3 ff ff       	jmp    801054f7 <alltraps>

80106196 <vector204>:
.globl vector204
vector204:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $204
80106198:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010619d:	e9 55 f3 ff ff       	jmp    801054f7 <alltraps>

801061a2 <vector205>:
.globl vector205
vector205:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $205
801061a4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801061a9:	e9 49 f3 ff ff       	jmp    801054f7 <alltraps>

801061ae <vector206>:
.globl vector206
vector206:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $206
801061b0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801061b5:	e9 3d f3 ff ff       	jmp    801054f7 <alltraps>

801061ba <vector207>:
.globl vector207
vector207:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $207
801061bc:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801061c1:	e9 31 f3 ff ff       	jmp    801054f7 <alltraps>

801061c6 <vector208>:
.globl vector208
vector208:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $208
801061c8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801061cd:	e9 25 f3 ff ff       	jmp    801054f7 <alltraps>

801061d2 <vector209>:
.globl vector209
vector209:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $209
801061d4:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801061d9:	e9 19 f3 ff ff       	jmp    801054f7 <alltraps>

801061de <vector210>:
.globl vector210
vector210:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $210
801061e0:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801061e5:	e9 0d f3 ff ff       	jmp    801054f7 <alltraps>

801061ea <vector211>:
.globl vector211
vector211:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $211
801061ec:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801061f1:	e9 01 f3 ff ff       	jmp    801054f7 <alltraps>

801061f6 <vector212>:
.globl vector212
vector212:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $212
801061f8:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801061fd:	e9 f5 f2 ff ff       	jmp    801054f7 <alltraps>

80106202 <vector213>:
.globl vector213
vector213:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $213
80106204:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106209:	e9 e9 f2 ff ff       	jmp    801054f7 <alltraps>

8010620e <vector214>:
.globl vector214
vector214:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $214
80106210:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106215:	e9 dd f2 ff ff       	jmp    801054f7 <alltraps>

8010621a <vector215>:
.globl vector215
vector215:
  pushl $0
8010621a:	6a 00                	push   $0x0
  pushl $215
8010621c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106221:	e9 d1 f2 ff ff       	jmp    801054f7 <alltraps>

80106226 <vector216>:
.globl vector216
vector216:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $216
80106228:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010622d:	e9 c5 f2 ff ff       	jmp    801054f7 <alltraps>

80106232 <vector217>:
.globl vector217
vector217:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $217
80106234:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106239:	e9 b9 f2 ff ff       	jmp    801054f7 <alltraps>

8010623e <vector218>:
.globl vector218
vector218:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $218
80106240:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106245:	e9 ad f2 ff ff       	jmp    801054f7 <alltraps>

8010624a <vector219>:
.globl vector219
vector219:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $219
8010624c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106251:	e9 a1 f2 ff ff       	jmp    801054f7 <alltraps>

80106256 <vector220>:
.globl vector220
vector220:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $220
80106258:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010625d:	e9 95 f2 ff ff       	jmp    801054f7 <alltraps>

80106262 <vector221>:
.globl vector221
vector221:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $221
80106264:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106269:	e9 89 f2 ff ff       	jmp    801054f7 <alltraps>

8010626e <vector222>:
.globl vector222
vector222:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $222
80106270:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106275:	e9 7d f2 ff ff       	jmp    801054f7 <alltraps>

8010627a <vector223>:
.globl vector223
vector223:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $223
8010627c:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106281:	e9 71 f2 ff ff       	jmp    801054f7 <alltraps>

80106286 <vector224>:
.globl vector224
vector224:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $224
80106288:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010628d:	e9 65 f2 ff ff       	jmp    801054f7 <alltraps>

80106292 <vector225>:
.globl vector225
vector225:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $225
80106294:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106299:	e9 59 f2 ff ff       	jmp    801054f7 <alltraps>

8010629e <vector226>:
.globl vector226
vector226:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $226
801062a0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801062a5:	e9 4d f2 ff ff       	jmp    801054f7 <alltraps>

801062aa <vector227>:
.globl vector227
vector227:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $227
801062ac:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801062b1:	e9 41 f2 ff ff       	jmp    801054f7 <alltraps>

801062b6 <vector228>:
.globl vector228
vector228:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $228
801062b8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801062bd:	e9 35 f2 ff ff       	jmp    801054f7 <alltraps>

801062c2 <vector229>:
.globl vector229
vector229:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $229
801062c4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801062c9:	e9 29 f2 ff ff       	jmp    801054f7 <alltraps>

801062ce <vector230>:
.globl vector230
vector230:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $230
801062d0:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801062d5:	e9 1d f2 ff ff       	jmp    801054f7 <alltraps>

801062da <vector231>:
.globl vector231
vector231:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $231
801062dc:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801062e1:	e9 11 f2 ff ff       	jmp    801054f7 <alltraps>

801062e6 <vector232>:
.globl vector232
vector232:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $232
801062e8:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801062ed:	e9 05 f2 ff ff       	jmp    801054f7 <alltraps>

801062f2 <vector233>:
.globl vector233
vector233:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $233
801062f4:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801062f9:	e9 f9 f1 ff ff       	jmp    801054f7 <alltraps>

801062fe <vector234>:
.globl vector234
vector234:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $234
80106300:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106305:	e9 ed f1 ff ff       	jmp    801054f7 <alltraps>

8010630a <vector235>:
.globl vector235
vector235:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $235
8010630c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106311:	e9 e1 f1 ff ff       	jmp    801054f7 <alltraps>

80106316 <vector236>:
.globl vector236
vector236:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $236
80106318:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010631d:	e9 d5 f1 ff ff       	jmp    801054f7 <alltraps>

80106322 <vector237>:
.globl vector237
vector237:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $237
80106324:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106329:	e9 c9 f1 ff ff       	jmp    801054f7 <alltraps>

8010632e <vector238>:
.globl vector238
vector238:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $238
80106330:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106335:	e9 bd f1 ff ff       	jmp    801054f7 <alltraps>

8010633a <vector239>:
.globl vector239
vector239:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $239
8010633c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106341:	e9 b1 f1 ff ff       	jmp    801054f7 <alltraps>

80106346 <vector240>:
.globl vector240
vector240:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $240
80106348:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010634d:	e9 a5 f1 ff ff       	jmp    801054f7 <alltraps>

80106352 <vector241>:
.globl vector241
vector241:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $241
80106354:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106359:	e9 99 f1 ff ff       	jmp    801054f7 <alltraps>

8010635e <vector242>:
.globl vector242
vector242:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $242
80106360:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106365:	e9 8d f1 ff ff       	jmp    801054f7 <alltraps>

8010636a <vector243>:
.globl vector243
vector243:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $243
8010636c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106371:	e9 81 f1 ff ff       	jmp    801054f7 <alltraps>

80106376 <vector244>:
.globl vector244
vector244:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $244
80106378:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010637d:	e9 75 f1 ff ff       	jmp    801054f7 <alltraps>

80106382 <vector245>:
.globl vector245
vector245:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $245
80106384:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106389:	e9 69 f1 ff ff       	jmp    801054f7 <alltraps>

8010638e <vector246>:
.globl vector246
vector246:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $246
80106390:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106395:	e9 5d f1 ff ff       	jmp    801054f7 <alltraps>

8010639a <vector247>:
.globl vector247
vector247:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $247
8010639c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801063a1:	e9 51 f1 ff ff       	jmp    801054f7 <alltraps>

801063a6 <vector248>:
.globl vector248
vector248:
  pushl $0
801063a6:	6a 00                	push   $0x0
  pushl $248
801063a8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801063ad:	e9 45 f1 ff ff       	jmp    801054f7 <alltraps>

801063b2 <vector249>:
.globl vector249
vector249:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $249
801063b4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801063b9:	e9 39 f1 ff ff       	jmp    801054f7 <alltraps>

801063be <vector250>:
.globl vector250
vector250:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $250
801063c0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801063c5:	e9 2d f1 ff ff       	jmp    801054f7 <alltraps>

801063ca <vector251>:
.globl vector251
vector251:
  pushl $0
801063ca:	6a 00                	push   $0x0
  pushl $251
801063cc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801063d1:	e9 21 f1 ff ff       	jmp    801054f7 <alltraps>

801063d6 <vector252>:
.globl vector252
vector252:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $252
801063d8:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801063dd:	e9 15 f1 ff ff       	jmp    801054f7 <alltraps>

801063e2 <vector253>:
.globl vector253
vector253:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $253
801063e4:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801063e9:	e9 09 f1 ff ff       	jmp    801054f7 <alltraps>

801063ee <vector254>:
.globl vector254
vector254:
  pushl $0
801063ee:	6a 00                	push   $0x0
  pushl $254
801063f0:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801063f5:	e9 fd f0 ff ff       	jmp    801054f7 <alltraps>

801063fa <vector255>:
.globl vector255
vector255:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $255
801063fc:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106401:	e9 f1 f0 ff ff       	jmp    801054f7 <alltraps>
80106406:	66 90                	xchg   %ax,%ax
80106408:	66 90                	xchg   %ax,%ax
8010640a:	66 90                	xchg   %ax,%ax
8010640c:	66 90                	xchg   %ax,%ax
8010640e:	66 90                	xchg   %ax,%ax

80106410 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	57                   	push   %edi
80106414:	56                   	push   %esi
80106415:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106417:	c1 ea 16             	shr    $0x16,%edx
{
8010641a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010641b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010641e:	83 ec 1c             	sub    $0x1c,%esp
  if(*pde & PTE_P){
80106421:	8b 1f                	mov    (%edi),%ebx
80106423:	f6 c3 01             	test   $0x1,%bl
80106426:	74 28                	je     80106450 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106428:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010642e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106434:	c1 ee 0a             	shr    $0xa,%esi
}
80106437:	83 c4 1c             	add    $0x1c,%esp
  return &pgtab[PTX(va)];
8010643a:	89 f2                	mov    %esi,%edx
8010643c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106442:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106445:	5b                   	pop    %ebx
80106446:	5e                   	pop    %esi
80106447:	5f                   	pop    %edi
80106448:	5d                   	pop    %ebp
80106449:	c3                   	ret    
8010644a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106450:	85 c9                	test   %ecx,%ecx
80106452:	74 34                	je     80106488 <walkpgdir+0x78>
80106454:	e8 57 c0 ff ff       	call   801024b0 <kalloc>
80106459:	85 c0                	test   %eax,%eax
8010645b:	89 c3                	mov    %eax,%ebx
8010645d:	74 29                	je     80106488 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
8010645f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106466:	00 
80106467:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010646e:	00 
8010646f:	89 04 24             	mov    %eax,(%esp)
80106472:	e8 29 df ff ff       	call   801043a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106477:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010647d:	83 c8 07             	or     $0x7,%eax
80106480:	89 07                	mov    %eax,(%edi)
80106482:	eb b0                	jmp    80106434 <walkpgdir+0x24>
80106484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80106488:	83 c4 1c             	add    $0x1c,%esp
      return 0;
8010648b:	31 c0                	xor    %eax,%eax
}
8010648d:	5b                   	pop    %ebx
8010648e:	5e                   	pop    %esi
8010648f:	5f                   	pop    %edi
80106490:	5d                   	pop    %ebp
80106491:	c3                   	ret    
80106492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064a0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	57                   	push   %edi
801064a4:	56                   	push   %esi
801064a5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801064a6:	89 d3                	mov    %edx,%ebx
{
801064a8:	83 ec 1c             	sub    $0x1c,%esp
801064ab:	8b 7d 08             	mov    0x8(%ebp),%edi
  a = (char*)PGROUNDDOWN((uint)va);
801064ae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801064b4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801064b7:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801064bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801064be:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801064c2:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
801064c9:	29 df                	sub    %ebx,%edi
801064cb:	eb 18                	jmp    801064e5 <mappages+0x45>
801064cd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*pte & PTE_P)
801064d0:	f6 00 01             	testb  $0x1,(%eax)
801064d3:	75 3d                	jne    80106512 <mappages+0x72>
    *pte = pa | perm | PTE_P;
801064d5:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
801064d8:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801064db:	89 30                	mov    %esi,(%eax)
    if(a == last)
801064dd:	74 29                	je     80106508 <mappages+0x68>
      break;
    a += PGSIZE;
801064df:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801064e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801064e8:	b9 01 00 00 00       	mov    $0x1,%ecx
801064ed:	89 da                	mov    %ebx,%edx
801064ef:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801064f2:	e8 19 ff ff ff       	call   80106410 <walkpgdir>
801064f7:	85 c0                	test   %eax,%eax
801064f9:	75 d5                	jne    801064d0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801064fb:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801064fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106503:	5b                   	pop    %ebx
80106504:	5e                   	pop    %esi
80106505:	5f                   	pop    %edi
80106506:	5d                   	pop    %ebp
80106507:	c3                   	ret    
80106508:	83 c4 1c             	add    $0x1c,%esp
  return 0;
8010650b:	31 c0                	xor    %eax,%eax
}
8010650d:	5b                   	pop    %ebx
8010650e:	5e                   	pop    %esi
8010650f:	5f                   	pop    %edi
80106510:	5d                   	pop    %ebp
80106511:	c3                   	ret    
      panic("remap");
80106512:	c7 04 24 0c 76 10 80 	movl   $0x8010760c,(%esp)
80106519:	e8 42 9e ff ff       	call   80100360 <panic>
8010651e:	66 90                	xchg   %ax,%ax

80106520 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106520:	55                   	push   %ebp
80106521:	89 e5                	mov    %esp,%ebp
80106523:	57                   	push   %edi
80106524:	89 c7                	mov    %eax,%edi
80106526:	56                   	push   %esi
80106527:	89 d6                	mov    %edx,%esi
80106529:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010652a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106530:	83 ec 1c             	sub    $0x1c,%esp
  a = PGROUNDUP(newsz);
80106533:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106539:	39 d3                	cmp    %edx,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010653b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010653e:	72 3b                	jb     8010657b <deallocuvm.part.0+0x5b>
80106540:	eb 5e                	jmp    801065a0 <deallocuvm.part.0+0x80>
80106542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106548:	8b 10                	mov    (%eax),%edx
8010654a:	f6 c2 01             	test   $0x1,%dl
8010654d:	74 22                	je     80106571 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010654f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106555:	74 54                	je     801065ab <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106557:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010655d:	89 14 24             	mov    %edx,(%esp)
80106560:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106563:	e8 98 bd ff ff       	call   80102300 <kfree>
      *pte = 0;
80106568:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010656b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106571:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106577:	39 f3                	cmp    %esi,%ebx
80106579:	73 25                	jae    801065a0 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010657b:	31 c9                	xor    %ecx,%ecx
8010657d:	89 da                	mov    %ebx,%edx
8010657f:	89 f8                	mov    %edi,%eax
80106581:	e8 8a fe ff ff       	call   80106410 <walkpgdir>
    if(!pte)
80106586:	85 c0                	test   %eax,%eax
80106588:	75 be                	jne    80106548 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010658a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106590:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106596:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010659c:	39 f3                	cmp    %esi,%ebx
8010659e:	72 db                	jb     8010657b <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
801065a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801065a3:	83 c4 1c             	add    $0x1c,%esp
801065a6:	5b                   	pop    %ebx
801065a7:	5e                   	pop    %esi
801065a8:	5f                   	pop    %edi
801065a9:	5d                   	pop    %ebp
801065aa:	c3                   	ret    
        panic("kfree");
801065ab:	c7 04 24 86 6f 10 80 	movl   $0x80106f86,(%esp)
801065b2:	e8 a9 9d ff ff       	call   80100360 <panic>
801065b7:	89 f6                	mov    %esi,%esi
801065b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065c0 <seginit>:
{
801065c0:	55                   	push   %ebp
801065c1:	89 e5                	mov    %esp,%ebp
801065c3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801065c6:	e8 d5 d0 ff ff       	call   801036a0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801065cb:	31 c9                	xor    %ecx,%ecx
801065cd:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c = &cpus[cpuid()];
801065d2:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801065d8:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801065dd:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801065e1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  lgdt(c->gdt, sizeof(c->gdt));
801065e6:	83 c0 70             	add    $0x70,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801065e9:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801065ed:	31 c9                	xor    %ecx,%ecx
801065ef:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801065f3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801065f8:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801065fc:	31 c9                	xor    %ecx,%ecx
801065fe:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106602:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106607:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010660b:	31 c9                	xor    %ecx,%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010660d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106611:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106615:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106619:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010661d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106621:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106625:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106629:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010662d:	66 89 50 20          	mov    %dx,0x20(%eax)
  pd[0] = size-1;
80106631:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106636:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010663a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010663e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106642:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106646:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
8010664a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010664e:	66 89 48 22          	mov    %cx,0x22(%eax)
80106652:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106656:	c6 40 27 00          	movb   $0x0,0x27(%eax)
8010665a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
8010665e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106662:	c1 e8 10             	shr    $0x10,%eax
80106665:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106669:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010666c:	0f 01 10             	lgdtl  (%eax)
}
8010666f:	c9                   	leave  
80106670:	c3                   	ret    
80106671:	eb 0d                	jmp    80106680 <switchkvm>
80106673:	90                   	nop
80106674:	90                   	nop
80106675:	90                   	nop
80106676:	90                   	nop
80106677:	90                   	nop
80106678:	90                   	nop
80106679:	90                   	nop
8010667a:	90                   	nop
8010667b:	90                   	nop
8010667c:	90                   	nop
8010667d:	90                   	nop
8010667e:	90                   	nop
8010667f:	90                   	nop

80106680 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106680:	a1 a4 58 11 80       	mov    0x801158a4,%eax
{
80106685:	55                   	push   %ebp
80106686:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106688:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010668d:	0f 22 d8             	mov    %eax,%cr3
}
80106690:	5d                   	pop    %ebp
80106691:	c3                   	ret    
80106692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801066a0 <switchuvm>:
{
801066a0:	55                   	push   %ebp
801066a1:	89 e5                	mov    %esp,%ebp
801066a3:	57                   	push   %edi
801066a4:	56                   	push   %esi
801066a5:	53                   	push   %ebx
801066a6:	83 ec 1c             	sub    $0x1c,%esp
801066a9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801066ac:	85 f6                	test   %esi,%esi
801066ae:	0f 84 cd 00 00 00    	je     80106781 <switchuvm+0xe1>
  if(p->kstack == 0)
801066b4:	8b 46 08             	mov    0x8(%esi),%eax
801066b7:	85 c0                	test   %eax,%eax
801066b9:	0f 84 da 00 00 00    	je     80106799 <switchuvm+0xf9>
  if(p->pgdir == 0)
801066bf:	8b 7e 04             	mov    0x4(%esi),%edi
801066c2:	85 ff                	test   %edi,%edi
801066c4:	0f 84 c3 00 00 00    	je     8010678d <switchuvm+0xed>
  pushcli();
801066ca:	e8 21 db ff ff       	call   801041f0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801066cf:	e8 4c cf ff ff       	call   80103620 <mycpu>
801066d4:	89 c3                	mov    %eax,%ebx
801066d6:	e8 45 cf ff ff       	call   80103620 <mycpu>
801066db:	89 c7                	mov    %eax,%edi
801066dd:	e8 3e cf ff ff       	call   80103620 <mycpu>
801066e2:	83 c7 08             	add    $0x8,%edi
801066e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066e8:	e8 33 cf ff ff       	call   80103620 <mycpu>
801066ed:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801066f0:	ba 67 00 00 00       	mov    $0x67,%edx
801066f5:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
801066fc:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106703:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
8010670a:	83 c1 08             	add    $0x8,%ecx
8010670d:	c1 e9 10             	shr    $0x10,%ecx
80106710:	83 c0 08             	add    $0x8,%eax
80106713:	c1 e8 18             	shr    $0x18,%eax
80106716:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010671c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106723:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106729:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
8010672e:	e8 ed ce ff ff       	call   80103620 <mycpu>
80106733:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010673a:	e8 e1 ce ff ff       	call   80103620 <mycpu>
8010673f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106744:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106748:	e8 d3 ce ff ff       	call   80103620 <mycpu>
8010674d:	8b 56 08             	mov    0x8(%esi),%edx
80106750:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106756:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106759:	e8 c2 ce ff ff       	call   80103620 <mycpu>
8010675e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106762:	b8 28 00 00 00       	mov    $0x28,%eax
80106767:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010676a:	8b 46 04             	mov    0x4(%esi),%eax
8010676d:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106772:	0f 22 d8             	mov    %eax,%cr3
}
80106775:	83 c4 1c             	add    $0x1c,%esp
80106778:	5b                   	pop    %ebx
80106779:	5e                   	pop    %esi
8010677a:	5f                   	pop    %edi
8010677b:	5d                   	pop    %ebp
  popcli();
8010677c:	e9 af da ff ff       	jmp    80104230 <popcli>
    panic("switchuvm: no process");
80106781:	c7 04 24 12 76 10 80 	movl   $0x80107612,(%esp)
80106788:	e8 d3 9b ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
8010678d:	c7 04 24 3d 76 10 80 	movl   $0x8010763d,(%esp)
80106794:	e8 c7 9b ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
80106799:	c7 04 24 28 76 10 80 	movl   $0x80107628,(%esp)
801067a0:	e8 bb 9b ff ff       	call   80100360 <panic>
801067a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801067a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067b0 <inituvm>:
{
801067b0:	55                   	push   %ebp
801067b1:	89 e5                	mov    %esp,%ebp
801067b3:	57                   	push   %edi
801067b4:	56                   	push   %esi
801067b5:	53                   	push   %ebx
801067b6:	83 ec 1c             	sub    $0x1c,%esp
801067b9:	8b 75 10             	mov    0x10(%ebp),%esi
801067bc:	8b 45 08             	mov    0x8(%ebp),%eax
801067bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801067c2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801067c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801067cb:	77 54                	ja     80106821 <inituvm+0x71>
  mem = kalloc();
801067cd:	e8 de bc ff ff       	call   801024b0 <kalloc>
  memset(mem, 0, PGSIZE);
801067d2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801067d9:	00 
801067da:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801067e1:	00 
  mem = kalloc();
801067e2:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801067e4:	89 04 24             	mov    %eax,(%esp)
801067e7:	e8 b4 db ff ff       	call   801043a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801067ec:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801067f2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801067f7:	89 04 24             	mov    %eax,(%esp)
801067fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067fd:	31 d2                	xor    %edx,%edx
801067ff:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106806:	00 
80106807:	e8 94 fc ff ff       	call   801064a0 <mappages>
  memmove(mem, init, sz);
8010680c:	89 75 10             	mov    %esi,0x10(%ebp)
8010680f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106812:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106815:	83 c4 1c             	add    $0x1c,%esp
80106818:	5b                   	pop    %ebx
80106819:	5e                   	pop    %esi
8010681a:	5f                   	pop    %edi
8010681b:	5d                   	pop    %ebp
  memmove(mem, init, sz);
8010681c:	e9 1f dc ff ff       	jmp    80104440 <memmove>
    panic("inituvm: more than a page");
80106821:	c7 04 24 51 76 10 80 	movl   $0x80107651,(%esp)
80106828:	e8 33 9b ff ff       	call   80100360 <panic>
8010682d:	8d 76 00             	lea    0x0(%esi),%esi

80106830 <loaduvm>:
{
80106830:	55                   	push   %ebp
80106831:	89 e5                	mov    %esp,%ebp
80106833:	57                   	push   %edi
80106834:	56                   	push   %esi
80106835:	53                   	push   %ebx
80106836:	83 ec 1c             	sub    $0x1c,%esp
  if((uint) addr % PGSIZE != 0)
80106839:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106840:	0f 85 98 00 00 00    	jne    801068de <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
80106846:	8b 75 18             	mov    0x18(%ebp),%esi
80106849:	31 db                	xor    %ebx,%ebx
8010684b:	85 f6                	test   %esi,%esi
8010684d:	75 1a                	jne    80106869 <loaduvm+0x39>
8010684f:	eb 77                	jmp    801068c8 <loaduvm+0x98>
80106851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106858:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010685e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106864:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106867:	76 5f                	jbe    801068c8 <loaduvm+0x98>
80106869:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010686c:	31 c9                	xor    %ecx,%ecx
8010686e:	8b 45 08             	mov    0x8(%ebp),%eax
80106871:	01 da                	add    %ebx,%edx
80106873:	e8 98 fb ff ff       	call   80106410 <walkpgdir>
80106878:	85 c0                	test   %eax,%eax
8010687a:	74 56                	je     801068d2 <loaduvm+0xa2>
    pa = PTE_ADDR(*pte);
8010687c:	8b 00                	mov    (%eax),%eax
      n = PGSIZE;
8010687e:	bf 00 10 00 00       	mov    $0x1000,%edi
80106883:	8b 4d 14             	mov    0x14(%ebp),%ecx
    pa = PTE_ADDR(*pte);
80106886:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = PGSIZE;
8010688b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106891:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106894:	05 00 00 00 80       	add    $0x80000000,%eax
80106899:	89 44 24 04          	mov    %eax,0x4(%esp)
8010689d:	8b 45 10             	mov    0x10(%ebp),%eax
801068a0:	01 d9                	add    %ebx,%ecx
801068a2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
801068a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801068aa:	89 04 24             	mov    %eax,(%esp)
801068ad:	e8 be b0 ff ff       	call   80101970 <readi>
801068b2:	39 f8                	cmp    %edi,%eax
801068b4:	74 a2                	je     80106858 <loaduvm+0x28>
}
801068b6:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801068b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068be:	5b                   	pop    %ebx
801068bf:	5e                   	pop    %esi
801068c0:	5f                   	pop    %edi
801068c1:	5d                   	pop    %ebp
801068c2:	c3                   	ret    
801068c3:	90                   	nop
801068c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801068c8:	83 c4 1c             	add    $0x1c,%esp
  return 0;
801068cb:	31 c0                	xor    %eax,%eax
}
801068cd:	5b                   	pop    %ebx
801068ce:	5e                   	pop    %esi
801068cf:	5f                   	pop    %edi
801068d0:	5d                   	pop    %ebp
801068d1:	c3                   	ret    
      panic("loaduvm: address should exist");
801068d2:	c7 04 24 6b 76 10 80 	movl   $0x8010766b,(%esp)
801068d9:	e8 82 9a ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
801068de:	c7 04 24 0c 77 10 80 	movl   $0x8010770c,(%esp)
801068e5:	e8 76 9a ff ff       	call   80100360 <panic>
801068ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801068f0 <allocuvm>:
{
801068f0:	55                   	push   %ebp
801068f1:	89 e5                	mov    %esp,%ebp
801068f3:	57                   	push   %edi
801068f4:	56                   	push   %esi
801068f5:	53                   	push   %ebx
801068f6:	83 ec 1c             	sub    $0x1c,%esp
801068f9:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
801068fc:	85 ff                	test   %edi,%edi
801068fe:	0f 88 7e 00 00 00    	js     80106982 <allocuvm+0x92>
  if(newsz < oldsz)
80106904:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106907:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
8010690a:	72 78                	jb     80106984 <allocuvm+0x94>
  a = PGROUNDUP(oldsz);
8010690c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106912:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106918:	39 df                	cmp    %ebx,%edi
8010691a:	77 4a                	ja     80106966 <allocuvm+0x76>
8010691c:	eb 72                	jmp    80106990 <allocuvm+0xa0>
8010691e:	66 90                	xchg   %ax,%ax
    memset(mem, 0, PGSIZE);
80106920:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106927:	00 
80106928:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010692f:	00 
80106930:	89 04 24             	mov    %eax,(%esp)
80106933:	e8 68 da ff ff       	call   801043a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106938:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010693e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106943:	89 04 24             	mov    %eax,(%esp)
80106946:	8b 45 08             	mov    0x8(%ebp),%eax
80106949:	89 da                	mov    %ebx,%edx
8010694b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106952:	00 
80106953:	e8 48 fb ff ff       	call   801064a0 <mappages>
80106958:	85 c0                	test   %eax,%eax
8010695a:	78 44                	js     801069a0 <allocuvm+0xb0>
  for(; a < newsz; a += PGSIZE){
8010695c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106962:	39 df                	cmp    %ebx,%edi
80106964:	76 2a                	jbe    80106990 <allocuvm+0xa0>
    mem = kalloc();
80106966:	e8 45 bb ff ff       	call   801024b0 <kalloc>
    if(mem == 0){
8010696b:	85 c0                	test   %eax,%eax
    mem = kalloc();
8010696d:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010696f:	75 af                	jne    80106920 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106971:	c7 04 24 89 76 10 80 	movl   $0x80107689,(%esp)
80106978:	e8 d3 9c ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
8010697d:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106980:	77 48                	ja     801069ca <allocuvm+0xda>
      return 0;
80106982:	31 c0                	xor    %eax,%eax
}
80106984:	83 c4 1c             	add    $0x1c,%esp
80106987:	5b                   	pop    %ebx
80106988:	5e                   	pop    %esi
80106989:	5f                   	pop    %edi
8010698a:	5d                   	pop    %ebp
8010698b:	c3                   	ret    
8010698c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106990:	83 c4 1c             	add    $0x1c,%esp
80106993:	89 f8                	mov    %edi,%eax
80106995:	5b                   	pop    %ebx
80106996:	5e                   	pop    %esi
80106997:	5f                   	pop    %edi
80106998:	5d                   	pop    %ebp
80106999:	c3                   	ret    
8010699a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801069a0:	c7 04 24 a1 76 10 80 	movl   $0x801076a1,(%esp)
801069a7:	e8 a4 9c ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
801069ac:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801069af:	76 0d                	jbe    801069be <allocuvm+0xce>
801069b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801069b4:	89 fa                	mov    %edi,%edx
801069b6:	8b 45 08             	mov    0x8(%ebp),%eax
801069b9:	e8 62 fb ff ff       	call   80106520 <deallocuvm.part.0>
      kfree(mem);
801069be:	89 34 24             	mov    %esi,(%esp)
801069c1:	e8 3a b9 ff ff       	call   80102300 <kfree>
      return 0;
801069c6:	31 c0                	xor    %eax,%eax
801069c8:	eb ba                	jmp    80106984 <allocuvm+0x94>
801069ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801069cd:	89 fa                	mov    %edi,%edx
801069cf:	8b 45 08             	mov    0x8(%ebp),%eax
801069d2:	e8 49 fb ff ff       	call   80106520 <deallocuvm.part.0>
      return 0;
801069d7:	31 c0                	xor    %eax,%eax
801069d9:	eb a9                	jmp    80106984 <allocuvm+0x94>
801069db:	90                   	nop
801069dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801069e0 <deallocuvm>:
{
801069e0:	55                   	push   %ebp
801069e1:	89 e5                	mov    %esp,%ebp
801069e3:	8b 55 0c             	mov    0xc(%ebp),%edx
801069e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801069e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801069ec:	39 d1                	cmp    %edx,%ecx
801069ee:	73 08                	jae    801069f8 <deallocuvm+0x18>
}
801069f0:	5d                   	pop    %ebp
801069f1:	e9 2a fb ff ff       	jmp    80106520 <deallocuvm.part.0>
801069f6:	66 90                	xchg   %ax,%ax
801069f8:	89 d0                	mov    %edx,%eax
801069fa:	5d                   	pop    %ebp
801069fb:	c3                   	ret    
801069fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a00 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106a00:	55                   	push   %ebp
80106a01:	89 e5                	mov    %esp,%ebp
80106a03:	56                   	push   %esi
80106a04:	53                   	push   %ebx
80106a05:	83 ec 10             	sub    $0x10,%esp
80106a08:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106a0b:	85 f6                	test   %esi,%esi
80106a0d:	74 59                	je     80106a68 <freevm+0x68>
80106a0f:	31 c9                	xor    %ecx,%ecx
80106a11:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106a16:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106a18:	31 db                	xor    %ebx,%ebx
80106a1a:	e8 01 fb ff ff       	call   80106520 <deallocuvm.part.0>
80106a1f:	eb 12                	jmp    80106a33 <freevm+0x33>
80106a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a28:	83 c3 01             	add    $0x1,%ebx
80106a2b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106a31:	74 27                	je     80106a5a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106a33:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106a36:	f6 c2 01             	test   $0x1,%dl
80106a39:	74 ed                	je     80106a28 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106a3b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(i = 0; i < NPDENTRIES; i++){
80106a41:	83 c3 01             	add    $0x1,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106a44:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106a4a:	89 14 24             	mov    %edx,(%esp)
80106a4d:	e8 ae b8 ff ff       	call   80102300 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80106a52:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106a58:	75 d9                	jne    80106a33 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
80106a5a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106a5d:	83 c4 10             	add    $0x10,%esp
80106a60:	5b                   	pop    %ebx
80106a61:	5e                   	pop    %esi
80106a62:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106a63:	e9 98 b8 ff ff       	jmp    80102300 <kfree>
    panic("freevm: no pgdir");
80106a68:	c7 04 24 bd 76 10 80 	movl   $0x801076bd,(%esp)
80106a6f:	e8 ec 98 ff ff       	call   80100360 <panic>
80106a74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106a80 <setupkvm>:
{
80106a80:	55                   	push   %ebp
80106a81:	89 e5                	mov    %esp,%ebp
80106a83:	56                   	push   %esi
80106a84:	53                   	push   %ebx
80106a85:	83 ec 10             	sub    $0x10,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
80106a88:	e8 23 ba ff ff       	call   801024b0 <kalloc>
80106a8d:	85 c0                	test   %eax,%eax
80106a8f:	89 c6                	mov    %eax,%esi
80106a91:	74 6d                	je     80106b00 <setupkvm+0x80>
  memset(pgdir, 0, PGSIZE);
80106a93:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106a9a:	00 
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a9b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106aa0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106aa7:	00 
80106aa8:	89 04 24             	mov    %eax,(%esp)
80106aab:	e8 f0 d8 ff ff       	call   801043a0 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106ab0:	8b 53 0c             	mov    0xc(%ebx),%edx
80106ab3:	8b 43 04             	mov    0x4(%ebx),%eax
80106ab6:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106ab9:	89 54 24 04          	mov    %edx,0x4(%esp)
80106abd:	8b 13                	mov    (%ebx),%edx
80106abf:	89 04 24             	mov    %eax,(%esp)
80106ac2:	29 c1                	sub    %eax,%ecx
80106ac4:	89 f0                	mov    %esi,%eax
80106ac6:	e8 d5 f9 ff ff       	call   801064a0 <mappages>
80106acb:	85 c0                	test   %eax,%eax
80106acd:	78 19                	js     80106ae8 <setupkvm+0x68>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106acf:	83 c3 10             	add    $0x10,%ebx
80106ad2:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106ad8:	72 d6                	jb     80106ab0 <setupkvm+0x30>
80106ada:	89 f0                	mov    %esi,%eax
}
80106adc:	83 c4 10             	add    $0x10,%esp
80106adf:	5b                   	pop    %ebx
80106ae0:	5e                   	pop    %esi
80106ae1:	5d                   	pop    %ebp
80106ae2:	c3                   	ret    
80106ae3:	90                   	nop
80106ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106ae8:	89 34 24             	mov    %esi,(%esp)
80106aeb:	e8 10 ff ff ff       	call   80106a00 <freevm>
}
80106af0:	83 c4 10             	add    $0x10,%esp
      return 0;
80106af3:	31 c0                	xor    %eax,%eax
}
80106af5:	5b                   	pop    %ebx
80106af6:	5e                   	pop    %esi
80106af7:	5d                   	pop    %ebp
80106af8:	c3                   	ret    
80106af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106b00:	31 c0                	xor    %eax,%eax
80106b02:	eb d8                	jmp    80106adc <setupkvm+0x5c>
80106b04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b10 <kvmalloc>:
{
80106b10:	55                   	push   %ebp
80106b11:	89 e5                	mov    %esp,%ebp
80106b13:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106b16:	e8 65 ff ff ff       	call   80106a80 <setupkvm>
80106b1b:	a3 a4 58 11 80       	mov    %eax,0x801158a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106b20:	05 00 00 00 80       	add    $0x80000000,%eax
80106b25:	0f 22 d8             	mov    %eax,%cr3
}
80106b28:	c9                   	leave  
80106b29:	c3                   	ret    
80106b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b30 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106b30:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106b31:	31 c9                	xor    %ecx,%ecx
{
80106b33:	89 e5                	mov    %esp,%ebp
80106b35:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106b38:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b3b:	8b 45 08             	mov    0x8(%ebp),%eax
80106b3e:	e8 cd f8 ff ff       	call   80106410 <walkpgdir>
  if(pte == 0)
80106b43:	85 c0                	test   %eax,%eax
80106b45:	74 05                	je     80106b4c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106b47:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106b4a:	c9                   	leave  
80106b4b:	c3                   	ret    
    panic("clearpteu");
80106b4c:	c7 04 24 ce 76 10 80 	movl   $0x801076ce,(%esp)
80106b53:	e8 08 98 ff ff       	call   80100360 <panic>
80106b58:	90                   	nop
80106b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106b60 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	57                   	push   %edi
80106b64:	56                   	push   %esi
80106b65:	53                   	push   %ebx
80106b66:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106b69:	e8 12 ff ff ff       	call   80106a80 <setupkvm>
80106b6e:	85 c0                	test   %eax,%eax
80106b70:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106b73:	0f 84 b9 00 00 00    	je     80106c32 <copyuvm+0xd2>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106b79:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b7c:	85 c0                	test   %eax,%eax
80106b7e:	0f 84 94 00 00 00    	je     80106c18 <copyuvm+0xb8>
80106b84:	31 ff                	xor    %edi,%edi
80106b86:	eb 48                	jmp    80106bd0 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106b88:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106b8e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b95:	00 
80106b96:	89 74 24 04          	mov    %esi,0x4(%esp)
80106b9a:	89 04 24             	mov    %eax,(%esp)
80106b9d:	e8 9e d8 ff ff       	call   80104440 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106ba2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ba5:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106baa:	89 fa                	mov    %edi,%edx
80106bac:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bb0:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106bb6:	89 04 24             	mov    %eax,(%esp)
80106bb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106bbc:	e8 df f8 ff ff       	call   801064a0 <mappages>
80106bc1:	85 c0                	test   %eax,%eax
80106bc3:	78 63                	js     80106c28 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106bc5:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106bcb:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106bce:	76 48                	jbe    80106c18 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106bd0:	8b 45 08             	mov    0x8(%ebp),%eax
80106bd3:	31 c9                	xor    %ecx,%ecx
80106bd5:	89 fa                	mov    %edi,%edx
80106bd7:	e8 34 f8 ff ff       	call   80106410 <walkpgdir>
80106bdc:	85 c0                	test   %eax,%eax
80106bde:	74 62                	je     80106c42 <copyuvm+0xe2>
    if(!(*pte & PTE_P))
80106be0:	8b 00                	mov    (%eax),%eax
80106be2:	a8 01                	test   $0x1,%al
80106be4:	74 50                	je     80106c36 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80106be6:	89 c6                	mov    %eax,%esi
    flags = PTE_FLAGS(*pte);
80106be8:	25 ff 0f 00 00       	and    $0xfff,%eax
80106bed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106bf0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    if((mem = kalloc()) == 0)
80106bf6:	e8 b5 b8 ff ff       	call   801024b0 <kalloc>
80106bfb:	85 c0                	test   %eax,%eax
80106bfd:	89 c3                	mov    %eax,%ebx
80106bff:	75 87                	jne    80106b88 <copyuvm+0x28>
    }
  }
  return d;

bad:
  freevm(d);
80106c01:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c04:	89 04 24             	mov    %eax,(%esp)
80106c07:	e8 f4 fd ff ff       	call   80106a00 <freevm>
  return 0;
80106c0c:	31 c0                	xor    %eax,%eax
}
80106c0e:	83 c4 2c             	add    $0x2c,%esp
80106c11:	5b                   	pop    %ebx
80106c12:	5e                   	pop    %esi
80106c13:	5f                   	pop    %edi
80106c14:	5d                   	pop    %ebp
80106c15:	c3                   	ret    
80106c16:	66 90                	xchg   %ax,%ax
80106c18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c1b:	83 c4 2c             	add    $0x2c,%esp
80106c1e:	5b                   	pop    %ebx
80106c1f:	5e                   	pop    %esi
80106c20:	5f                   	pop    %edi
80106c21:	5d                   	pop    %ebp
80106c22:	c3                   	ret    
80106c23:	90                   	nop
80106c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80106c28:	89 1c 24             	mov    %ebx,(%esp)
80106c2b:	e8 d0 b6 ff ff       	call   80102300 <kfree>
      goto bad;
80106c30:	eb cf                	jmp    80106c01 <copyuvm+0xa1>
    return 0;
80106c32:	31 c0                	xor    %eax,%eax
80106c34:	eb d8                	jmp    80106c0e <copyuvm+0xae>
      panic("copyuvm: page not present");
80106c36:	c7 04 24 f2 76 10 80 	movl   $0x801076f2,(%esp)
80106c3d:	e8 1e 97 ff ff       	call   80100360 <panic>
      panic("copyuvm: pte should exist");
80106c42:	c7 04 24 d8 76 10 80 	movl   $0x801076d8,(%esp)
80106c49:	e8 12 97 ff ff       	call   80100360 <panic>
80106c4e:	66 90                	xchg   %ax,%ax

80106c50 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106c50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c51:	31 c9                	xor    %ecx,%ecx
{
80106c53:	89 e5                	mov    %esp,%ebp
80106c55:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106c58:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c5b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c5e:	e8 ad f7 ff ff       	call   80106410 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106c63:	8b 00                	mov    (%eax),%eax
80106c65:	89 c2                	mov    %eax,%edx
80106c67:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106c6a:	83 fa 05             	cmp    $0x5,%edx
80106c6d:	75 11                	jne    80106c80 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106c6f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c74:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106c79:	c9                   	leave  
80106c7a:	c3                   	ret    
80106c7b:	90                   	nop
80106c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106c80:	31 c0                	xor    %eax,%eax
}
80106c82:	c9                   	leave  
80106c83:	c3                   	ret    
80106c84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c90 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	57                   	push   %edi
80106c94:	56                   	push   %esi
80106c95:	53                   	push   %ebx
80106c96:	83 ec 1c             	sub    $0x1c,%esp
80106c99:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106c9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c9f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106ca2:	85 db                	test   %ebx,%ebx
80106ca4:	75 3a                	jne    80106ce0 <copyout+0x50>
80106ca6:	eb 68                	jmp    80106d10 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106ca8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106cab:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106cad:	89 7c 24 04          	mov    %edi,0x4(%esp)
    n = PGSIZE - (va - va0);
80106cb1:	29 ca                	sub    %ecx,%edx
80106cb3:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106cb9:	39 da                	cmp    %ebx,%edx
80106cbb:	0f 47 d3             	cmova  %ebx,%edx
    memmove(pa0 + (va - va0), buf, n);
80106cbe:	29 f1                	sub    %esi,%ecx
80106cc0:	01 c8                	add    %ecx,%eax
80106cc2:	89 54 24 08          	mov    %edx,0x8(%esp)
80106cc6:	89 04 24             	mov    %eax,(%esp)
80106cc9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106ccc:	e8 6f d7 ff ff       	call   80104440 <memmove>
    len -= n;
    buf += n;
80106cd1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106cd4:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    buf += n;
80106cda:	01 d7                	add    %edx,%edi
  while(len > 0){
80106cdc:	29 d3                	sub    %edx,%ebx
80106cde:	74 30                	je     80106d10 <copyout+0x80>
    pa0 = uva2ka(pgdir, (char*)va0);
80106ce0:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
80106ce3:	89 ce                	mov    %ecx,%esi
80106ce5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106ceb:	89 74 24 04          	mov    %esi,0x4(%esp)
    va0 = (uint)PGROUNDDOWN(va);
80106cef:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106cf2:	89 04 24             	mov    %eax,(%esp)
80106cf5:	e8 56 ff ff ff       	call   80106c50 <uva2ka>
    if(pa0 == 0)
80106cfa:	85 c0                	test   %eax,%eax
80106cfc:	75 aa                	jne    80106ca8 <copyout+0x18>
  }
  return 0;
}
80106cfe:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106d01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d06:	5b                   	pop    %ebx
80106d07:	5e                   	pop    %esi
80106d08:	5f                   	pop    %edi
80106d09:	5d                   	pop    %ebp
80106d0a:	c3                   	ret    
80106d0b:	90                   	nop
80106d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d10:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106d13:	31 c0                	xor    %eax,%eax
}
80106d15:	5b                   	pop    %ebx
80106d16:	5e                   	pop    %esi
80106d17:	5f                   	pop    %edi
80106d18:	5d                   	pop    %ebp
80106d19:	c3                   	ret    
