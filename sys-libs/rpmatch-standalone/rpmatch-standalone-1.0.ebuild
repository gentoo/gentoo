# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Standalone rpmatch library for use with musl"
HOMEPAGE="https://github.com/pullmoll/musl-rpmatch"
SRC_URI="https://github.com/pullmoll/musl-rpmatch/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~x86"
IUSE="static-libs"

DEPEND="
	!sys-libs/glibc
	!sys-libs/uclibc"

S="${WORKDIR}/musl-rpmatch-${PV}"

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

	mkdir "${ED%/}"/usr/$(get_libdir)/pkgconfig/
	cp "${S}"/musl-rpmatch.pc  "${ED%/}"/usr/$(get_libdir)/pkgconfig/rpmatch-standalone.pc
}
