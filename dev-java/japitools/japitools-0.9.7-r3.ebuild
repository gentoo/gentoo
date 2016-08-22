# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java API compatibility testing tools"
HOMEPAGE="http://sab39.netreach.com/japi/"
SRC_URI="http://www.kaffe.org/~stuart/japi/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RESTRICT="test"

CDEPEND="dev-java/ant-core:0"

RDEPEND="
	dev-lang/perl
	${CDEPEND}
	>=virtual/jre-1.7"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.7"

S="${WORKDIR}/${P}"

JAVA_GENTOO_CLASSPATH="ant-core"

JAVA_SRC_DIR="src"

java_prepare() {
	eapply_user
	cd "${S}"/bin || die
	rm *.bat || die
	sed -e "s:../share/java:../share/${PN}/lib:" -i * \
		|| die "Failed to correct the location of the jar file in perl scripts."
}

src_install() {
	dobin bin/*

	java-pkg-simple_src_install
	java-pkg_register-ant-task
}
