# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python module for DNS (Domain Name Service)"
HOMEPAGE="http://pydns.sourceforge.net/ https://pypi.org/project/pydns/"
SRC_URI="http://downloads.sourceforge.net/project/pydns/pydns/${P}/${P}.tar.gz"

LICENSE="CNRI"
SLOT="2"
KEYWORDS="amd64 hppa ~ia64 ~ppc ~sparc x86"
IUSE="examples"

DEPEND="!dev-python/pydns:0
	virtual/libiconv"
RDEPEND=""

# Funny a dns package attempts to use the network on tests
# Await the day that gentoo chills out on such a blanket law.
RESTRICT=test

python_prepare_all() {
	# Fix encodings (should be utf-8 but is latin1).
	local i
	for i in DNS/{Lib,Type}.py; do
		iconv -f ISO-8859-1 -t UTF-8 "${i}" > "${i}.utf8" || die
		mv -f "${i}.utf8" "${i}" || die
	done
	distutils-r1_python_prepare_all
}

python_test() {
	local test
	for test in tests/{test.py,test[2-5].py,testsrv.py}
	do
		"${PYTHON}" $test || die
	done
}

python_install_all() {
	use examples && local EXAMPLES=( ./{tests,tools}/. )
	distutils-r1_python_install_all
}
