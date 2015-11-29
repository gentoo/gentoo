# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2 versionator

MY_P="${PN}-$(replace_all_version_separators '-')"
DESCRIPTION="A Java data mining package"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"
HOMEPAGE="http://www.cs.waikato.ac.nz/ml/weka/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	>=dev-java/javacup-0.11a_beta20060608:0"
RDEPEND=">=virtual/jre-1.5
	>=dev-java/javacup-0.11a_beta20060608:0
	svm? ( sci-libs/libsvm:0[java] )"
IUSE="svm"

S="${WORKDIR}/${MY_P}"

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

java_prepare() {
	unzip -qq "${PN}-src.jar" -d . || die "Failed to unpack the source"
	rm -v *.jar lib/*.jar || die
	rm -rf doc || die
	java-pkg_jar-from --into lib javacup
	epatch "${FILESDIR}"/${P}-build.xml.patch
	sed -i -e "s/256m/$(weka_get_max_memory)/g" build.xml || die
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	java-pkg_dolauncher weka --main "${PN}.gui.GUIChooser"

	# Really need a virtual to list all available drivers and pull the ones
	# instaled
	java-pkg_register-optional-dependency hsqldb,jdbc-mysql,mckoi-1
	use svm && java-pkg_register-dependency libsvm

	use source && java-pkg_dosrc src/main/java/weka/

	dodoc README || die
	if use doc; then
		java-pkg_dojavadoc doc/
		insinto /usr/share/doc/${PF}
		doins WekaManual.pdf || die
	fi

	dodir /usr/share/${PN}/data/
	insinto /usr/share/${PN}/data/
	doins data/*

	newicon "${S}/weka.gif" "${PN}".png
	make_desktop_entry "${PN}" "Waikato Environment for Knowledge Analysis" "${PN}" "Education;Science;ArtificialIntelligence;" "Comment=Start Weka"
}
