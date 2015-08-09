# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit versionator eutils java-pkg-2 java-ant-2

MY_PV="$(replace_all_version_separators _)"
MY_PN="BrowserLauncher2"

DESCRIPTION="BrowserLauncher2 is a library that facilitates opening a browser from a Java application"
HOMEPAGE="http://browserlaunch2.sourceforge.net/"
SRC_URI="mirror://sourceforge/browserlaunch2/${MY_PN}-all-${MY_PV}.jar"

LICENSE="LGPL-2.1"
SLOT="1.0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"

S="${WORKDIR}"

java_prepare() {
	unpack ${A}
	find . -name "*.class" -exec rm -v {} \; || die
	# fixing build.xml
	sed -i -e "s: includes=\"\*\*/\*\.class\"::g" "${S}/build.xml" || die
}

EANT_BUILD_TARGET="build"
EANT_DOC_TARGET="api"

src_install() {
	java-pkg_newjar deployment/*.jar
	java-pkg_dolauncher BrowserLauncherTestApp-${SLOT} \
		--main "edu.stanford.ejalbert.testing.BrowserLauncherTestApp"

	dodoc README* || die
	use doc && java-pkg_dojavadoc api
	use source && java-pkg_dosrc source
}
