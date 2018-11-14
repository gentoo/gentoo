# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A utility to ping multiple hosts at once"
HOMEPAGE="http://fping.org/"
SRC_URI="http://fping.org/dist/${P}.tar.gz"

LICENSE="fping"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="ipv6 suid"

PATCHES=(
	"${FILESDIR}"/${PN}-4.1-ipv6.patch
)

src_configure() {
	econf $(use_enable ipv6)
}

src_install() {
	default

	if use suid ; then
		fperms u+s /usr/sbin/fping
	fi
}
