# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="XP is an XML 1.0 parser written in Java"
HOMEPAGE="http://www.jclark.com/xml/xp"
SRC_URI="ftp://ftp.jclark.com/pub/xml/${PN}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=virtual/jre-1.6"
DEPEND="
	app-arch/unzip
	>=virtual/jdk-1.6
"

PATCHES=(
	"${FILESDIR}/${P}-fix-jdk-1.7-enum.patch"
)

src_prepare() {
	default
	java-pkg_clean
}
