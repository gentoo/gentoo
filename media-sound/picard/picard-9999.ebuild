# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
DISTUTILS_SINGLE_IMPL=1
DISABLE_AUTOFORMATTING=true
if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/metabrainz/picard"
	inherit git-r3
else
	SRC_URI="https://musicbrainz.osuosl.org/pub/musicbrainz/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi
inherit distutils-r1 readme.gentoo-r1 xdg

DESCRIPTION="A cross-platform music tagger"
HOMEPAGE="https://picard.musicbrainz.org"

LICENSE="GPL-2+"
SLOT="0"
IUSE="nls"

BDEPEND="
	nls? ( dev-qt/linguist-tools:5 )
"
RDEPEND="
	dev-python/PyQt5[declarative,gui,network,widgets,${PYTHON_USEDEP}]
	dev-qt/qtgui:5[accessibility]
	>=media-libs/mutagen-1.38"

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

	local DOC_CONTENTS="Install optional package media-libs/chromaprint[tools] to enable
calculation and lookup of AcoustID fingerprints.

Install optional package dev-python/python-discid to enable
calculation and lookup of compact disc identifiers (disc IDs).

If you are upgrading Picard and it does not start, try removing
Picard's settings:
	rm ~/.config/MusicBrainz/Picard.conf"
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	xdg_pkg_postinst
}
