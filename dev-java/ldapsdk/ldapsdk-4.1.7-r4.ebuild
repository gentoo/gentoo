# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ldapsdk/ldapsdk-4.1.7-r4.ebuild,v 1.3 2014/11/25 08:40:58 ago Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Netscape Directory SDK for Java"
HOMEPAGE="http://www.mozilla.org/directory/javasdk.html"
SRC_URI="http://www.mozilla.org/directory/${PN}_java_20020819.tar.gz"

LICENSE="MPL-1.1"
SLOT="4.1"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND=">=virtual/jre-1.4
	dev-java/jss:3.4
	dev-java/jakarta-oro:2.0"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}"

S=${WORKDIR}/mozilla/directory/java-sdk

java_prepare() {
	cd "${WORKDIR}"/mozilla || die
	epatch "${FILESDIR}"/ldapsdk-gentoo.patch
	epatch "${FILESDIR}"/${PV}-*.patch

	echo "ororegexp.jar=$(java-pkg_getjars jakarta-oro-2.0)" > "${S}"/build.properties || die
	echo "jss.jar=$(java-pkg_getjars jss-3.4)" >> "${S}"/build.properties || die

	cd "${S}"/ldapjdk/lib || die
	rm -f *.jar || die
	java-pkg_jar-from jss-3.4

	cd "${S}"/ldapsp/lib || die
	rm *.jar || die

	java-pkg_filter-compiler jikes
}

src_compile() {
	eant dist-jdk dist-filter dist-beans dist-jndi $(use_doc build-docs)
}

src_install() {
	java-pkg_dojar dist/packages/*.jar

	use doc && java-pkg_dojavadoc dist/doc/ldapsp
	use source && \
		java-pkg_dosrc {ldapsp,ldapjdk}/com	{ldapjdk,ldapbeans,ldapfilter}/netscape
}
