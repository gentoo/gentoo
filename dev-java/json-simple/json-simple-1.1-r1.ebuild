# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-pkg-simple

MY_P="tag_release_1_1_1"

DESCRIPTION="Simple Java toolkit for JSON"
HOMEPAGE="http://www.json.org"
SRC_URI="https://github.com/fangyidong/json-simple/archive/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${PN}-${MY_P}"

JAVA_SRC_DIR="src/main"

src_prepare() {
	default
	rm -rv src/test || die
}
