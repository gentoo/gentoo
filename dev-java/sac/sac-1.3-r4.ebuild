# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.w3c.css:sac:1.3"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="SAC is a standard interface for CSS parser"
HOMEPAGE="https://www.w3.org/Style/CSS/SAC/"
SRC_URI="https://www.w3.org/2002/06/sacjava-${PV}.zip -> ${P}.zip"

LICENSE="W3C"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND="
	app-arch/zip
	>=virtual/jdk-1.8:*"

RDEPEND="
	>=virtual/jre-1.8:*"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="org"

src_prepare() {
	default
	java-pkg_clean
}
