# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="Pycadia. Home to vector gaming, python style"
HOMEPAGE="http://www.anti-particle.com/pycadia.shtml"
SRC_URI="http://www.anti-particle.com/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/pygame-1.5.5
	dev-python/pygtk:2
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	{
		echo "#!/bin/sh"
		echo "cd /usr/share/${PN}"
		echo "exec python2 ./pycadia.py \"\${@}\""
	} > "${T}/pycadia"
}

src_install() {
	dobin "${T}/pycadia"

	insinto "/usr/share/${PN}"
	doins -r {glade,pixmaps,sounds} *.py pycadia.conf

	exeinto "/usr/share/${PN}"
	doexe pycadia.py spacewarpy.py vektoroids.py

	newicon pixmaps/pysteroids.png ${PN}.png
	make_desktop_entry ${PN} Pycadia

	dodoc doc/{TODO,CHANGELOG,README}
}
