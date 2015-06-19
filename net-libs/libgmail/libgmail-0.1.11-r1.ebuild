# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libgmail/libgmail-0.1.11-r1.ebuild,v 1.2 2015/03/13 23:56:45 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Python bindings to access Google's gmail service"
HOMEPAGE="http://libgmail.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

DEPEND="dev-python/clientcookie[${PYTHON_USEDEP}]
	dev-python/mechanize[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

pkg_setup() {
	python-single-r1_pkg_setup
}
