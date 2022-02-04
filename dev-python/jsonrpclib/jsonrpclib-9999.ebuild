# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/tcalmant/jsonrpclib.git"
	inherit git-r3
else
	SRC_URI="https://github.com/tcalmant/jsonrpclib/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~mips ~x86"
fi

DESCRIPTION="python implementation of the JSON-RPC spec (1.0 and 2.0)"
HOMEPAGE="https://github.com/tcalmant/jsonrpclib"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="dev-python/simplejson[${PYTHON_USEDEP}]"

distutils_enable_tests setup.py
