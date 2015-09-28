package eu.fittest.tloglib;

/**
 * Generates unique bits of a certain length.
 *
 */
public class BitGenerator {
	int length;
	int current = 0;
	
	/**
	 * Number of bits the combination contains
	 * @param length
	 */
	public BitGenerator(int length) {
		this.length = length;
	}
	
	/**
	 * Give me next unique combination
	 * @return
	 */
	public String next() {
		String val = Integer.toBinaryString(this.current);
		this.current++;
		
		// pad zeros to the left to get required size
		StringBuilder sb = new StringBuilder();
		for (int toprepend=this.length-val.length(); toprepend > 0; toprepend--)
		    sb.append('0');
		
		sb.append(val);
		val = sb.toString();
		
		return val;
	}
	
	/**
	 * Counts number of bits required for providing specified number of unique combinations
	 * @return Returns number of bits required
	 */
	public static int countBitsCombination(int uniqueCombinations) {
		//System.out.println(uniqueCombinations);
		int val = (int)Math.ceil((Math.log(uniqueCombinations) / Math.log(2)));
		//System.out.println(">>"+val);
		return val;
	}
	
	public static void main(String[] args) {
		BitGenerator bits = new BitGenerator(3) ;
		System.out.println(bits.next()) ;
		System.out.println(bits.next()) ;
		System.out.println(bits.next()) ;
		System.out.println(bits.next()) ;
		System.out.println(bits.next()) ;
	}
}









