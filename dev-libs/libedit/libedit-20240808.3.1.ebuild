# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool multilib-minimal

MY_P=${P/./-}
DESCRIPTION="BSD replacement for libreadline"
HOMEPAGE="https://thrysoee.dk/editline/"
SRC_URI="https://thrysoee.dk/editline/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"
IUSE="static-libs"

DEPEND="
	>=sys-libs/ncurses-5.9-r3[static-libs?,${MULTILIB_USEDEP}]
"
RDEPEND="
	${DEPEND}
"

QA_PKGCONFIG_VERSION=$(ver_cut 2-3)

src_prepare() {
	default
	elibtoolize
}

multilib_src_configure() {
	local myconf=(
		$(use_enable static-libs static)
		--enable-fast-install
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
