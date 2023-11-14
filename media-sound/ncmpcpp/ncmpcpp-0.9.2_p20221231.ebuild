# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

NCMPCPP_COMMIT="9f44edf0b1d74da7cefbd498341d59bc52f6043f"

DESCRIPTION="featureful ncurses based MPD client inspired by ncmpc"
HOMEPAGE="https://ncmpcpp.rybczak.net/ https://github.com/ncmpcpp/ncmpcpp"
SRC_URI="https://github.com/ncmpcpp/ncmpcpp/archive/${NCMPCPP_COMMIT}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="clock lto outputs taglib visualizer"

RDEPEND="
	dev-libs/boost:=[icu,nls]
	dev-libs/icu:=
	media-libs/libmpdclient
	net-misc/curl
	sys-libs/ncurses:=[unicode(+)]
	sys-libs/readline:=
	taglib? ( media-libs/taglib )
	visualizer? ( sci-libs/fftw:3.0= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}-${NCMPCPP_COMMIT}"

src_prepare() {
	default
	eautoreconf

	sed -i -e '/^docdir/d' {,doc/}Makefile{.am,.in} || die
	sed -i -e 's|COPYING||g' Makefile{.am,.in} || die
}

src_configure() {
	filter-lto

	econf \
		$(use_enable clock) \
		$(use_enable outputs) \
		$(use_enable visualizer) \
		$(use_with lto) \
		$(use_with taglib) \
		$(use_with visualizer fftw)
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
	elog "If you want to use the visualizer, you need mpd with fifo enabled."
	echo
	fi
}
