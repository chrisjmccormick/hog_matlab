# hog_matlab
Matlab implementation of the HOG person detector. 

I originally created this project to experiment with different ways to modify the descriptor to reduce the dimensionality with minimal loss in accuracy.

Some things you should know going into this:

* The HOG detector is compute intense, and this is *not* a highly-optimized implementation.
* The primary value in this code, I think, is to use it to learn about the HOG detector. 
  * The code is well documented, and Matlab syntax makes the operations fairly plain.
  * It will be much easier to learn about the detector from this code, I think, than from the optimized OpenCV implementation, for example.

**HOG Tutorial**

For a tutorial on the HOG descriptor, check out my [HOG tutorial post](http://mccormickml.com/2013/05/09/hog-person-detector-tutorial/).

**Key Source Files**

`getHOGDescriptor.m` - Computes the HOG descriptor for a 66x130 pixel image / detection window. The detection window is actually 64x128 pixels, but an extra pixel is required on all sides for computing the gradients.

`train_detector.m` - Trains a linear SVM on the ~2.2k pre-cropped windows in the `/Images/Training/` folder.

**Differences with OpenCV Implementation**
	
* OpenCV uses L2 hysteresis for the block normalization.
* OpenCV weights each pixel in a block with a Gaussian distribution before normalizing the block.
* The sequence of values produced by OpenCV does not match the order of the values produced by this code.

**Order of Values**

You may not need to understand the order of bytes in the final vector in order to work with it, but if you're curious, here's a description.

The values in the final vector are grouped according to their block. A block consists of 36 values: 1 block  *  4 cells / block  * 1 histogram / cell * 9 values / histogram = 36 values / block.

The first 36 values in the vector come from the block in the top left corner of the detection window, and the last 36 values in the vector come from the block in the bottom right.

Before unwinding the values to a vector, each block is represented as a 3D dimensional matrix, 2x2x9, corresponding to the four cells in a block with their histogram values in the third dimension. To unwind this matrix into a vector, I use the colon operator ':', e.g., A(:).  You can reshape the values into a 3D matrix using the 'reshape' command. For example:

```matlab
% Get the top left block from the descriptor.
block1 = H(1:36);

% Reshape the values into a 2x2x9 matrix B1.
B1 = reshape(block1, 2, 2, 9);
```

**Send your feedback**

Please let me know if you find any bugs, opportunities for optimization, or any other discrepancies from the original descriptor.

