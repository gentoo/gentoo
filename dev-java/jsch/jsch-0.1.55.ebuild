# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom jsch-0.1.55.pom --download-uri https://repo1.maven.org/maven2/com/jcraft/jsch/0.1.55/jsch-0.1.55-sources.jar --slot 55 --keywords "~amd64 ~arm ~arm64 ~ppc64 ~x86" --ebuild jsch-0.1.55.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.jcraft:jsch:0.1.55"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JSch is a pure Java implementation of SSH2"
HOMEPAGE="http://www.jcraft.com/jsch/"
SRC_URI="mirror://sourceforge/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

# Common dependencies
# POM: ${P}.pom
# com.jcraft:jzlib:1.0.7 -> >=dev-java/jzlib-1.1.3:0

CP_DEPEND="
	>=dev-java/jzlib-1.1.3:0
"

DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"
