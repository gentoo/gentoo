# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/${PN}/borg.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="Deduplicating backup program with compression and authenticated encryption"
HOMEPAGE="https://borgbackup.readthedocs.io/"

LICENSE="BSD"
SLOT="0"
IUSE="libressl"

# Unfortunately we have a file conflict with app-office/borg, bug #580402
RDEPEND="
	!!app-office/borg
	app-arch/lz4
	virtual/acl
	dev-python/llfuse[${PYTHON_USEDEP}]
	~dev-python/msgpack-0.5.6[${PYTHON_USEDEP}]
	dev-python/pyzmq[${PYTHON_USEDEP}]
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
"

DEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	${RDEPEND}
"

python_prepare_all() {
	# allow use of new (renamed) msgpack
	sed -i "s|'msgpack-python.*',||g" setup.py || die
	distutils-r1_python_prepare_all
}

src_install() {
	distutils-r1_src_install
	doman docs/man/*
}
