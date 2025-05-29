# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="biz.aQute.bnd:aQute.libg:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A library to be statically linked. Contains many small utilities"
HOMEPAGE="https://bnd.bndtools.org/"
SRC_URI="https://github.com/bndtools/bnd/archive/${PV/_rc/.RC}.tar.gz -> aQute.bnd-${PV}.tar.gz"
S="${WORKDIR}/bnd-${PV/_rc/.RC}"

LICENSE="Apache-2.0 EPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64"
# aQute.bnd.test.jupiter does not exist
# org.assertj.core.api.junit.jupiter does not exist
RESTRICT="test" #839681

CP_DEPEND="
	dev-java/osgi-cmpn:8
	dev-java/slf4j-api:0
"

DEPEND="
	${CP_DEPEND}
	~dev-java/bnd-annotation-${PV}:0
	dev-java/eclipse-jdt-annotation:0
	>=virtual/jdk-17:*
"

# aQute.libg/src/aQute/libg/uri/URIUtil.java:161:
# error: switch expressions are not supported in -source 11
RDEPEND="
	${CP_DEPEND}
	dev-java/osgi-annotation:0
	dev-java/osgi-core:0
	>=virtual/jre-17:*
"

JAVA_AUTOMATIC_MODULE_NAME="aQute.libg"
JAVA_CLASSPATH_EXTRA="
	bnd-annotation
	eclipse-jdt-annotation
"
JAVA_SRC_DIR="aQute.libg/src"

src_install() {
	java-pkg-simple_src_install
	java-pkg_register-dependency osgi-core
	java-pkg_register-dependency osgi-annotation
}
