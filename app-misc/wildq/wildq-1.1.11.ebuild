# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Command-line TOML/JSON/INI/YAML/XML processor using jq c bindings"
HOMEPAGE="https://pypi.org/project/wildq/ https://github.com/ahmet2mir/wildq"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="hcl toml xml"
RDEPEND="
	dev-python/jq[${PYTHON_USEDEP}]
	hcl? ( dev-python/pyhcl[${PYTHON_USEDEP}] )
	toml? ( dev-python/toml[${PYTHON_USEDEP}] )
	xml? ( dev-python/xmltodict[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	# Unpin install_requires versions.
	sed -e "s|^\\([ []'[[:alnum:]]\+\\)>=[^']*|\\1|" -i setup.py || die
	distutils-r1_python_prepare_all
}
