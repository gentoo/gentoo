# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Standalone fts library for use with musl"
HOMEPAGE="https://github.com/pullmoll/musl-fts"
SRC_URI="https://github.com/pullmoll/musl-fts/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/musl-fts-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~x86"
IUSE="static-libs"

RDEPEND="!sys-libs/glibc"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	# Compatibility symlink (bug #895946)
	# TODO: Drop this a while after 2024-07-02 once packages have
	# had time to adapt/fix broken patches.
	dosym musl-fts.pc /usr/$(get_libdir)/pkgconfig/fts-standalone.pc
}
