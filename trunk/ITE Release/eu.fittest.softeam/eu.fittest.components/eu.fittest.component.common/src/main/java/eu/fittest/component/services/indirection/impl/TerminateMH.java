package eu.fittest.component.services.indirection.impl;

import eu.fittest.common.core.exception.FITTESTException;
import eu.fittest.common.core.service.Connection;
import eu.fittest.common.core.xml.Terminate;
import eu.fittest.common.services.message.AbstractMessageHandler;

import eu.fittest.component.services.indirection.spec.IIndirectionService;

public class TerminateMH extends AbstractMessageHandler<IIndirectionService>{

	protected TerminateMH(IIndirectionService service) {
		super(service);
	}
	
	public synchronized void onReception(Connection connection, Terminate message)	throws FITTESTException {
		_service.terminate();
	}

}
