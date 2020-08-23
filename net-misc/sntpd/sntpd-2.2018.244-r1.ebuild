# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="ntpclient"
MY_PV="${PV/2./}"
MY_P="${MY_PN}-${MY_PV/./_}"

DESCRIPTION="A NTP (RFC-1305 and RFC-4330) client for unix-alike systems"
HOMEPAGE="https://github.com/troglobit/sntpd"
SRC_URI="https://github.com/troglobit/sntpd/releases/download/${MY_PV}/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86"
IUSE="debug embedded obsolete +syslog"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${MY_PN}-${MY_PV}-linux-headers-5.2.patch"
)

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable debug replay)
		$(use_enable embedded mini)
		$(use_enable obsolete)
		$(use_enable !obsolete siocgstamp)
		$(use_enable syslog)
	)

	econf "${myeconfargs[@]}"
}
