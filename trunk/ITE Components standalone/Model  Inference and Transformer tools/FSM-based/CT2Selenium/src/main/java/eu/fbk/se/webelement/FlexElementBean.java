/*

Copyright (c) 2013, FBK - Fondazione Bruno Kessler http://www.fbk.eu
All rights reserved. 

This program and the accompanying materials are made available under the terms of
the 3-Clause BSD License which accompanies this distribution, and is available at
http://www.opensource.org/licenses/BSD-3-Clause. The research leading to these
results has received funding from the European Community`s Seventh Framework
Programme (FP7/2007-2013) under the grant agreement FP7-257574 FITTEST.

*/
package eu.fbk.se.webelement;

public class FlexElementBean {
	public static final String IDENTIFIED_BY_NAME = "_name";
	public static final String IDENTIFIED_BY_ID = "_id";
	public static final String IDENTIFIED_BY_XPATH = "_xpath";
	
	String id;
	String event; // event to fire
	String params;


	public String getParams() {
		return params;
	}

	public void setParams(String params) {
		this.params = params;
	}

	public FlexElementBean(String id, String event, String params) {
		super();
		this.id = id;
		this.event = event;
		this.params = params;
	}

	public FlexElementBean() {
		
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getEvent() {
		return event;
	}

	public void setEvent(String event) {
		this.event = event;
	}

}
