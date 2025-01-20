# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit toolchain-funcs python-any-r1

DESCRIPTION="Command line tool for URL parsing and manipulation"
HOMEPAGE="https://curl.se/trurl/ https://daniel.haxx.se/blog/2023/04/03/introducing-trurl/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/curl/trurl"
	inherit git-r3
else
	## Temporary workaround for trurl-0.16.gz already existing as a different
	## file in mirrors.
	SRC_URI="https://github.com/curl/trurl/releases/download/${P}/${P}.tar.gz -> ${P}-tmp.tar.gz" ##
	#SRC_URI="https://github.com/curl/trurl/releases/download/${P}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64"
fi

LICENSE="curl"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

# Older curls may work but not all features will be present
DEPEND=">=net-misc/curl-7.81.0"
RDEPEND="${DEPEND}"
BDEPEND="test? ( ${PYTHON_DEPS} )"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_compile() {
	tc-export CC
	export NDEBUG=1

	default
}

src_test() {
	emake PYTHON3="${EPYTHON}" test
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
}
