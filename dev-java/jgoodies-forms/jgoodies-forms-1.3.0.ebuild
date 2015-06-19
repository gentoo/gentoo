# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jgoodies-forms/jgoodies-forms-1.3.0.ebuild,v 1.6 2012/09/29 17:43:42 grobian Exp $

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2 eutils

MY_PN="forms"
MY_PV=${PV//./_}
MY_P="${MY_PN}-${MY_PV}"
DESCRIPTION="JGoodies Forms Library"
HOMEPAGE="http://www.jgoodies.com/"
SRC_URI="http://www.jgoodies.com/download/libraries/${MY_PN}/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x64-macos"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/${MY_PN}-${PV}"

src_unpack() {
	unpack ${A} || die "Unpack failed"
	cd "${S}"

	# Remove the packaged jars
	rm -v *.jar || die "rm failed"
}

src_compile() {
	# it does not like unset ${build.compiler.executable}
	# feel free to fix if you want jikes back
	java-pkg_filter-compiler jikes
	# not setting the bootcp breaks ecj, javac apparently ignores nonsense
	eant -Dbuild.boot.classpath="$(java-config -g BOOTCLASSPATH)" jar
}

#Needs X
#src_test() {
#	ANT_TASKS="ant-junit" eant test \
#		-Djunit.jar="$(java-pkg_getjars junit)"
#}

src_install() {
	java-pkg_dojar build/${MY_PN}.jar

	dodoc RELEASE-NOTES.txt README.html || die

	use doc && java-pkg_dohtml -r docs/*
	use source && java-pkg_dosrc src/{core,extras}/com
	use examples && java-pkg_doexamples src/tutorial
}
