# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/absolutelayout/absolutelayout-6.7_beta-r1.ebuild,v 1.1 2014/07/14 07:47:49 ercpe Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="AbsoluteLayout files extracted from Netbeans"
HOMEPAGE="http://www.netbeans.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="|| ( GPL-2 CDDL )"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4"

S="${WORKDIR}"
