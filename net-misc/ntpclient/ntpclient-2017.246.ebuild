# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="A NTP (RFC-1305) client for unix-alike computers"
HOMEPAGE="https://github.com/troglobit/ntpclient"
SRC_URI="https://github.com/troglobit/ntpclient/releases/download/2017_246/ntpclient-2017_246.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

src_unpack() {
	default
	mv "${WORKDIR}"/${PN}* ${P} || die
}

src_install() {
	dobin "src/${PN}"
	dodoc README.md
	dodoc "doc/HOWTO.md" "doc/rate.awk" "doc/rate2.awk"
}
