##############################
#Test parameters

runsPerCase=3
#Threads
T=(32 64 128 256 512)
#Blocks
#B=(30 60 90 120 210)
Blow=30
Bhigh=1230
#ValuesPerThread
Xlow=4
Xhigh=64

OBJ=BW4
KernelFile=BM_kernel.cu
###############################
MAXTILE=4096

make clean > tmp.txt
make KernelGen > tmp.txt

head="VectorSize\\tx\\tB\\tT\\tGOPS\\tGByteS"
#echo $head

let m=0

for t in "${T[@]}"
do
   for (( b=Blow;b<=Bhigh;b+=120 )) 
   do
	for(( x=Xlow;x<=Xhigh;x+=4 ))
	do
	  (( m=x*t ))
	  if (( m<=MAXTILE ))
	  then
	  for(( i=0; i<runsPerCase; i++ ))
	  do
	     #Generate kernel code
	     KernelGen $x $b $t > $KernelFile
	     make > tmp.txt
	     $OBJ $x $b $t
	  done 
          fi	   
	done
   done
done
