# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1

DESCRIPTION="Utility for fetching patchsets from public-inbox"
HOMEPAGE="https://pypi.org/project/b4/"
SRC_URI="https://git.kernel.org/pub/scm/utils/b4/b4.git/snapshot/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RESTRICT=test # gentoo:: is missing dependences (e.g. dev-python/textual)

RDEPEND="
	>=dev-python/certifi-3024.7.22[${PYTHON_USEDEP}]
	>=dev-python/cffi-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/charset-normalizer-3.4.6[${PYTHON_USEDEP}]
	>=dev-python/dkimpy-1.1.8[${PYTHON_USEDEP}]
	>=dev-python/dnspython-2.8[${PYTHON_USEDEP}]
	>=dev-python/idna-3.11[${PYTHON_USEDEP}]
	>=dev-python/patatt-0.7[${PYTHON_USEDEP}]
	>=dev-python/pycparser-3.0[${PYTHON_USEDEP}]
	>=dev-python/pynacl-1.6.2[${PYTHON_USEDEP}]
	>=dev-python/requests-2.32.5[${PYTHON_USEDEP}]
	>=dev-python/urllib3-2.6.3[${PYTHON_USEDEP}]
	>=dev-vcs/git-filter-repo-2.47[${PYTHON_USEDEP}]
"
