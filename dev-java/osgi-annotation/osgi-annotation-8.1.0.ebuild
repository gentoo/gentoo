# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.osgi:osgi.annotation:8.1.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="OSGi Annotation Release 8, Annotations for use in compiling bundles"
HOMEPAGE="https://www.osgi.org"
SRC_URI="https://docs.osgi.org/download/r$(ver_cut 1)/${PN/-/.}-${PV}.jar -> ${P}.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"
BDEPEND="app-arch/unzip"

JAVA_SRC_DIR="OSGI-OPT/src"

src_prepare() {
	default
	java-pkg_clean org
}
