# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="CLI todo list manager based on the 'Getting Things Done' philosophy"
HOMEPAGE="https://gna.org/projects/yagtd/"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	#fix doc install location
	sed -i -e "s:\/doc\/yagtd:\/doc\/${P}:g" setup.py || die

	distutils-r1_src_prepare
}

python_install() {
	distutils-r1_python_install
	ln -s yagtd.py "${D}$(python_get_scriptdir)"/yagtd || die
}

src_install() {
	distutils-r1_src_install
	dosym yagtd.py /usr/bin/yagtd
}
