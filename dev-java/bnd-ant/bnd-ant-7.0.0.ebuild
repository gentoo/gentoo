# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="biz.aQute.bnd:biz.aQute.bnd.ant:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Bnd Ant Tasks"
HOMEPAGE="https://bnd.bndtools.org/"
SRC_URI="https://github.com/bndtools/bnd/archive/${PV}.tar.gz -> aQute.bnd-${PV}.tar.gz"
S="${WORKDIR}/bnd-${PV}"

LICENSE="Apache-2.0 EPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

DEPEND="
	dev-java/ant:0
	~dev-java/bnd-${PV}:0
	>=virtual/jdk-17:*"
RDEPEND=">=virtual/jre-17:*"

JAVA_AUTOMATIC_MODULE_NAME="biz.aQute.bnd.ant"
JAVA_CLASSPATH_EXTRA="
	ant
	bnd
"

JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR="biz.aQute.bnd.ant/src"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	mkdir res || die

	# java-pkg-simple wants resources in JAVA_RESOURCE_DIRS
	pushd biz.aQute.bnd.ant/src > /dev/null || die
		find -type f \
			! -name '*.java' \
			| xargs cp --parent -t ../../res || die
	popd > /dev/null || die
}
