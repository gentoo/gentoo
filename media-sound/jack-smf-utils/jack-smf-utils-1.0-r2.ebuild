# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Utilities for MIDI streams and files using Jack MIDI"
HOMEPAGE="https://sourceforge.net/projects/jack-smf-utils/"
SRC_URI="https://sourceforge.net/projects/jack-smf-utils/files/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lash"

RDEPEND="
	dev-libs/glib
	media-libs/libsmf
	virtual/jack
	lash? ( media-sound/lash )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

# bugs: #427362 #697002 #724762
# file collision with bundled media-libs/libsmf (smfsh binary).
PATCHES=( "${FILESDIR}"/${PN}-1.0-unbundle-libsmf-smfsh.patch )

src_prepare() {
	default

	# make well sure the bundled libsmf and smfsh do not get built
	# see bugs above
	rm -rf libsmf || die

	eautoreconf
}

src_configure() {
	econf $(use_with lash)
}
