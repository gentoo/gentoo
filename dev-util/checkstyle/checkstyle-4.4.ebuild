# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/checkstyle/checkstyle-4.4.ebuild,v 1.8 2014/08/10 21:26:19 slyfox Exp $

EAPI="2"
WANT_ANT_TASKS="ant-antlr ant-nodeps"
JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

MY_P="${PN}-src-${PV}"
DESCRIPTION="A development tool to help programmers write Java code that adheres to a coding standard"
HOMEPAGE="http://checkstyle.sourceforge.net"
SRC_URI="mirror://sourceforge/checkstyle/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

COMMON_DEP=">=dev-java/antlr-2.7.7:0[java]
	dev-java/commons-beanutils:1.7
	dev-java/commons-cli:1
	dev-java/commons-logging:0
	dev-java/commons-collections:0"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

DEPEND="!test? ( >=virtual/jdk-1.4 )
	test? ( >=virtual/jdk-1.5 )
	${COMMON_DEP}
	test? (
		dev-java/ant-junit
		dev-java/ant-trax
		dev-java/emma:0
	)"

S="${WORKDIR}/${MY_P}"

# So that we can generate 1.4 bytecode for dist
# and 1.5 for tests
JAVA_PKG_BSFIX="off"

java_prepare() {
	cd "${S}/lib"
	rm -v *.jar || die
	java-pkg_jar-from antlr
	java-pkg_jar-from commons-beanutils-1.7
	java-pkg_jar-from commons-cli-1
	java-pkg_jar-from commons-logging
	java-pkg_jar-from commons-collections
}

src_compile() {
	eant compile.checkstyle $(use_doc)
	jar cfm ${PN}.jar config/manifest.mf -C target/checkstyle . || die "jar failed"
}

src_test() {
	java-pkg_jar-from --build-only --into lib junit
	java-pkg_jar-from --build-only --into lib emma
	ANT_TASKS="emma ant-nodeps ant-junit ant-trax" eant run.tests
}

src_install() {
	java-pkg_dojar ${PN}.jar

	dodoc README RIGHTS.antlr || die
	use doc && java-pkg_dojavadoc target/docs/api
	use source && java-pkg_dosrc src/${PN}/com

	# Install check files
	insinto /usr/share/checkstyle/checks
	for file in *.xml; do
		[[ "${file}" != build.xml ]] && doins ${file}
	done

	# Install extra files
	insinto  /usr/share/checkstyle/contrib
	doins -r contrib/*

	java-pkg_dolauncher ${PN} \
		--main com.puppycrawl.tools.checkstyle.Main

	java-pkg_dolauncher ${PN}-gui \
		--main com.puppycrawl.tools.checkstyle.gui.Main

	# Make the ant tasks available to ant
	java-pkg_register-ant-task
}

pkg_postinst() {
	elog "Checkstyle is located at /usr/bin/checkstyle"
	elog "Check files are located in /usr/share/checkstyle/checks/"
}
