# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="biz.aQute.bnd:aQute.libg:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A library to be statically linked. Contains many small utilities"
HOMEPAGE="https://bnd.bndtools.org/"
SRC_URI="https://github.com/bndtools/bnd/archive/${PV}.tar.gz -> aQute.bnd-${PV}.tar.gz"
S="${WORKDIR}/bnd-${PV}"

LICENSE="Apache-2.0 EPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64"
# aQute.bnd.test.jupiter does not exist
# org.assertj.core.api.junit.jupiter does not exist
RESTRICT="test" #839681

CP_DEPEND="
	dev-java/slf4j-api:0
"

# compile error with jdk:21, restricting to jdk:17
# aQute.libg/src/aQute/lib/collections/SortedList.java:31: error: types List<T> and SortedSet<T> are incompatible;
# public class SortedList<T> implements SortedSet<T>, List<T> {
#        ^
#   both define reversed(), but with unrelated return types
#   where T is a type-variable:
#     T extends Object declared in class SortedList
DEPEND="${CP_DEPEND}
	~dev-java/bnd-annotation-${PV}:0
	dev-java/osgi-cmpn:8
	virtual/jdk:17
"

# aQute.libg/src/aQute/libg/uri/URIUtil.java:161:
# error: switch expressions are not supported in -source 11
RDEPEND="${CP_DEPEND}
	>=virtual/jre-17:*
"

JAVA_AUTOMATIC_MODULE_NAME="aQute.libg"
JAVA_CLASSPATH_EXTRA="
	bnd-annotation
	osgi-cmpn-8
"
JAVA_SRC_DIR="aQute.libg/src"
