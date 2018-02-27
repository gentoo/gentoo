# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )
DISTUTILS_SINGLE_IMPL=1
DISABLE_AUTOFORMATTING=true

EGIT_REPO_URI="https://github.com/metabrainz/picard"
inherit distutils-r1 git-r3 readme.gentoo-r1 xdg-utils

DESCRIPTION="A cross-platform music tagger"
HOMEPAGE="https://picard.musicbrainz.org"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="nls"

RDEPEND="
	dev-python/PyQt5[declarative,gui,network,widgets,${PYTHON_USEDEP}]
	dev-qt/qtgui:5[accessibility]
	>=media-libs/mutagen-1.38"
DEPEND="
	nls? ( dev-qt/linguist-tools:5 )
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
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
