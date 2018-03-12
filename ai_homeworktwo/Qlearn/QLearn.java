import java.util.Scanner;
import java.util.HashMap;
import java.util.Map;
public class QLearn {
    //the two matrices for our q learning algorithm
    public static double[][] exercise={{.99,8},{0.01,8},{0.2,0},{.8,0}};
    public static double[][] relax={{.7,10},{0.3,10},{0,5},{1,5}};
    //compute q value untill
    public static int N;
    //the value of the discounted value
    public static double Delta;
    public static HashMap<String,Double> qCache=new HashMap <String,Double>();
    public static void main(String [] args){

        Scanner input= new Scanner(System.in);
        System.out.println("Enter a value for delta where 0<γ<1");

        Delta=input.nextDouble();
        if(Delta<0||Delta>1){
            System.out.println("Delta is not 0<γ<1");
            System.exit(0);
        }
        System.out.println("Enter a value for N where N>=0");
        N=input.nextInt();
        if(N<0){
            System.out.println("N where N<0");
            System.exit(0);
        }

        double exerciseValFit =q("fit", "exercise",N);
        double exerciseValUnFit = q("unfit", "exercise",N);
        double relaxValFit = q("fit", "relax",N);
        double relaxValUnFit = q("unfit", "relax",N);
            System.out.println("\n\nfit: Exercise: " + exerciseValFit + " Relax: " + relaxValFit + "\nπ: " + (exerciseValFit >= relaxValFit ? "Exercise" : "Relax") +
                    "\n\nunfit: Exercise: " + exerciseValUnFit + " Relax: " + relaxValUnFit + "\nπ: " + (exerciseValUnFit >= relaxValUnFit ? "Exercise" : "Relax"));
    }

    //returns the value for q(0)
    static double qstart(String state,String matrix){
        int currentState=state=="fit"?0:2;
        if (matrix == "exercise") {
            return exercise[currentState][0]*exercise[currentState][1]+exercise[currentState+1][0]*exercise[currentState+1][1];
        }
        else{
            return relax[currentState][0]*relax[currentState][1]+relax[currentState+1][0]*relax[currentState+1][1];
        }
    }

    //computes the q value for N
    static double q(String state,String matrix,int index){
        String args=state+","+matrix+","+index;
        Double result=qCache.get(args);
        if(result!=null)
            return result;
        if(index==0){
            result=qstart(state,matrix);
        }
        else{
        result=qstart(state,matrix)+((Delta)*(getProb(state,matrix,"fit")*V("fit",index-1)+getProb(state, matrix,"unfit")*V("unfit",index-1)));
        }
        qCache.put(args,result);
        return result;
    }

    //returns the probabilty given the state of the matrix and it's action
    static double getProb(String state,String matrix,String action){
        int currentState=state=="fit"?0:2;
        int act=action=="fit"?currentState:currentState+1;
        if (matrix == "exercise") {
            return exercise[act][0];
        }
        else{
            return relax[act][0];
        }
    }

    //computes the q value for each of the matrices given N and returns the max value
    static double V(String action,int n){
        double ex=q(action,"exercise",n);
        double re=q(action,"relax",n);
        return ex>=re?ex:re;
    }
}
