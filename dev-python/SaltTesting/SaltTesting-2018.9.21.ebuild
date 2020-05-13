# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit eutils distutils-r1

DESCRIPTION="Required testing tools needed in the several Salt Stack projects"
HOMEPAGE="https://saltstack.com/community/"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/saltstack/salt-testing.git"
	EGIT_BRANCH="develop"
	inherit git-r3
else
	SRC_URI="https://github.com/saltstack/salt-testing/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/salt-testing-${PV}"
	KEYWORDS="amd64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	dev-python/psutil[${PYTHON_USEDEP}]
	>=dev-python/requests-2.4.2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
PATCHES=(
	"${FILESDIR}/SaltTesting-2018.9.21-python37.patch"
)
