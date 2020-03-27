Observations:

  - was necessary to create a struct wrapping the peripheral (which is the deficiency in the SDK I was trying to work around in the first place) - would need to do this for each peripheral used
  - interrupt registers are in a different section of address space so I'd need a second pointer (unless the peripheral -> interrupt offsets are consistent, in which case I guess I could just stick in a boatload of padding)
  - function call is inlined
  - loads pointer and accesses registers indirectly
