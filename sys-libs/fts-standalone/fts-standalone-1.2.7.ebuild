# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Standalone fts library for use with musl"
HOMEPAGE="https://github.com/pullmoll/musl-fts"
SRC_URI="https://github.com/pullmoll/musl-fts/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~mips ppc x86"
IUSE="static-libs"

DEPEND="
	!sys-libs/glibc
	!sys-libs/uclibc"

S="${WORKDIR}/musl-fts-${PV}"

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
	mv "${ED%/}"/usr/$(get_libdir)/pkgconfig/{musl-fts,fts-standalone}.pc || die
}
