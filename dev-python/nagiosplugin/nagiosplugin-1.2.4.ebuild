# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )

inherit distutils-r1

DESCRIPTION="A class library for writing nagios-compatible plugins"
HOMEPAGE="https://bitbucket.org/flyingcircus/nagiosplugin/ https://pypi.python.org/pypi/nagiosplugin/"
if [[ ${PV} == "9999" ]] ; then
	inherit mercurial
	EHG_REPO_URI="https://bitbucket.org/flyingcircus/nagiosplugin/"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="ZPL"
SLOT="0"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test
}
