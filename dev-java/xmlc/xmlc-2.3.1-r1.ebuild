# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/xmlc/xmlc-2.3.1-r1.ebuild,v 1.4 2012/09/02 00:53:04 xmw Exp $

EAPI="4"

JAVA_PKG_IUSE="doc"

inherit java-pkg-2 java-ant-2

MY_P="${PN}-src-${PV}"
DESCRIPTION="Open Source Java/XML Presentation Compiler"
HOMEPAGE="http://xmlc.objectweb.org/"
SRC_URI="http://download.forge.objectweb.org/${PN}/${MY_P}.zip
	http://download.us.forge.objectweb.org/${PN}/${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

COMMON_DEP="
	dev-java/ant-core:0
	dev-java/asm:3
	dev-java/gnu-regexp:1
	dev-java/log4j:0
	dev-java/nekohtml:0
	dev-java/xerces:2
	dev-java/xml-commons-external:1.4
	dev-java/xml-commons-resolver:0
	java-virtuals/servlet-api:2.5"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"

S="${WORKDIR}/${MY_P}/"

java_prepare() {
	find -name '*.jar' -exec rm -v {} + || die

	# get rid of jarjar, and add ant.jar to the taskdef module's classpath
	epatch "${FILESDIR}/${P}-build.xml.patch"
}

JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_BUILD_TARGET="all-libs"
EANT_GENTOO_CLASSPATH="xerces-2,gnu-regexp-1,log4j,nekohtml,asm-3,xml-commons-external-1.4,xml-commons-resolver,servlet-api-2.5,ant-core"

src_install() {
	# the rest of jars are included in all-runtime
	java-pkg_dojar release/lib/{xmlc-all-runtime,xmlc-taskdef}.jar
	java-pkg_register-ant-task

	newdoc xmlc/modules/xmlc/README.XMLC README || die
	dodoc xmlc/modules/xmlc/ChangeLog || die
	dohtml release/release-notes/xmlc-${PV//./-}-release-note.html \
		xmlc/bugs/bugs.html || die

	# move the generated documentation around
	if use doc; then
		mv ${PN}/modules/taskdef/doc ${PN}/modules/${PN}/doc/taskdef || die
		mv ${PN}/modules/wireless/doc ${PN}/modules/${PN}/doc/wireless || die
		mv ${PN}/modules/xhtml/doc ${PN}/modules/${PN}/doc/xhtml || die
		java-pkg_dohtml -r ${PN}/modules/xmlc/doc/* || die "Failed to install documentation"
	fi
}
