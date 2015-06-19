# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/codemodel/codemodel-2.1.ebuild,v 1.5 2008/03/28 17:56:01 nixnut Exp $

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java library for code generators"
HOMEPAGE="https://codemodel.dev.java.net/"
SRC_URI="https://jaxb.dev.java.net/${PV}/JAXB2_src_20061211.jar"

LICENSE="CDDL"
SLOT="2"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/jaxb-ri-20061211"

src_unpack() {
	echo "A" | java -jar "${DISTDIR}/${A}" -console > /dev/null || die "unpack failed"

	cd "${S}/lib" || die
	rm -v *.jar || die

	cp "${FILESDIR}/build.xml-${PV}" "${S}/build.xml" || die cp failed

	cd "${S}/src" || die
	rm -fr com/sun/tools com/sun/xml javax

}

src_install() {
	java-pkg_dojar codemodel.jar

	use source && java-pkg_dosrc src/*
}
