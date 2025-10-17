# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: Spectrum Analyzer (SpAn)"
HOMEPAGE="http://lcr.vdr-developer.org/"
SRC_URI="http://lcr.vdr-developer.org/downloads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-video/vdr:=
	sci-libs/fftw"
RDEPEND="${DEPEND}"

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	elog
	elog "This plugin is meant as middleware, you need appropiate"
	elog "data-provider - as well as visualization-plugins."
}
