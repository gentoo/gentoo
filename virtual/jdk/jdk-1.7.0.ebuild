# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/jdk/jdk-1.7.0.ebuild,v 1.15 2015/04/17 08:35:44 ago Exp $

EAPI="5"

DESCRIPTION="Virtual for Java Development Kit (JDK)"
SLOT="1.7"
KEYWORDS="amd64 ~arm ~ia64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="|| (
		=dev-java/icedtea-bin-7*
		=dev-java/icedtea-7*
		=dev-java/oracle-jdk-bin-1.7.0*
		=dev-java/soylatte-jdk-bin-7*
	)"
