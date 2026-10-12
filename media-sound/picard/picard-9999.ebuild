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
	VERSION_DEV=$(ver_cut 4)
	case ${VERSION_DEV} in
		"")  # Releases
			MY_PV=${PV}
			[[ $(ver_cut 3) -eq "0" ]] && MY_PV=$(ver_cut 1-2)
			;;&
		p*)
			COMMIT="5fb03ea4f2593f224af8c0bd6439faa08c5a7aaf"
			SRC_URI="https://github.com/metabrainz/${PN}/archive/${COMMIT}.tar.gz -> ${PN}-${COMMIT:0:8}.tar.gz"
			S="${WORKDIR}/${PN}-${COMMIT}"
			;;
		alpha)
			MY_PV=${PV/_alpha/a} ;;&
		beta)
			MY_PV=${PV/_beta/b} ;;&
		rc)
			MY_PV=${PV/_rc/rc} ;;&
		*)
			SRC_URI="https://data.musicbrainz.org/pub/musicbrainz/${PN}/${PN}-${MY_PV}.tar.gz"
			S="${WORKDIR}/${PN}-${MY_PV}"
			;;
	esac
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

DESCRIPTION="Cross-platform music tagger"
HOMEPAGE="https://picard.musicbrainz.org"

LICENSE="GPL-2+"
SLOT="0"
IUSE="discid fingerprints markdown multimedia nls plugins"

RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/charset-normalizer-3.3[${PYTHON_USEDEP}]
		>=dev-python/pyjwt-2[${PYTHON_USEDEP}]
		>=dev-python/pyqt6-6.6.1[gui,multimedia?,network,qml,widgets,${PYTHON_USEDEP}]
		>=dev-python/pyyaml-5.1[${PYTHON_USEDEP}]
		>=media-libs/mutagen-1.45[${PYTHON_USEDEP}]
		>=dev-python/tomlkit-0.12.4[${PYTHON_USEDEP}]
		discid? ( >=dev-python/discid-1.0[${PYTHON_USEDEP}] )
		markdown? ( >=dev-python/markdown-3.2[${PYTHON_USEDEP}] )
		plugins? ( >=dev-python/pygit2-1.19[${PYTHON_USEDEP}] )
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
