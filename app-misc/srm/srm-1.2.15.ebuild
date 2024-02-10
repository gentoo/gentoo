# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="A command-line compatible rm which destroys file contents before unlinking"
HOMEPAGE="https://sourceforge.net/projects/srm/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="debug"

DEPEND="sys-kernel/linux-headers"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.15-cflags.patch
	"${FILESDIR}"/${PN}-1.2.15-musl.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# enable the sighandler_t decl on glibc and musl
	append-cppflags -D_GNU_SOURCE
	econf $(use_enable debug)
}

pkg_postinst() {
	ewarn "Please note that srm will not work as expected with any journaled file"
	ewarn "system (e.g., reiserfs, ext3)."
	ewarn "See: ${EROOT}/usr/share/doc/${PF}/README"
}
