<center><h2>Actor</h2></center>

一个Actor指的是一个最基本的计算单元。它能接收一个消息并且基于其执行计算。Actors一大重要特征在于actors之间相互隔离，它们并不互相共享
内存。这点区别于上述的对象。也就是说，一个actor能维持一个私有的状态，并且这个状态不可能被另一个actor所改变。

值得指明的一点是，尽管许多actors同时运行，但是一个actor只能顺序地处理消息。也就是说其它actors发送了三条消息给一个actor，这个actor只能一次处理一条。所以如果你要并行处理3条消息，你需要把这条消息发给3个actors。
当一个actor接收到消息后，它能做如下三件事中的一件：

> Create more actors; 创建其他actors
> 
> Send messages to other actors; 向其他actors发送消息
> 
> Designates what to do with the next message. 指定下一条消息到来的行为


