# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Tool to submit code to Gerrit"
HOMEPAGE="https://git.openstack.org/cgit/openstack-infra/git-review"
if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://opendev.org/opendev/${PN}.git"
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~x64-cygwin ~amd64-linux ~x86-linux"
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
