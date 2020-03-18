# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Tool for diagnosing cdrom drive and digital data (audio) extraction"
HOMEPAGE="http://cdstatus.sourceforge.net"
SRC_URI="mirror://sourceforge/cdstatus/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ppc64 x86"
IUSE=""

pkg_postinst() {
	elog "Copy cdstatus.cfg from /usr/share/cdstatus.cfg"
	elog "to your home directory and edit as needed."
}
