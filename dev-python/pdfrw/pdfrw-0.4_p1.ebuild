# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

PDFS_COMMIT=d646009a0e3e71daf13a52ab1029e2230920ebf4
DESCRIPTION="PDF file reader/writer library"
HOMEPAGE="https://github.com/sarnold/pdfrw"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/pdfrw.git"
	EGIT_BRANCH="main"
	inherit git-r3
else
	MY_PV="${PV/_p/-}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://github.com/sarnold/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz
		test? ( https://github.com/pmaupin/static_pdfs/archive/${PDFS_COMMIT}.tar.gz
			-> pdfrw-static_pdfs-${PDFS_COMMIT}.tar.gz )"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="BSD MIT"
SLOT="0"
IUSE="crypt"

BDEPEND="dev-python/pillow[${PYTHON_USEDEP}]
	crypt? ( dev-python/pycryptodome[${PYTHON_USEDEP}] )
	test? ( dev-python/reportlab[${PYTHON_USEDEP}] )"

# unittest would be sufficient but its output is unreadable
distutils_enable_tests pytest

src_unpack() {
	default
	if use test; then
		mv "static_pdfs-${PDFS_COMMIT}"/* "${MY_P}"/tests/static_pdfs || die
	fi
}

src_prepare() {
	# broken upstream (sensitive to reportlab version?)
	#sed -e 's:test_rl1_platypus:_&:' \
	#	-i tests/test_examples.py || die
	eapply "${FILESDIR}/pdfrw-fix-import-collections-warning.patch"
	use test && eapply "${FILESDIR}/pdfrw-static-fix-import-collections-warning.patch"

	distutils-r1_src_prepare
}
