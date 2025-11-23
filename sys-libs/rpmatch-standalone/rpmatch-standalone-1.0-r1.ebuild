# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Standalone rpmatch library for use with musl"
HOMEPAGE="https://github.com/pullmoll/musl-rpmatch"
SRC_URI="https://github.com/pullmoll/musl-rpmatch/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/musl-rpmatch-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~mips ppc ppc64 ~riscv x86"
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
	find "${D}" -name '*.la' -delete || die

	insinto /usr/$(get_libdir)/pkgconfig/
	newins musl-rpmatch.pc ${PN}.pc
}
