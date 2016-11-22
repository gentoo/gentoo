# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python3_{4,5} )

inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/${PN}/borg.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Deduplicating backup program with compression and authenticated encryption."
HOMEPAGE="https://borgbackup.readthedocs.io/"

LICENSE="BSD"
SLOT="0"
IUSE="libressl +fuse"

# Unformately we have a file conflict with app-office/borg, bug #580402
RDEPEND="
	!!app-office/borg
	app-arch/lz4
	dev-python/msgpack[${PYTHON_USEDEP}]
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	fuse? ( dev-python/llfuse[${PYTHON_USEDEP}] )
"

DEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	${RDEPEND}
"
