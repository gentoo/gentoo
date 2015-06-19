# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/sphinx-bootstrap-theme/sphinx-bootstrap-theme-0.4.5.ebuild,v 1.4 2015/03/07 08:28:09 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Sphinx theme integrates the Bootstrap CSS / JavaScript framework"
HOMEPAGE="http://ryan-roemer.github.com/sphinx-bootstrap-theme/README.html"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux"

IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
