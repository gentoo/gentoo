# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
JAVA_PKG_IUSE="doc source test"
inherit java-pkg-2 java-ant-2

DESCRIPTION="A Java source code analyzer"
HOMEPAGE="http://pmd.sourceforge.net"
SRC_URI="mirror://sourceforge/pmd/${PN}-src-${PV}.zip"

LICENSE="pmd"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

COMMON_DEPEND="
	dev-java/ant-core
	dev-java/asm:3
	dev-java/jaxen:1.1
	>=dev-java/junit-4.4:4"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	test? (
		dev-java/ant-junit4
		dev-java/ant-trax
	)
	${COMMON_DEPEND}"

# tests fail
RESTRICT="test"

java_prepare() {
	epatch "${FILESDIR}/${P}-build.xml.patch"
	find -name "*.jar" | xargs rm -v

	cd "${S}/lib"
	java-pkg_jar-from ant-core
	java-pkg_jar-from asm-3 asm.jar
	java-pkg_jar-from jaxen-1.1 jaxen.jar
	java-pkg_jar-from junit-4
}

EANT_BUILD_XML="bin/build.xml"

src_test() {
	# junit does not like collisions
	rm lib/ant.jar
	ANT_TASKS="ant-junit4 ant-trax" eant -f bin/build.xml test -DoutputTestResultsToFile=true
}

src_install() {
	java-pkg_newjar lib/${P}.jar
	java-pkg_register-ant-task

	# Create launchers and copy rulesets
	java-pkg_dolauncher ${PN} --main net.sourceforge.pmd.PMD --java_args "-Xmx512m" \
		-pre "${FILESDIR}"/${P}-launcher-pre-commands
	java-pkg_dolauncher ${PN}-designer --main net.sourceforge.pmd.util.designer.Designer
	cp -r rulesets "${D}"/usr/share/${PN}
	mkdir "${D}"/usr/share/${PN}/etc
	cp -r etc/xslt "${D}"/usr/share/${PN}/etc/

	use doc && java-pkg_dojavadoc docs/api
	use source && java-pkg_dosrc src/net
}

pkg_postinst() {
	elog "Example rulesets can be found under"
	elog "/usr/share/pmd/rulesets/"
}
