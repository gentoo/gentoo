# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="AIM transport proxy over NAT firewalls"
HOMEPAGE="http://reaim.sourceforge.net/"
SRC_URI="mirror://sourceforge/reaim/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=">=sys-apps/sed-4"
RDEPEND="net-firewall/iptables"

pkg_setup() {
	tc-export CC
}

src_prepare() {
	sed -i -e 's/gcc/$(CC) $(CFLAGS) $(LDFLAGS)/' \
		-e 's/ -g / /'  Makefile || die "sed failed" #365863
	default
}

src_install() {
	local HTML_DOCS=( html )
	einstalldocs
	doman reaim.8
	dosbin reaim
	doinitd "${FILESDIR}"/reaim
}
