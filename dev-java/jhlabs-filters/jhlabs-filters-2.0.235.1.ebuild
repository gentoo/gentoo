# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MY_PV="$(ver_rs 3 -)"
MAVEN_ID="com.jhlabs:filters:${MY_PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java Image Filters"
HOMEPAGE="http://jhlabs.com/ip/filters/"
SRC_URI="https://repo1.maven.org/maven2/com/jhlabs/filters/${MY_PV}/filters-${MY_PV}-sources.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="app-arch/unzip"
DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_RESOURCE_DIRS="res"

src_prepare() {
	java-pkg-2_src_prepare
	mkdir res || die
	cp --parent -t res com/jhlabs/image/SkyColors.png || die
}
