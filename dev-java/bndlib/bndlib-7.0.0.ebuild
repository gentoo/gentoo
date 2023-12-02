# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="biz.aQute.bnd:biz.aQute.bndlib:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="bndlib: A Swiss Army Knife for OSGi"
HOMEPAGE="https://bnd.bndtools.org/"
SRC_URI="https://github.com/bndtools/bnd/archive/${PV}.tar.gz -> aQute.bnd-${PV}.tar.gz"
S="${WORKDIR}/bnd-${PV}"

LICENSE="Apache-2.0 EPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64"

CP_DEPEND="
	~dev-java/bnd-annotation-${PV}:0
	~dev-java/bnd-util-${PV}:0
	~dev-java/libg-${PV}:0
	dev-java/osgi-annotation:0
	dev-java/osgi-cmpn:8
	dev-java/osgi-core:0
	dev-java/slf4j-api:0
"

DEPEND="${CP_DEPEND}
	dev-java/osgi-service-log:0
	>=virtual/jdk-17:*
"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-17:*
"

JAVA_AUTOMATIC_MODULE_NAME="biz.aQute.bndlib"
JAVA_CLASSPATH_EXTRA="osgi-service-log"
JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR="biz.aQute.bndlib/src"

src_prepare() {
	java-pkg-2_src_prepare
	mkdir res || die

	# java-pkg-simple wants resources in JAVA_RESOURCE_DIRS
	mv biz.aQute.bndlib/img	res || die
	pushd biz.aQute.bndlib/src > /dev/null || die
		find -type f \
			! -name '*.java' \
			| xargs cp --parent -t ../../res || die
	popd > /dev/null || die
}
