# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools multilib-minimal

DESCRIPTION="Frame Streams implementation in C"
HOMEPAGE="https://github.com/farsightsec/fstrm"
SRC_URI="https://github.com/farsightsec/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~s390 ~sparc x86"
IUSE="static-libs utils"

RDEPEND="utils? ( dev-libs/libevent[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig[${MULTILIB_USEDEP}]"

src_prepare() {
	default
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable utils programs)
}

multilib_src_install_all() {
	default
	find "${ED}" -name '*.la' -delete
}
