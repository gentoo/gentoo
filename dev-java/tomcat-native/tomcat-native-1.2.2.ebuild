# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Native APR library for Tomcat"

SLOT="0"
SRC_URI="mirror://apache/tomcat/tomcat-connectors/native/${PV}/source/${P}-src.tar.gz"
HOMEPAGE="http://tomcat.apache.org/"
KEYWORDS="~amd64 ~x86"
LICENSE="Apache-2.0"
IUSE="test"

RDEPEND="dev-libs/apr:1
	dev-libs/openssl:=
	>=virtual/jre-1.7"

DEPEND=">=virtual/jdk-1.7
	test? ( dev-java/ant-junit:0 )"

S=${WORKDIR}/${P}-src

src_configure(){
	cd native || die
	econf --with-apr=/usr/bin/apr-1-config  \
		--with-ssl=/usr || die "Could not configure native sources"
}

src_compile() {
	eant jar -f build.xml

	cd native || die
	default
}

src_install() {
	java-pkg_newjar "dist/${P}.jar" "${PN}.jar"

	cd native
	emake DESTDIR="${D}" install || die "Could not install libtcnative-1.so"
}

src_test() {
	java-pkg-2_src_test
}

pkg_postinst() {
	elog
	elog " APR should be available with Tomcat, for more information"
	elog " please see http://tomcat.apache.org/tomcat-6.0-doc/apr.html"
	elog
	elog " Please report any bugs to https://bugs.gentoo.org/"
	elog
}
