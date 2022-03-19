# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom pom.xml --download-uri https://codeload.github.com/teras/loadlib/tar.gz/c2fa52016de23998b2886752f4373a17de2017a7 --slot 0 --keywords "~amd64" --ebuild loadlib-0.2.2.ebuild

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.panayotis:loadlib:0.2.2"

inherit java-pkg-2 java-pkg-simple

MY_COMMIT="c2fa52016de23998b2886752f4373a17de2017a7"
DESCRIPTION="Load native libs embedded as resources in a JAR file from Java transparently"
HOMEPAGE="https://github.com/teras/loadlib"
SRC_URI="https://github.com/teras/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/${PN}-${MY_COMMIT}"

JAVA_SRC_DIR="src/main/java"
