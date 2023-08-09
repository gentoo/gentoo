# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Tool to submit code to Gerrit"
HOMEPAGE="https://git.openstack.org/cgit/openstack-infra/git-review"
if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://opendev.org/opendev/${PN}.git"
else
	inherit pypi
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="Apache-2.0"
SLOT="0"

BDEPEND="
	>=dev-python/pbr-4.1.0[${PYTHON_USEDEP}]
"
RDEPEND="
	>=dev-python/requests-1.1[${PYTHON_USEDEP}]
"

python_prepare_all() {
	sed -i -e '/manpages/,+1d' setup.cfg || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	doman git-review.1

	distutils-r1_python_install_all
}
