# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Liblogging is an easy to use, portable, open source library for system logging"
HOMEPAGE="http://www.liblogging.org"
SRC_URI="http://download.rsyslog.com/liblogging/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc64 ~riscv ~sparc ~x86"
IUSE="rfc3195 stdlog systemd"

RDEPEND="systemd? ( sys-apps/systemd )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

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
		--disable-static
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
