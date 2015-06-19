# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sphinxcontrib-httpdomain/sphinxcontrib-httpdomain-1.1.8.ebuild,v 1.4 2015/04/08 08:04:55 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="Extension providing a Sphinx domain for describing RESTful HTTP APIs"
HOMEPAGE="http://bitbucket.org/birkenfeld/sphinx-contrib/ \
	http://packages.python.org/sphinxcontrib-httpdomain/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=dev-python/sphinx-1.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
