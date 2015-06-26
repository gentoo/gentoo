# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/alabaster/alabaster-0.7.6.ebuild,v 1.1 2015/06/26 12:33:59 jlec Exp $

EAPI="5"

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy pypy3 )

inherit distutils-r1 flag-o-matic

DESCRIPTION="A configurable sidebar-enabled Sphinx theme"
HOMEPAGE="https://github.com/bitprophet/alabaster"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~hppa ~ppc64 ~x86"
SLOT="0"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
