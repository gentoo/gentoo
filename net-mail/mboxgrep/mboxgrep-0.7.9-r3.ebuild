# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools

DESCRIPTION="Grep for mbox files"
HOMEPAGE="https://datatipp.se/mboxgrep/"
SRC_URI="https://downloads.sourceforge.net/mboxgrep/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
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
		$(use_with dmalloc dmalloc $(usex dmalloc yes no))
}

src_install() {
	emake \
		prefix="${D}"/usr \
		mandir="${D}"/usr/share/man \
		infodir="${D}"/usr/share/info \
		install
	dodoc ChangeLog NEWS TODO README
}
