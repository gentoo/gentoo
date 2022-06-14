# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic java-pkg-2 toolchain-funcs

DESCRIPTION="NativeThread for priorities on linux for freenet"
HOMEPAGE="https://www.freenetproject.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"

CDEPEND="
	dev-java/jna:4
"
DEPEND="net-p2p/freenet
	>=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}/${P}-javah.patch"
)

src_prepare() {
	default
}

src_compile() {
	append-flags -fPIC
	tc-export CC
	emake
}

src_install() {
	dolib.so lib${PN}.so
	dosym lib${PN}.so /usr/$(get_libdir)/libnative.so
}
