# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
PYTHON_REQ_USE="xml(+)"

inherit edo distutils-r1 prefix

DESCRIPTION="Tool to help select distfiles mirrors for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Mirrorselect"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/mirrorselect.git"
	inherit git-r3

	SSL_FETCH_VER=9999
else
	SRC_URI="
		https://gitweb.gentoo.org/proj/mirrorselect.git/snapshot/${P}.tar.gz
		https://dev.gentoo.org/~dolsen/releases/mirrorselect/${P}.tar.gz
		https://dev.gentoo.org/~dolsen/releases/mirrorselect/mirrorselect-test
	"

	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

	SSL_FETCH_VER=0.3
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="ipv6"

BDEPEND="${DISTUTILS_DEPS}"
RDEPEND="
	dev-util/dialog
	>=net-analyzer/netselect-0.4[ipv6(+)?]
	>=dev-python/ssl-fetch-${SSL_FETCH_VER}[${PYTHON_USEDEP}]
"

distutils_enable_tests setup.py

python_prepare_all() {
	python_setup

	local -x VERSION="${PVR}"
	sed -e 's:os.path.join(os.sep, EPREFIX.lstrip(os.sep), "usr/share/man/man8"):"share/man/man8":' \
		-i setup.py || die
	eprefixify setup.py mirrorselect/main.py
	edo "${PYTHON}" setup.py set_version

	distutils-r1_python_prepare_all
}
