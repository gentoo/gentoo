# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1

DESCRIPTION="Required testing tools needed in the several Salt Stack projects"
HOMEPAGE="https://saltstack.com/community/"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/saltstack/salt-testing.git"
	EGIT_BRANCH="develop"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="Apache-2.0"
SLOT="0"

DEPEND="
	>=dev-python/requests-2.4.2[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
