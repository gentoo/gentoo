# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Allows a fine-grained control over libpurple events"
HOMEPAGE="http://purple-events.sardemff7.net/"
SRC_URI="https://github.com/sardemff7/purple-events/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="net-im/pidgin"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	default

	eautoreconf
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
