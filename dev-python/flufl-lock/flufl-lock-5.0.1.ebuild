# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit distutils-r1

MY_PN=${PN/-/.}

DESCRIPTION="NFS-safe file locking with timeouts for POSIX systems."
HOMEPAGE="https://gitlab.com/warsaw/flufl.lock"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/atpublic[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/typing-extensions[${PYTHON_USEDEP}]
	' python3_{6,7})"

# See https://gitlab.com/warsaw/flufl.lock/-/issues/22
PATCHES=( "${FILESDIR}/flufl-lock-dontinstalltests.diff" )
