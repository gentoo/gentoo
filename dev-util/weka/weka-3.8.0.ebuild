# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2 versionator

MY_P="${PN}-$(replace_all_version_separators '-')"
DESCRIPTION="A Java data mining package"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"
HOMEPAGE="http://www.cs.waikato.ac.nz/ml/weka/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
DEPEND=">=virtual/jdk-1.7
	app-arch/unzip
	>=dev-java/javacup-0.11a_beta20060608:0"
RDEPEND=">=virtual/jre-1.7
	>=dev-java/javacup-0.11a_beta20060608:0"
IUSE=""

S="${WORKDIR}/${MY_P}"

PATCHES=("${FILESDIR}"/${P}-build.xml.patch)

EANT_BUILD_TARGET="exejar"
EANT_DOC_TARGET="docs"
JAVA_ANT_IGNORE_SYSTEM_CLASSES="true"

weka_get_max_memory() {
	if use amd64; then
		echo 512m
	else
		echo 256m
	fi
}

src_prepare() {
	unzip -qq "${PN}-src.jar" -d . || die "Failed to unpack the source"
	rm -v weka.jar || die
	rm -rf doc || die
	java-pkg_jar-from --into lib javacup

	sed -i -e "s/256m/$(weka_get_max_memory)/g" build.xml || die
	default
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	java-pkg_dolauncher weka --main "${PN}.gui.GUIChooser"

	# Really need a virtual to list all available drivers and pull the ones
	# instaled
	java-pkg_register-optional-dependency hsqldb,jdbc-mysql,mckoi-1

	use source && java-pkg_dosrc src/main/java/weka/

	dodoc README

	dodir /usr/share/${PN}/data/
	insinto /usr/share/${PN}/data/
	doins data/*
}

pkg_postinst() {
	elog "If you are upgrading from weka 3.7 to later"
	elog "and your package manager does not start please delete"
	elog "file installedPackageCache.ser from packages folder"
	elog "in wekafiles located in your user home."
	elog
	elog "rm \${HOME}/wekafiles/packages/installedPackageCache.ser"
}
