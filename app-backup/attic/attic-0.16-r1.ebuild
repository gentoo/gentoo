# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/jborg/attic.git"
	inherit git-r3
else
	SRC_URI="https://github.com/jborg/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Attic is a deduplicating backup program written in Python."
HOMEPAGE="https://attic-backup.org/"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	dev-python/msgpack[${PYTHON_USEDEP}]
	dev-libs/openssl:0=
	dev-python/llfuse[${PYTHON_USEDEP}]"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	${RDEPEND}"

python_prepare_all() {
	# allow use of new (renamed) msgpack
	sed -i '/msgpack/d' setup.py || die
	distutils-r1_python_prepare_all
}
