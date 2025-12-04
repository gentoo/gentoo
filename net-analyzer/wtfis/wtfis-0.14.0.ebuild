# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1

DESCRIPTION="Passive hostname, domain and IP lookup tool for non-robots"
HOMEPAGE="https://github.com/pirxthepilot/wtfis"

if [[ ${PV} = "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pirxthepilot/wtfis.git"
else
	SRC_URI="https://github.com/pirxthepilot/wtfis/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~loong ~x86"
fi

LICENSE="MIT"
SLOT="0"

RDEPEND="
	>=dev-python/pydantic-2.12.5[${PYTHON_USEDEP}]
	>=dev-python/python-dotenv-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.32.3[${PYTHON_USEDEP}]
	>=dev-python/rich-14.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/rich[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
