# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python3_4 )

inherit distutils-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/borgbackup/borg.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/b/borgbackup/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Deduplicating backup program with compression and authenticated encryption."
HOMEPAGE="https://borgbackup.github.io/"

LICENSE="BSD"
SLOT="0"
IUSE="libressl +fuse"

RDEPEND="
	app-arch/lz4
	dev-python/msgpack[${PYTHON_USEDEP}]
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	fuse? ( dev-python/llfuse[${PYTHON_USEDEP}] )
"

DEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	${RDEPEND}
"
