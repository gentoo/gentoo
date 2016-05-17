# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

DESCRIPTION="Virtual for Java Development Kit (JDK)"
SLOT="1.7"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="|| (
		dev-java/icedtea-bin:7
		dev-java/icedtea:7
	)"
