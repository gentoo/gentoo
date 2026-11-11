# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit-core
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="A utility to maintain package.unmask entries up-to-date with masks"
HOMEPAGE="https://gitweb.gentoo.org/proj/diffmask.git/"
SRC_URI="
	https://gitweb.gentoo.org/proj/diffmask.git/snapshot/${P}.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~mips ~x86"

RDEPEND="
	sys-apps/portage[${PYTHON_USEDEP}]
"
