# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
PYTHON_REQ_USE=( sqlite )

inherit distutils-r1 eutils

DESCRIPTION="Tool for searching quassel logs from the commandline"
HOMEPAGE="https://github.com/fish-face/quasselgrep"

if [[ "${PV}" == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/65278/quasselgrep.git"
	inherit git-r3
	KEYWORDS=""
else
	MY_COMMIT=9b6b0bc1252daa6e574363d87d04eebd981215a5
	SRC_URI="https://github.com/fish-face/${PN}/tarball/${MY_COMMIT} -> ${P}.tar.gz"
	S="${WORKDIR}/fish-face-${PN}-${MY_COMMIT:0:7}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="dev-python/future[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]"

pkg_postinst() {
	optfeature "access postgres db" dev-python/psycopg:2
}
