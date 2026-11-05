# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Beanshell BSF engine"
HOMEPAGE="https://github.com/beanshell/beanshell"
SRC_URI="https://github.com/beanshell/beanshell/archive/${PV/_rc/RC}.tar.gz -> bsh-${PV}.tar.gz"
S="${WORKDIR}/beanshell-${PV/_rc/RC}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"

CP_DEPEND="
	~dev-java/bsh-${PV}:0
	dev-java/bsf:2.3
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DOCS=( {CHANGES,HISTORY,MIGRATION,README}.md NOTICE )

# JAVA_LAUNCHER_FILENAME="bsh-console"
# JAVA_MAIN_CLASS="bsh.Console"
# JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="bsh-bsf-engine/src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="bsh-bsf-engine/src/test/java"
