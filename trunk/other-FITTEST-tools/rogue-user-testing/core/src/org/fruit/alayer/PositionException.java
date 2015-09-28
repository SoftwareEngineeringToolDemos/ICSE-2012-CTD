/**************************************************************************************
*  Copyright (c) 2013, Universitat Politecnica de Valencia. All rights reserved.      *
*  This program and the accompanying materials are made available under the terms     *
*  of the 3-Clause BSD License which accompanies this distribution, and is available  *
*  at http://www.opensource.org/licenses/BSD-3-Clause. The research leading to these  *
*  results has received funding from the European Community`s Seventh Framework       *
*  Programme (FP7/2007-2013) under the grant agreement  FP7-257574 FITTEST.           *
**************************************************************************************/

/**
 *  @author Sebastian Bauersfeld
 */
package org.fruit.alayer;

import org.fruit.FruitException;

public class PositionException extends FruitException {
	private static final long serialVersionUID = -1132646035499653943L;
	public PositionException(String message){ this(message, null); }
	public PositionException(String message, Throwable cause){ super(message, cause); }
	public PositionException(Throwable cause){ super(cause); }
}
