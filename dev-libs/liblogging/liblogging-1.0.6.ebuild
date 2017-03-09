# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

DESCRIPTION="Liblogging is an easy to use, portable, open source library for system logging"
HOMEPAGE="http://www.liblogging.org"
SRC_URI="http://download.rsyslog.com/liblogging/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~x86"
IUSE="rfc3195 static-libs +stdlog systemd"

RDEPEND="systemd? ( sys-apps/systemd )"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=( ChangeLog )

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable rfc3195)
		$(use_enable stdlog)
		$(use_enable systemd journal)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}"usr/lib* -name '*.la' -delete || die
}
