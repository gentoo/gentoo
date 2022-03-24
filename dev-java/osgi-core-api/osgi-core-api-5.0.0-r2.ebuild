# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.osgi:org.osgi.core:5.0.0"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="OSGi Service Platform Core API (Companion Code)"
HOMEPAGE="http://www.osgi.org/Specifications/HomePage"
SRC_URI="http://www.osgi.org/download/r5/osgi.core-${PV}.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x64-macos"

RDEPEND=">=virtual/jre-1.8:*"

DEPEND=">=virtual/jdk-1.8:*
	app-arch/unzip"

JAVA_SRC_DIR="OSGI-OPT/src"

src_prepare() {
	default
	rm -r org || die
}
