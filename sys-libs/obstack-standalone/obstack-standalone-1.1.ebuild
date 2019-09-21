# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A standalone library to implement GNU libc's obstack."
HOMEPAGE="https://github.com/pullmoll/musl-obstack"
SRC_URI="https://github.com/pullmoll/musl-obstack/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~mips ppc x86"
IUSE="static-libs"

DEPEND="
	!sys-libs/glibc
	!sys-libs/uclibc"

S="${WORKDIR}/musl-obstack-${PV}"

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
	find "${D}" -name '*.la' -delete || die
	mv "${ED%/}"/usr/$(get_libdir)/pkgconfig/{musl-obstack,obstack-standalone}.pc || die
}
