# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop flag-o-matic toolchain-funcs wrapper

COMMIT="6f873e16d6a1a8f6f59c1e5a75ec5f52ce5c89b6"
DESCRIPTION="Free version of the well-known city building simulation"
HOMEPAGE="https://www.donhopkins.com/home/micropolis/"
SRC_URI="https://gitlab.com/stargo/micropolis/-/archive/${COMMIT}/micropolis-${COMMIT}.tar.bz2"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl
	media-libs/sdl-mixer
	x11-libs/libX11
	x11-libs/libXpm"
DEPEND="${RDEPEND}"
BDEPEND="app-alternatives/yacc"

# parallel build is broken
MAKEOPTS="-j1"

# clang fixes, submitted upstream:
# https://gitlab.com/stargo/micropolis/-/merge_requests/1
PATCHES=( "${FILESDIR}/micropolis-fix-clang15.diff" )

src_prepare() {
	default

	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/859223
	# https://gitlab.com/stargo/micropolis/-/issues/1
	#
	# Do not trust with LTO either.
	append-flags -fno-strict-aliasing
	filter-lto

	sed -i -e "s|-O3|${CFLAGS}|" \
		src/tclx/config.mk src/{sim,tcl,tk}/makefile || die
	sed -i -e "s|XLDFLAGS=|&${LDFLAGS}|" \
		src/tclx/config.mk || die
}

src_compile() {
	emake -C src LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	local dir=/usr/share/${PN}

	exeinto "${dir}/res"
	doexe src/sim/sim
	insinto "${dir}"
	doins -r activity cities images manual res

	make_wrapper micropolis res/sim "${dir}"
	doicon Micropolis.png
	make_desktop_entry micropolis "Micropolis" Micropolis
}
