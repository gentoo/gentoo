# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Dummy OS provider for Ganeti"
HOMEPAGE="https://github.com/grnet/ganeti-os-noop"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	dodoc CONTRIBUTORS
	cd ganeti/os/noop
	insinto /usr/share/ganeti/os/noop/
	doins ganeti_api_version
	exeinto /usr/share/ganeti/os/noop/
	doexe create export import rename
}
