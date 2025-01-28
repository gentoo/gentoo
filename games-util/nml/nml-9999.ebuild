# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1

DESCRIPTION="Compiler of NML files into GRF/NFO files"
HOMEPAGE="https://github.com/OpenTTD/nml/"

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/OpenTTD/nml"
	inherit git-r3
else
	SRC_URI="https://github.com/OpenTTD/nml/releases/download/${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pillow[${PYTHON_USEDEP},zlib]
		dev-python/ply[${PYTHON_USEDEP}]
	')
"

python_test() {
	# the tests involving sprites seem to fail when running in the ebuild,
	#  unless --no-cache is passed.
	emake regression NML_FLAGS='-s -c --verbosity=1 --no-cache'
}

src_install() {
	local DOCS=( README.md docs/changelog.txt )
	distutils-r1_src_install

	doman docs/nmlc.1
}
