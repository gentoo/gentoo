# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: Spectrum Analyzer (SpAn)"
HOMEPAGE="http://lcr.vdr-developer.org/"
SRC_URI="http://lcr.vdr-developer.org/downloads/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.5.7
		>=sci-libs/fftw-3.0.1"
RDEPEND="${DEPEND}"

pkg_postinst() {
	vdr-plugin-2_pkg_postinst

	elog
	elog "This plugin is meant as middleware, you need appropiate"
	elog "data-provider- as well as visualization-plugins."
}
