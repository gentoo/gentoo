package org.objectweb.util.ant;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.taskdefs.Copy;

public class MultipleCopy extends Copy {

	public void execute() throws BuildException {
		throw new BuildException("MultipleCopy is not compatible with ant >=1.7.0");
	}

}
