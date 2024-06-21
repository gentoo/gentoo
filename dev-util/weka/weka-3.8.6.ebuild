# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Java data mining package"
HOMEPAGE="https://ml.cms.waikato.ac.nz/weka"
SRC_URI="https://downloads.sourceforge.net/project/weka/weka-3-8/${PV}/weka-${PV//./-}.zip"
S="${WORKDIR}/${P//./-}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"
CP_DEPEND="dev-java/javacup:0"
DEPEND="${CP_DEPEND}
	virtual/jdk:1.8"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

JAVA_GENTOO_CLASSPATH_EXTRA="lib/bounce.jar:lib/mtj.jar:lib/jfilechooser-bookmarks-0.1.6.jar"
JAVA_MAIN_CLASS="weka.gui.GUIChooser"
JAVA_RESOURCE_DIRS="src/main/res"
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	java-pkg-2_src_prepare
	unzip -qq "${PN}-src.jar" -d . || die "Failed to unpack the source"
	java-pkg_clean \
		! -path ./lib/bounce.jar \
		! -path ./lib/core.jar \
		! -path ./lib/jfilechooser-bookmarks-0.1.6.jar \
		! -path ./lib/mtj.jar

	# java-pkg-simple wants resources in JAVA_RESOURCE_DIRS.
	mkdir -p src/main/res || die
	pushd src/main/java > /dev/null || die
		find -type f \
			! -name '*.java' \
			| xargs cp --parent -t ../res || die
	popd > /dev/null || die
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dojar lib/{bounce,core,mtj}.jar
	java-pkg_dojar lib/jfilechooser-bookmarks-0.1.6.jar

	# Really need a virtual to list all available drivers and pull the ones
	# instaled
	java-pkg_register-optional-dependency hsqldb,jdbc-mysql,mckoi-1

	insinto /usr/share/weka/data/
	doins data/*
}
