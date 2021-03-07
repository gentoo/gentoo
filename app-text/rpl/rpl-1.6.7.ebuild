# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_7,3_8} )

inherit distutils-r1

DESCRIPTION="Intelligent recursive search/replace utility"
HOMEPAGE="http://rpl.sourceforge.net/"
SRC_URI="http://deb.debian.org/debian/pool/main/r/${PN}/${PN}_${PV}.orig.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

#python_prepare_all() {
#	iconv -f latin1 -t utf8 -o setup.py.new setup.py || die
#	mv setup.py.new setup.py || die
#	distutils-r1_python_prepare_all
#}
#
#python_install_all() {
#	distutils-r1_python_install_all
#	doman ${PN}.1
#}
