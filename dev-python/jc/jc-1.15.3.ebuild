# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Converts the output of popular command-line tools and file-types to JSON"
HOMEPAGE="https://github.com/kellyjonbrazil/jc/tags"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/xmltodict[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -e "s|\\(^[[:space:]]*'[.[:alnum:]]\+\\)>=[^']*|\\1|" -i setup.py || die
	distutils-r1_python_prepare_all
}
