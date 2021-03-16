# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PV="$(ver_rs 1- '_')"
MY_P="xalan-j_${MY_PV}"

DESCRIPTION="DOM Level 3 serializer from Apache Xalan, shared by Xalan and Xerces"
HOMEPAGE="https://xalan.apache.org/"
SRC_URI="mirror://apache/xalan/xalan-j/source/${MY_P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

JAVA_SRC_DIR="src"
JAVA_RESOURCE_DIRS="resources"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	# kill all non-serializer sources to ease javadocs and dosrc
	find src/org/ -type f ! -path "src/org/apache/xml/serializer/*" -delete || die

	# remove bundled jars
	find -name "*.jar" -delete || die
	rm src/*.tar.gz || die

	# move resources elsewhere
	mkdir -p resources/org/apache/xml/serializer || die
	mv src/org/apache/xml/serializer/*.properties resources/org/apache/xml/serializer/ || die
}
