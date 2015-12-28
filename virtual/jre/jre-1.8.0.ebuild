# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Virtual for Java Runtime Environment (JRE)"
SLOT="1.8"
# TODO: Temporarily dropped ~sparc-solaris and ~x86-solaris as oracle-jre-bin
#       no longer provides them. Also temporarily dropped ~ia64.
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc64-solaris ~x64-solaris"

RDEPEND="|| (
		=virtual/jdk-1.8.0*
		=dev-java/oracle-jre-bin-1.8.0*
	)"
DEPEND=""
