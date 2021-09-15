# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom objenesis-3.2/test/pom.xml --download-uri https://github.com/easymock/objenesis/archive/refs/tags/3.2.tar.gz --slot 0 --keywords "~amd64 ~arm64 ~ppc64 ~x86" --ebuild objenesis-test-3.2.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.objenesis:objenesis-test:3.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Test library for Objenesis library"
HOMEPAGE="http://objenesis.org"
SRC_URI="https://github.com/easymock/objenesis/archive/refs/tags/${PV}.tar.gz -> objenesis-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 x86"

DEPEND="
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}"

JAVA_SRC_DIR="objenesis-${PV}/test/src/main/java"
