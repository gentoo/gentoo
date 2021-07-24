# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Lib/tool to communicate with AVM FRITZ! devices using TR-064 protocol over UPnP"
HOMEPAGE="https://github.com/kbr/fritzconnection"
LICENSE="MIT"
SLOT="0"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/kbr/fritzconnection"
	inherit git-r3
else
	SRC_URI="https://github.com/kbr/fritzconnection/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

RDEPEND=">=dev-python/requests-2.22[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
