# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/singledispatch/singledispatch-3.4.0.3.ebuild,v 1.4 2015/03/09 00:04:39 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="A library to bring functools.singledispatch from Python 3.4 to Python 2.6-3.3"
HOMEPAGE="http://docs.python.org/3/library/functools.html#functools.singledispatch"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PF}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
