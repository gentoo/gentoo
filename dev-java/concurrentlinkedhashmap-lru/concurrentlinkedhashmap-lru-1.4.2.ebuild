# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.googlecode.concurrentlinkedhashmap:concurrentlinkedhashmap-lru:${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A high performance version of java.util.LinkedHashMap for use as software cache"
HOMEPAGE="https://github.com/ben-manes/concurrentlinkedhashmap"
SRC_URI="https://github.com/ben-manes/concurrentlinkedhashmap/archive/${P}.tar.gz"
S="${WORKDIR}/${PN%lru}${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="dev-java/jsr305:0"

RDEPEND=">=virtual/jre-1.8:*
	${CP_DEPEND}"
DEPEND=">=virtual/jdk-1.8:*
	${CP_DEPEND}"

JAVA_SRC_DIR="src/main/java"

src_prepare() {
	java-pkg-2_src_prepare
	# https://github.com/ben-manes/concurrentlinkedhashmap/issues/46#issuecomment-160696203
	rm src/main/java/com/googlecode/concurrentlinkedhashmap/ConcurrentHashMapV8.java || die
	sed \
		-e 's/ConcurrentHashMapV8/ConcurrentHashMap/' \
		-i src/main/java/com/googlecode/concurrentlinkedhashmap/ConcurrentLinkedHashMap.java || die
}
