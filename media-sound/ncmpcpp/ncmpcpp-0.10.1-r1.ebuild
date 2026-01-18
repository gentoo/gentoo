# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Featureful ncurses based MPD client inspired by ncmpc"
HOMEPAGE="
	https://rybczak.net/ncmpcpp/
	https://github.com/ncmpcpp/ncmpcpp/
"
SRC_URI="https://github.com/ncmpcpp/ncmpcpp/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc x86"
IUSE="clock outputs taglib visualizer"

RDEPEND="
	>=media-libs/libmpdclient-2.1
	dev-libs/boost:=[icu,nls]
	dev-libs/icu:=
	net-misc/curl
	sys-libs/ncurses:=[unicode(+)]
	sys-libs/readline:=
	taglib? ( media-libs/taglib:= )
	visualizer? ( sci-libs/fftw:3.0= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-build/boost-m4-0.4_p20221019
	virtual/pkgconfig
"

DOCS=( CHANGELOG.md README.md )

src_prepare() {
	rm m4/boost.m4 || die # bug 963730

	default
	eautoreconf

	sed -i -e '/^docdir/d' {,doc/}Makefile{.am,.in} || die
	sed -i -e 's|COPYING||g' Makefile{.am,.in} || die
}

src_configure() {
	local myeconfargs=(
		--without-lto # --with-lto only appends -flto. We need more for a dedicated USE flag
		$(use_enable clock)
		$(use_enable outputs)
		$(use_enable visualizer)
		$(use_with taglib)
		$(use_with visualizer fftw)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	dodoc doc/{bindings,config}
}

pkg_postinst() {
	echo
	elog "Example configuration files have been installed at"
	elog "${EROOT}/usr/share/doc/${PF}"
	elog "${P} uses ~/.ncmpcpp/config and ~/.ncmpcpp/bindings"
	elog "as user configuration files."
	echo
	if use visualizer; then
		elog "If you want to use the visualizer, mpd needs to be built with fifo USE flag."
		echo
	fi
}
