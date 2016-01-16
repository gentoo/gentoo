# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="100% Pure Java Regular Expression package"
SRC_URI="mirror://apache/jakarta/regexp/source/${P}.tar.gz"
HOMEPAGE="http://jakarta.apache.org/"

SLOT="1.3"
IUSE=""
LICENSE="Apache-1.1"
KEYWORDS="~amd64 ~ppc64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/java"

java_prepare() {
	rm build.xml || die
	find -name "*.jar" -delete || die
}
