# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

#if LIVE
EGIT_REPO_URI="git://github.com/g2p/bedup.git
	https://github.com/g2p/bedup.git"
inherit git-r3
#endif

inherit distutils-r1

DESCRIPTION="Btrfs file de-duplication tool"
HOMEPAGE="https://github.com/g2p/bedup"
SRC_URI="https://github.com/g2p/${PN}/archive/v${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# we need btrfs-progs with includes installed.
DEPEND=">=dev-python/cffi-0.5:=[${PYTHON_USEDEP}]
	>=sys-fs/btrfs-progs-0.20_rc1_p358"
RDEPEND="${DEPEND}
	<dev-python/alembic-0.7[${PYTHON_USEDEP}]
	dev-python/contextlib2[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	>=dev-python/sqlalchemy-0.8.2[sqlite,${PYTHON_USEDEP}]"

#if LIVE
SRC_URI=
KEYWORDS=
#endif
