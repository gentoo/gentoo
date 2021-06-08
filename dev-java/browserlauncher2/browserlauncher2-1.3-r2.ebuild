# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_PV="$(ver_rs 1- _)"

DESCRIPTION="A library that facilitates opening a browser from a Java application"
HOMEPAGE="http://browserlaunch2.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/browserlaunch2/browserlauncher2/${PV}/BrowserLauncher2-all-${MY_PV}.jar"

LICENSE="LGPL-2.1"
SLOT="1.0"
KEYWORDS="amd64 ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"

S="${WORKDIR}"

src_prepare() {
	default
	unpack ${A}
	find . -name "*.class" -exec rm -v {} \; || die
	# fixing build.xml
	sed -i -e "s: includes=\"\*\*/\*\.class\"::g" "${S}/build.xml" || die

	iconv -f ISO-8859-1 -t UTF8 -o "${S}/source/at/jta/Regor.java~" \
		"${S}/source/at/jta/Regor.java" || die "recoding failed"
	mv -f "${S}"/source/at/jta/Regor.java{~,} || die "cannot rename"
}

EANT_BUILD_TARGET="build"
EANT_DOC_TARGET="api"

src_install() {
	java-pkg_newjar deployment/*.jar
	java-pkg_dolauncher BrowserLauncherTestApp-${SLOT} \
		--main "edu.stanford.ejalbert.testing.BrowserLauncherTestApp"

	dodoc README*
	use doc && java-pkg_dojavadoc api
	use source && java-pkg_dosrc source
}
