# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )

inherit distutils-r1

DESCRIPTION="Dash front-end renderer"
HOMEPAGE="https://plot.ly/dash"
SRC_URI="mirror://pypi/${PN:0:1}/${PN/-/_}/${P/-/_}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${P/-/_}"

python_install() {
	distutils-r1_python_install

	python_moduleinto ${PN}
	python_domodule package.json digest.json
}
