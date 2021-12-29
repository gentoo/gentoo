# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_7 python3_8 python3_9 )
DISTUTILS_USE_SETUPTOOLS=

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
IUSE=""

DEPEND=">=dev-python/pbr-4.1.0[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/requests-1.1[${PYTHON_USEDEP}]"

python_prepare_all() {
	sed -i -e '/manpages/,+1d' setup.cfg || die
	distutils-r1_python_prepare_all
}
