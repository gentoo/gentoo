# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=python-sshpubkeys-${PV}
DESCRIPTION="OpenSSH public key parser for Python"
HOMEPAGE="
	https://pypi.org/project/sshpubkeys/
	https://github.com/ojarva/python-sshpubkeys/
"
SRC_URI="
	https://github.com/ojarva/python-sshpubkeys/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"

RDEPEND="
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/ecdsa[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
