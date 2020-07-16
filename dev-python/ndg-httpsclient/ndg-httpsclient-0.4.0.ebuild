# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python3_6 pypy3 )

inherit distutils-r1

DESCRIPTION="Provides enhanced HTTPS support for httplib and urllib2 using PyOpenSSL"
HOMEPAGE="
	https://github.com/cedadev/ndg_httpsclient/
	https://pypi.org/project/ndg-httpsclient/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P/-/_}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

RDEPEND="dev-python/pyopenssl[$(python_gen_usedep 'python*' pypy)]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${P/-/_}"

# doc build by Makefile in folder documentation is broken
