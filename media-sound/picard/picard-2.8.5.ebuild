# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 xdg

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/metabrainz/picard"
	inherit git-r3
else
	SRC_URI="https://musicbrainz.osuosl.org/pub/musicbrainz/${PN}/${P}.tar.gz"
	KEYWORDS="amd64 x86"
	S="${WORKDIR}/${PN}-release-${PV}"
fi

DESCRIPTION="Cross-platform music tagger"
HOMEPAGE="https://picard.musicbrainz.org"

LICENSE="GPL-2+"
SLOT="0"
IUSE="discid fingerprints nls"

BDEPEND="
	nls? ( dev-qt/linguist-tools:5 )
"
RDEPEND="
	$(python_gen_cond_dep '
		dev-python/fasteners[${PYTHON_USEDEP}]
		dev-python/pyjwt[${PYTHON_USEDEP}]
		dev-python/PyQt5[declarative,gui,network,widgets,${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		media-libs/mutagen[${PYTHON_USEDEP}]
		discid? ( dev-python/python-discid[${PYTHON_USEDEP}] )
	')
	fingerprints? ( media-libs/chromaprint[tools] )
"

distutils_enable_tests pytest

python_compile() {
	local build_args=(
		--disable-autoupdate
	)
	if ! use nls; then
		build_args+=( --disable-locales )
	fi
	distutils-r1_python_compile ${build_args[@]}
}

python_install() {
	local install_args=(
		--disable-autoupdate
		--skip-build
	)
	if ! use nls; then
		install_args+=( --disable-locales )
	fi
	distutils-r1_python_install ${install_args[@]}
}
