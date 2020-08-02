# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils toolchain-funcs

COMMIT="cc31822e4ebe54c0109623ac0c5cdf0e3acad755"
DESCRIPTION="Free version of the well-known city building simulation"
HOMEPAGE="https://www.donhopkins.com/home/micropolis/"
SRC_URI="https://gitlab.com/stargo/micropolis/-/archive/${COMMIT}/micropolis-${COMMIT}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libsdl
	media-libs/sdl-mixer
	x11-libs/libX11
	x11-libs/libXpm"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/bison"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	default

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
