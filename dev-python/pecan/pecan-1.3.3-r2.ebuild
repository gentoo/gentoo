# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A WSGI object-dispatching web framework,  lean, fast, with few dependencies."
HOMEPAGE="https://pypi.org/project/pecan/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE=""

RDEPEND="
	>=dev-python/webob-1.4[${PYTHON_USEDEP}]
	>=dev-python/mako-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/webtest-1.3.1[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	>=dev-python/logutils-0.3.0[${PYTHON_USEDEP}]"
