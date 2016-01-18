# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-virtuals-2

DESCRIPTION="Virtual for Java API for XML Processing (JAXP)"
HOMEPAGE="https://www.gentoo.org"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND="|| (
			>=virtual/jre-1.6
			>=dev-java/jaxp-1.4-r1:0
		)
		>=dev-java/java-config-2.1.8"

JAVA_VIRTUAL_PROVIDES="jaxp"
JAVA_VIRTUAL_VM=">=virtual/jre-1.6"
