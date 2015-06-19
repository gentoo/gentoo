# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/struts/struts-1.2.9-r3.ebuild,v 1.5 2011/12/19 11:01:26 sera Exp $

EAPI="2"
JAVA_PKG_IUSE="doc examples source"
WANT_ANT_TASKS="ant-trax"

inherit java-pkg-2 java-ant-2

MY_P="${P}-src"
DESCRIPTION="A powerful Model View Controller Framework for JSP/Servlets"
SRC_URI="mirror://apache/struts/source/${MY_P}.tar.gz"
HOMEPAGE="http://struts.apache.org/index.html"
LICENSE="Apache-2.0"
SLOT="1.2"
COMMON_DEPS="
	>=dev-java/antlr-2.7.7:0[java]
	dev-java/commons-beanutils:1.7
	>=dev-java/commons-collections-2.1:0
	>=dev-java/commons-digester-1.5:0
	>=dev-java/commons-fileupload-1.0:0
	>=dev-java/commons-logging-1.0.4:0
	>=dev-java/commons-validator-1.1.4:0
	dev-java/jakarta-oro:2.0
	java-virtuals/servlet-api:2.3"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPS}"
DEPEND=">=virtual/jdk-1.4
	${COMMON_DEPS}"
IUSE=""
KEYWORDS="amd64 ppc x86 ~x86-fbsd"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-CVE-2008-2025.patch"

	java_prepare
}

java_prepare() {
	# the build.xml expects this directory to exist
	mkdir "${S}/lib"
	cd "${S}/lib"

	# No property exists for this
	java-pkg_jar-from commons-collections
}

src_compile() {
	local antflags="compile.library"

	# In the order the build process asks for these
	# They are copied in the build.xml to ${S}/target/library/
	antflags="${antflags} -Dcommons-beanutils.jar=$(java-pkg_getjar commons-beanutils-1.7 commons-beanutils.jar)"
	antflags="${antflags} -Dcommons-digester.jar=$(java-pkg_getjars commons-digester)"
	antflags="${antflags} -Dcommons-fileupload.jar=$(java-pkg_getjars commons-fileupload)"
	antflags="${antflags} -Dcommons-logging.jar=$(java-pkg_getjar commons-logging commons-logging.jar)"
	antflags="${antflags} -Dcommons-validator.jar=$(java-pkg_getjars commons-validator)"
	antflags="${antflags} -Djakarta-oro.jar=$(java-pkg_getjars jakarta-oro-2.0)"

	# Needed to compile
	antflags="${antflags} -Dservlet.jar=$(java-pkg_getjars servlet-api-2.3)"
	antflags="${antflags} -Dantlr.jar=$(java-pkg_getjars antlr)"

	# only needed for contrib stuff which we don't currently build
#	antflags="${antflags} -Dstruts-legacy.jar=$(java-pkg_getjars struts-legacy)"

	eant ${antflags} $(use_doc compile.javadoc)
}

src_install() {
	java-pkg_dojar target/library/${PN}.jar

	#install the tld files
	insinto /usr/share/${PN}-${SLOT}/lib
	doins target/library/*.tld

	dodoc README STATUS.txt || die
	use doc && java-pkg_dohtml -r target/documentation/
	use examples && java-pkg_doexamples src/example*
	use source && java-pkg_dosrc src/share/*
}
