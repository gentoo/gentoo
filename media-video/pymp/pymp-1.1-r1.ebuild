# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1

DESCRIPTION="a lean, flexible frontend to mplayer written in python"
HOMEPAGE="http://jdolan.dyndns.org/trac/wiki/Pymp"
SRC_URI="http://jdolan.dyndns.org/jaydolan/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="media-video/mplayer
	dev-python/pygtk[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"
DEPEND="sys-apps/sed"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

src_compile() {
	python_fix_shebang pymp.py
}

src_install() {
	python_moduleinto /usr/lib/pymp
	python_domodule *.py

	# note: pymp script is a horrible unnecessary wrapper
	# a) with a dependency on sys-apps/which;
	# b) that invokes compiled .pyc directly
	# do not use it
	dodir /usr/bin
	dosym ../lib/pymp/pymp.py /usr/bin/pymp
	fperms +x /usr/lib/pymp/pymp.py

	dodoc CHANGELOG README
	doicon pymp.png
	make_desktop_entry pymp Pymp pymp
}
