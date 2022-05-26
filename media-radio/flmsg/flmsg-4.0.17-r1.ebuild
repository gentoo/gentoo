# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Fldigi helper for creating radiograms"
HOMEPAGE="http://www.w1hkj.com"
SRC_URI="mirror://sourceforge/fldigi/${P}.tar.gz
		https://dev.gentoo.org/~rich0/distfiles/flmsg-4.0.17-patches.tbz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-radio/fldigi
		x11-libs/fltk:=
		x11-libs/libX11:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog INSTALL README )

PATCHES=(
	"${WORKDIR}/${P}-0001-streampos-is-in-the-standard-library-and-access-from.patch"
	"${WORKDIR}/${P}-0002-Minimal-but-extensive-update-to-remove-namespace-std.patch"
)
