# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Traverses Java class file directories and generates design quality metrics"
HOMEPAGE="https://github.com/clarkware/jdepend"
SRC_URI="https://github.com/clarkware/jdepend/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~x64-macos ~x64-solaris"
RESTRICT="test" #921147

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
JAVA_SRC_DIR="src"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="test"
