# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7,8} pypy3 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="YAML parser/emitter that supports roundtrip comment preservation"
HOMEPAGE="https://pypi.org/project/ruamel.yaml/ https://bitbucket.org/ruamel/yaml"
MY_PN="${PN//-/.}"
SRC_URI="https://bitbucket.org/${MY_PN/.//}/get/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

# tests are in ruamel-yaml package

python_install() {
	distutils-r1_python_install --single-version-externally-managed
	find "${ED}" -name '*.pth' -delete || die
}
