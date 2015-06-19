# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-radio/KochMorse/KochMorse-0.99.6-r1.ebuild,v 1.1 2015/03/12 05:16:08 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Morse-tutor for Linux using the Koch-method"
HOMEPAGE="http://KochMorse.googlecode.com/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pyalsaaudio[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_prepare_all() {
	sed -e 's:Categories=Application;:Categories=:' \
		-i kochmorse.desktop || die
	distutils-r1_python_prepare_all
}

pkg_setup() {
	python-single-r1_pkg_setup
}
