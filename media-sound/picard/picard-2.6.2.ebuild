# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )
DISTUTILS_SINGLE_IMPL=1
DISABLE_AUTOFORMATTING=true
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
		dev-python/PyQt5[declarative,gui,network,widgets,${PYTHON_USEDEP}]
		dev-python/python-dateutil[${PYTHON_USEDEP}]
	')
	dev-qt/qtgui:5
	media-libs/mutagen
	discid? ( dev-python/python-discid )
	fingerprints? ( media-libs/chromaprint[tools] )
"

RESTRICT="test" # doesn't work with ebuilds

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

python_install_all() {
	distutils-r1_python_install_all

	if [[ -n "${REPLACING_VERSIONS}" ]]; then
		elog "If you are upgrading Picard and it does not start, try removing"
		elog "Picard's settings:"
		elog "        rm ~/.config/MusicBrainz/Picard.conf"
	fi
}
