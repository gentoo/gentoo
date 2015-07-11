# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/setconf/setconf-0.6.7.ebuild,v 1.1 2015/07/11 00:47:28 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_{3,4}} )
inherit python-single-r1

DESCRIPTION="A small python based utility used to change configuration files"
HOMEPAGE="http://setconf.roboticoverlords.org/"
SRC_URI="http://${PN}.roboticoverlords.org/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=${PYTHON_DEPS}

# "REQUIRED_USE is needed to have a (un-)nice error when someone disabled all of python3" -mgorny
REQUIRED_USE=${PYTHON_REQUIRED_USE}

pkg_setup() {
	python-single-r1_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	unpack ./${PN}.1.gz
}

src_prepare() {
	python_fix_shebang ${PN}.py #462326
}

src_install() {
	python_doscript ${PN}.py
	dosym ${PN}.py /usr/bin/${PN}
	doman ${PN}.1
}
