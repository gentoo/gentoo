# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

MY_P="${PN}-v${PV}"

DESCRIPTION="A TCP-IP emulator used to provide virtual networking services"
HOMEPAGE="https://gitlab.freedesktop.org/slirp/libslirp"
SRC_URI="https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v${PV}/${MY_P}.tar.bz2 -> ${P}.tar.bz2"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~m68k ~ppc ~ppc64 ~riscv ~x86"
IUSE="static-libs valgrind"

RDEPEND="dev-libs/glib:="
# Valgrind usage is automagic but it's not so bad given it's a header-only dep.
DEPEND="${RDEPEND}
	valgrind? ( dev-debug/valgrind )
"

src_prepare() {
	echo "${PV}" > .tarball-version || die
	echo -e "#!${BASH}\necho -n \$(cat '${S}/.tarball-version')" > build-aux/git-version-gen || die
	default
}

src_configure() {
	local emesonargs=(
		-Ddefault_library=$(usex static-libs both shared)
	)
	meson_src_configure
}
