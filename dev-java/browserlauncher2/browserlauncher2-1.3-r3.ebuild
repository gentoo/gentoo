# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A library that facilitates opening a browser from a Java application"
HOMEPAGE="http://browserlaunch2.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/browserlaunch2/browserlauncher2/${PV}/BrowserLauncher2-all-${PV//./_}.jar"

LICENSE="LGPL-2.1"
SLOT="1.0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"

JAVA_SRC_DIR="source"
JAVA_RESOURCE_DIRS="resources"
JAVA_MAIN_CLASS="edu.stanford.ejalbert.testing.BrowserLauncherTestApp"
JAVA_ENCODING="ISO-8859-1"

src_prepare() {
	default
	java-pkg_clean

	cp -r source resources || die "Cannot create resources dir"
	find resources -type f ! -name '*.properties' -exec rm -rf {} + || die
}
