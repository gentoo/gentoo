# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

MY_COMMIT=502c88bdc7613abb68e868eb520e39ec8a5cf6dd

DESCRIPTION="Tool for searching quassel logs from the commandline"
HOMEPAGE="https://github.com/fish-face/quasselgrep"

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/fish-face/quasselgrep"
	inherit git-r3
else
	SRC_URI="https://github.com/fish-face/${PN}/tarball/${MY_COMMIT} -> ${P}.tar.gz"
	S="${WORKDIR}/fish-face-${PN}-${MY_COMMIT:0:7}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	>=dev-python/psycopg-2.5.3[${PYTHON_USEDEP}]"

src_configure() {
	sed -i 's/pycrypto/pycryptodome/g' "${S}"/setup.py || die "sed failed"
}
