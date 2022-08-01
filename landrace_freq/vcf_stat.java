import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class vcf_stat {

	public static void main(String[] args) throws IOException {
		// TODO Auto-generated method stub
		System.out.println(System.getProperty("user.dir")); 
		String userdir=System.getProperty("user.dir"); 
		String in=args[0];
		if(!args[0].substring(0,1).equals("/")) {
			in=userdir+"/"+args[0];
		}
		BufferedReader reader1 = new BufferedReader(new FileReader(in));
		BufferedWriter writeStream = new BufferedWriter(new FileWriter(in+".hstat"));
		String line=reader1.readLine();
		//line=reader1.readLine();
		while(line.substring(0,2).equals("##")) {
			line=reader1.readLine();
		}
		int n=9;
		System.out.println(line);
		String[] zo=line.split("	");
		
		
		String[] sample=new String[zo.length-n];
		int z=0;
		while(z+n<zo.length) {
			sample[z]=zo[n+z];
			z++;
		}
		int[] t01=new int[zo.length-n]; //0/1
		int[] t00=new int[zo.length-n]; //0/0
		int[] too=new int[zo.length-n]; //./.
		int[] t11=new int[zo.length-n]; //1/1
		int[] to=new int[zo.length-n];  //other
		int[] dp=new int[zo.length-n];  //other
		
		List<String> out=new ArrayList<String>();
	


		writeStream.write("Chr	Pos	Ref	Alt	AC	DPsum	DPavg	0/1	0/0	./.	1/1	other");
		writeStream.newLine();
		line=reader1.readLine();
		int l=0;
		while(line!=null) {
			String[] z1=line.split("	");
		//	int pos1=Integer.parseInt(z1[1]);
			String[] z2=z1[7].split(";");
			int b1=0;
			double b2=0;
			int b3=0; //0/1
			int b4=0; //0/0
			int b5=0; //./.
			int b6=0; //1/1
			int b7=0; //other
			int t=0;
			int ac=0;
			z=0;
			while(z<z2.length) {
				String[] z3=z2[z].split("=");
				if(z3[0].equals("DP")) {
					b1=Integer.parseInt(z3[1]);
				}
				if(z3[0].equals("AC")) {
					ac=Integer.parseInt(z3[1].split(",")[0]);
				}
				z++;
			}
			z=0;
			while(z+n<z1.length) {
				String[] z4=z1[z+n].split("\\:");
				String gt=z4[0].replace("|", "/");
				if(gt.equals("0/1")) {
					t++;
					t01[z]++;
					b3++;
				}
				else if(gt.equals("0/0")) {
					t++;
					b4++;
					t00[z]++;
				}
				else if(gt.equals("./.")) {
					b5++;
					t++;
					too[z]++;
				}
				else if(gt.equals("1/1")) {
					b6++;
					t++;
					t11[z]++;
				}

				else {
					b7++;
					t++;
					to[z]++;
				}
				//System.out.println(z1[z+n]);
				if(!z4[2].equals(".")) {
				dp[z]=dp[z]+Integer.parseInt(z4[2]);
				}
				z++;
			}
			b2=(double)b1/t;
			
			out.add(z1[0]+"	"+z1[1]+"	"+z1[3]+"	"+z1[4]+"	"+ac+"	"+b1+"	"+b2+"	"+b3+"	"+b4+"	"+b5+"	"+b6+"	"+b7);
			l++;
			line=reader1.readLine();
		}
		reader1.close();
		int i=0;
		while(i<out.size()) {
			writeStream.write(out.get(i));
			writeStream.newLine();
			i++;
		}
		writeStream.close();
		BufferedWriter writeStream1 = new BufferedWriter(new FileWriter(in+".vstat"));
		writeStream1.write("Sample	DPavg	0/1num	0/0num	./.num 1/1num	Othernum");
		writeStream1.newLine();
		z=0;
		while(z<sample.length) {
			writeStream1.write(sample[z]+"	"+dp[z]/l+"	"+t01[z]+"	"+t00[z]+"	"+too[z]+"	"+t11[z]+"	"+to[z]);
			writeStream1.newLine();
			z++;
		}
		writeStream1.close();

	}

}
