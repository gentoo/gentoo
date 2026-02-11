# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_EXT=1

inherit distutils-r1 xdg

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/metabrainz/picard"
	inherit git-r3
else
	if [[ ${PV} == *_p* ]]; then
		COMMIT="8e2cdc4a020b6db03006df8551eb3415511d6a13"
		SRC_URI="https://github.com/metabrainz/${PN}/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:8}.tar.gz"
		S="${WORKDIR}/${PN}-${COMMIT}"
	elif [[ ${PV} == *alpha* ]]; then
		SRC_URI="https://github.com/metabrainz/${PN}/releases/download/release-${PV/_alpha/a}/${PN}-${PV/_alpha/a}.tar.gz"
		S="${WORKDIR}/${PN}-${PV/_alpha/a}"
	else
		SRC_URI="https://data.musicbrainz.org/pub/musicbrainz/${PN}/${P}.tar.gz"
	fi
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

DESCRIPTION="Cross-platform music tagger"
HOMEPAGE="https://picard.musicbrainz.org"

LICENSE="GPL-2+"
SLOT="0"
IUSE="discid fingerprints markdown multimedia nls"

# Plugin manager, git based(?): dev-python/pygit2[${PYTHON_USEDEP}]
RDEPEND="
	$(python_gen_cond_dep '
		dev-python/charset-normalizer[${PYTHON_USEDEP}]
		dev-python/fasteners[${PYTHON_USEDEP}]
		dev-python/pyjwt[${PYTHON_USEDEP}]
		dev-python/pyqt6[gui,multimedia?,network,qml,widgets,${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		media-libs/mutagen[${PYTHON_USEDEP}]
		discid? ( dev-python/discid[${PYTHON_USEDEP}] )
		markdown? ( dev-python/markdown[${PYTHON_USEDEP}] )
	')
	fingerprints? ( media-libs/chromaprint[tools] )
"
DEPEND="test? ( $(python_gen_cond_dep 'dev-python/pyqt6[testlib,${PYTHON_USEDEP}]') )"
BDEPEND="nls? ( dev-qt/qttools:6[linguist] )"

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
