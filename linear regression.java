import java.util.Scanner;
public class linear {
public static void main(String[] args) {
         Scanner sc=new Scanner(System.in);
System.out.println("enter no of points");
float n=sc.nextFloat();
float x[]=new float[20];
float y[]=new float[20];
System.out.println("enter x co-ordinates");
for(inti=0;i<n;i++)
     {
x[i]=sc.nextFloat();
     }
System.out.println("enter y co-ordinates");
for(inti=0;i<n;i++)
     {
y[i]=sc.nextFloat();
     }
floatsumx=0;
floatsumy=0;
floatsumxy=0;
floatsumxx=0;
for(int i=0;i<n;i++)
     {
sumx=sumx+x[i];
sumy=sumy+y[i];
sumxy=sumxy+(x[i]*y[i]);
sumxx=sumxx+(x[i]*x[i]);
     }
float t1,t0;
     t1=((n*sumxy)-(sumx*sumy))/((n*sumxx)-(sumx*sumx));
System.out.println("t1 is "+t1);
       t0=(sumy-(t1*sumx))/n;
System.out.println("t0 is "+t0);
System.out.println("y= "+t0+"+"+t1+"X");
}
}

/*
OUTPUT
enter no of points
6
enter x co-ordinates
34
108
64
88
99
51
enter y co-ordinates
5
17
11
8
14
5
t1 is 0.14621969
t0 is -0.82025653
y= -0.82025653+0.14621969X
*/