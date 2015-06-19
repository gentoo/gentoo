# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jgoodies-common/jgoodies-common-1.2.1.ebuild,v 1.1 2012/02/08 22:05:28 serkan Exp $

EAPI=2
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 eutils

MY_PN="common"
MY_PV=${PV//./_}
MY_P="${PN}-${MY_PV}"
DESCRIPTION="JGoodies Common Library"
HOMEPAGE="http://www.jgoodies.com/"
SRC_URI="http://www.jgoodies.com/download/libraries/${MY_PN}/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.5"

java_prepare() {
	# Remove the packaged jars
	find . -name "*.jar" -delete || die "rm failed"
}

src_compile() {
	# it does not like unset ${build.compiler.executable}
	# feel free to fix if you want jikes back
	java-pkg_filter-compiler jikes
	# not setting the bootcp breaks ecj, javac apparently ignores nonsense
	eant -Dbuild.boot.classpath="$(java-config -g BOOTCLASSPATH)" jar
}

src_install() {
	java-pkg_dojar build/${PN}.jar

	dodoc RELEASE-NOTES.txt README.html || die

	use doc && java-pkg_dohtml -r docs/*
	use source && java-pkg_dosrc src/core/com
}
