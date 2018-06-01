# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="Smart console frontend for virtual/cdrtools and dvd+rw-tools"
HOMEPAGE="http://burn-cd.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-lang/python
	virtual/cdrtools
	app-cdr/dvd+rw-tools"
DEPEND=""

src_install() {
	newbin ${P} ${PN} || die "newbin failed."
}
