# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Without annotation processing using runtime-testsuite/processors,
# the tests are bound to fail.  However, the annotation processor
# has been dropped from the 'master' branch as of January 2022, so
# when updating this package to a new upstream version, please
# check if it is possible to enable the tests and pass them.
JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.antlr:antlr4-runtime:4.9.3"

inherit java-pkg-2 java-pkg-simple

MY_PN="${PN%-runtime}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="ANTLR 4 Runtime"
HOMEPAGE="https://www.antlr.org/"
SRC_URI="https://github.com/antlr/antlr4/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="4"
KEYWORDS="amd64 ~arm arm64 ppc64 x86"

DEPEND="
	>=virtual/jdk-1.8:*
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/${MY_PN}4-${PV}"

JAVA_SRC_DIR="runtime/Java/src"
