# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="featureful ncurses based MPD client inspired by ncmpc"
HOMEPAGE="https://rybczak.net/ncmpcpp/"
SRC_URI="${HOMEPAGE}stable/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm hppa ppc ppc64 sparc x86"
IUSE="clock curl outputs taglib unicode visualizer"

RDEPEND="
	!dev-libs/boost:0/1.57.0
	>=media-libs/libmpdclient-2.1
	dev-libs/boost:=[nls,threads]
	sys-libs/ncurses:=[unicode?]
	sys-libs/readline:*
	curl? ( net-misc/curl )
	taglib? ( media-libs/taglib )
	unicode? (
		dev-libs/boost:=[icu]
		dev-libs/icu:=
	)
	visualizer? ( sci-libs/fftw:3.0= )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default

	sed -i -e '/^docdir/d' {,doc/}Makefile{.am,.in} || die
	sed -i -e 's|COPYING||g' Makefile{.am,.in} || die
}

src_configure() {
	econf \
		$(use_enable clock) \
		$(use_enable outputs) \
		$(use_enable unicode) \
		$(use_enable visualizer) \
		$(use_with curl) \
		$(use_with taglib) \
		$(use_with visualizer fftw) \
		--docdir=/usr/share/doc/${PF}
}

src_install() {
	default

	dodoc doc/{bindings,config}
}

pkg_postinst() {
	echo
	elog "Example configuration files have been installed at"
	elog "${ROOT}usr/share/doc/${PF}"
	elog "${P} uses ~/.ncmpcpp/config and ~/.ncmpcpp/bindings"
	elog "as user configuration files."
	echo
	if use visualizer; then
	elog "If you want to use the visualizer, you need mpd with fifo enabled."
	echo
	fi
}
