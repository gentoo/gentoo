# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_8 python3_9 )
inherit distutils-r1

DESCRIPTION="Ansible module for hashicorp vault"
HOMEPAGE="https://ansible.com/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/TerryHowe/ansible-modules-hashivault.git"
else
	SRC_URI="https://github.com/TerryHowe/ansible-modules-hashivault/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	>=app-admin/ansible-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/hvac-0.9.5[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

# The tests require a private instance of vault
RESTRICT="test"
