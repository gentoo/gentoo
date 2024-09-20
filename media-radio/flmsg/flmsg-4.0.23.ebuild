# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fldigi helper for creating radiograms"
HOMEPAGE="http://www.w1hkj.com"
SRC_URI="https://downloads.sourceforge.net/fldigi/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-radio/fldigi
		x11-libs/fltk:=
		x11-libs/libX11:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog INSTALL README )
