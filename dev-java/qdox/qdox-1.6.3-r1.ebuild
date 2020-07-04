# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Parser for extracting class/interface/method definitions"
HOMEPAGE="https://github.com/codehaus/qdox"
SRC_URI="mirror://gentoo/${P}.jar"

KEYWORDS="amd64 ~arm ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris"
SLOT="1.6"
LICENSE="Apache-2.0"

DEPEND="
	>=virtual/jdk-1.6"

RDEPEND="
	>=virtual/jre-1.6"

S="${WORKDIR}"

JAVA_SRC_DIR="com"

src_prepare() {
	default
	rm -v com/thoughtworks/qdox/ant/AbstractQdoxTask.java \
		com/thoughtworks/qdox/junit/APITestCase.java || die
}
