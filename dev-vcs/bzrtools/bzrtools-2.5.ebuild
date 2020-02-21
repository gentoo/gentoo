# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils versionator

DESCRIPTION="bzrtools is a useful collection of utilities for bzr"
HOMEPAGE="http://bazaar-vcs.org/BzrTools"
SRC_URI="https://launchpad.net/${PN}/stable/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""
#IUSE="test"

RDEPEND=">=dev-vcs/bzr-2.4"
DEPEND="${RDEPEND}"
#	test? ( dev-python/testtools )"

RESTRICT="test"

S="${WORKDIR}/${PN}"

DOCS=( AUTHORS CREDITS NEWS NEWS.Shelf README README.Shelf TODO TODO.heads TODO.Shelf )
