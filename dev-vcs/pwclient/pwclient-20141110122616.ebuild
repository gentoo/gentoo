# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_6} )

inherit eutils python-r1

# The PV comes from:
#	git clone ${EGIT_REPO_URI}
#	cd patchwork
#	EGIT_COMMIT=$(git log -n1 --format=%H apps/patchwork/bin/pwclient)
#	date --date="$(git log -n1 --format=%ci ${EGIT_COMMIT})" -u +%Y%m%d%H%M%S
EGIT_REPO_URI="git://ozlabs.org/home/jk/git/patchwork"
EGIT_COMMIT="8904a7dcaf959da8db4a9a5d92b91a61eed05201"

DESCRIPTION="command line utility for interacting with patchwork repos"
HOMEPAGE="http://jk.ozlabs.org/projects/patchwork/"
SRC_URI="mirror://gentoo/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}"/${P} ${PN} || die
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-*.patch
}

src_install() {
	python_setup
	python_doscript ${PN}
}
