# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/aopalliance/aopalliance-1.0-r2.ebuild,v 1.6 2015/05/17 20:19:15 pacho Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Aspect-Oriented Programming (AOP) Alliance classes"
SRC_URI="mirror://gentoo/${P}-gentoo.tar.bz2"
#SRC_URI="mirror://gentoo/${P}.tar.bz2"
# Tarball creation:
# cvs -d:pserver:anonymous@aopalliance.cvs.sourceforge.net:/cvsroot/aopalliance login
# cvs -z3 -d:pserver:anonymous@aopalliance.cvs.sourceforge.net:/cvsroot/aopalliance export -r interception_1_0 aopalliance
# tar cjvf aopalliance-1.0-gentoo.tar.bz2 aopalliance
HOMEPAGE="http://aopalliance.sourceforge.net/"
LICENSE="public-domain"
SLOT="1"

KEYWORDS="amd64 ppc ppc64 x86"

IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main"

java_prepare() {
	rm build.xml || die
}
