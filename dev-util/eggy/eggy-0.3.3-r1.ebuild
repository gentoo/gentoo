# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/eggy/eggy-0.3.3-r1.ebuild,v 1.1 2015/01/11 11:39:23 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="An IDE/editor for several programming languages, including Python, Java, C, Perl and others"
HOMEPAGE="http://eggy.yolky.org/eggy/default/about"
SRC_URI="http://eggy.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/PyQt4[X,${PYTHON_USEDEP}]
	dev-python/qscintilla-python[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_prepare_all() {
	# remove the bundled chardet library
	sed -i "s:'eggy\\.chardet', ::" setup.py || die
	rm -rf ${P}/${PN}/chardet || die
	distutils-r1_python_prepare_all
}
