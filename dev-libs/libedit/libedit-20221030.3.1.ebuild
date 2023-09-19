# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

MY_P=${P/./-}
DESCRIPTION="BSD replacement for libreadline"
HOMEPAGE="https://thrysoee.dk/editline/"
SRC_URI="https://thrysoee.dk/editline/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="static-libs"

DEPEND="
	>=sys-libs/ncurses-5.9-r3[static-libs?,${MULTILIB_USEDEP}]
"
RDEPEND="
	${DEPEND}
"

QA_PKGCONFIG_VERSION=$(ver_cut 2-3)

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
	# file collision with sys-libs/readline
	rm "${ED}/usr/share/man/man3/history.3" || die
}
