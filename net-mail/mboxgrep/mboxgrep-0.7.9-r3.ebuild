# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools

DESCRIPTION="Grep for mbox files"
SRC_URI="mirror://sourceforge/mboxgrep/${P}.tar.gz"
HOMEPAGE="https://datatipp.se/mboxgrep/"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dmalloc"

RDEPEND="
	app-arch/bzip2
	dev-libs/libpcre
	sys-libs/zlib
	dmalloc? ( dev-libs/dmalloc )
"
DEPEND="
	${RDEPEND}
"
PATCHES=(
	"${FILESDIR}"/${P}-_DEFAULT_SOURCE.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${PN}-0.7.9-musl-missing-strcmp.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_with dmalloc no yes)
}

src_install() {
	emake \
		prefix="${D}"/usr \
		mandir="${D}"/usr/share/man \
		infodir="${D}"/usr/share/info \
		install
	dodoc ChangeLog NEWS TODO README
}
