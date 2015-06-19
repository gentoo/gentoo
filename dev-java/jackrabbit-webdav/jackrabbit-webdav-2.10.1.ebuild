# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jackrabbit-webdav/jackrabbit-webdav-2.10.1.ebuild,v 1.1 2015/05/22 16:02:50 monsieurp Exp $

EAPI="5"

JAVA_PKG_IUSE="doc test"

inherit java-pkg-2 java-ant-2

MY_PN="${PN/-*/}"

DESCRIPTION="Fully conforming implementation of the JRC API (specified in JSR 170 and 283)"
HOMEPAGE="http://jackrabbit.apache.org/"
SRC_URI="mirror://apache/${MY_PN}/${PV}/${MY_PN}-${PV}-src.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${MY_PN}-${PV}/${PN}"

CDEPEND="dev-java/bndlib:0
	dev-java/commons-httpclient:3
	dev-java/slf4j-api:0
	java-virtuals/servlet-api:2.3"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}
	test? ( dev-java/ant-junit:0 )"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="bndlib,commons-httpclient-3,servlet-api-2.3,slf4j-api"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${P}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
}
