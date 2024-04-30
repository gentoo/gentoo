# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Ansible module for hashicorp vault"
HOMEPAGE="https://www.ansible.com/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/TerryHowe/ansible-modules-hashivault.git"
else
	SRC_URI="https://github.com/TerryHowe/ansible-modules-hashivault/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	>=app-admin/ansible-2.12.0[${PYTHON_USEDEP}]
	>=dev-python/hvac-1.2.1[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

# The tests require a private instance of vault
RESTRICT="test"

python_prepare_all() {
	sed -i 's:description-file:description_file:' setup.cfg || die
	distutils-r1_python_prepare_all
}
