# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="junit:junit:3.8.2"

inherit java-pkg-2 java-pkg-simple

MY_P=${P/-/}

DESCRIPTION="Simple framework to write repeatable tests"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.zip"
HOMEPAGE="http://www.junit.org/"
LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

DEPEND=">=virtual/jdk-1.8"
RDEPEND=">=virtual/jre-1.8"

DOCS=( README.html cpl-v10.html )

JAVA_SRC_DIR="${PN}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	unzip src.jar || die
}

src_prepare() {
	default
	java-pkg_clean
}

src_install() {
	java-pkg-simple_src_install
	einstalldocs
}
