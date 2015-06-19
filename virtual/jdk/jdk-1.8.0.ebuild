# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/jdk/jdk-1.8.0.ebuild,v 1.2 2014/05/30 11:20:17 tomwij Exp $

EAPI="5"

DESCRIPTION="Virtual for Java Development Kit (JDK)"
SLOT="1.8"
# TODO: Temporarily dropped ~sparc-solaris and ~x86-solaris as oracle-jdk-bin
#       no longer provides them. Also temporarily dropped ~ia64.
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc64-solaris ~x64-solaris "

RDEPEND="=dev-java/oracle-jdk-bin-1.8.0*"
