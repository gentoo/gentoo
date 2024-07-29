# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Utilities for MIDI streams and files using Jack MIDI"
HOMEPAGE="https://sourceforge.net/projects/jack-smf-utils/"
SRC_URI="https://sourceforge.net/projects/jack-smf-utils/files/${PN}/${PV}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lash readline"

RDEPEND="
	dev-libs/glib
	virtual/jack
	lash? ( media-sound/lash )
	readline? ( sys-libs/readline:0 )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_with lash) \
		$(use_with readline)
}
