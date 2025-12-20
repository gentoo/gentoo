# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="junit:junit:3.8.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Simple framework to write repeatable tests"
HOMEPAGE="https://junit.org/"
SRC_URI="https://downloads.sourceforge.net/project/junit/junit/${PV}/junit${PV}.zip"
S="${WORKDIR}/junit${PV}"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~x64-macos ~x64-solaris"

BDEPEND="app-arch/unzip"
DEPEND=">=virtual/jdk-1.8"
RDEPEND=">=virtual/jre-1.8"

HTML_DOCS=( README.html cpl-v10.html )

JAVA_SRC_DIR="${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	unzip src.jar || die
}

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean
}
