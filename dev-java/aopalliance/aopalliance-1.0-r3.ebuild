# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="aopalliance:aopalliance:1.0"

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

KEYWORDS="amd64 arm64 ppc64"

IUSE=""

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/main"

src_prepare() {
	default

	rm build.xml || die
}
