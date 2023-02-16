# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/${PN}/borg.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="Deduplicating backup program with compression and authenticated encryption"
HOMEPAGE="https://borgbackup.readthedocs.io/"

LICENSE="BSD"
SLOT="0"

# Unfortunately we have a file conflict with app-office/borg, bug #580402
# borgbackup is *very* picky about which msgpack it work with,
# check setup.py on bumps.
RDEPEND="
	!!app-office/borg
	app-arch/lz4
	virtual/acl
	dev-python/pyfuse3[${PYTHON_USEDEP}]
	~dev-python/msgpack-1.0.4[${PYTHON_USEDEP}]
	dev-libs/openssl:0=
"

DEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/cython-0.29.29[${PYTHON_USEDEP}]
	dev-python/pkgconfig[${PYTHON_USEDEP}]
	${RDEPEND}
"

src_install() {
	distutils-r1_src_install
	doman docs/man/*
}
