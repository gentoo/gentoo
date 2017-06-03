# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1
DISABLE_AUTOFORMATTING=true
inherit distutils-r1 readme.gentoo-r1

DESCRIPTION="A cross-platform music tagger"
HOMEPAGE="https://picard.musicbrainz.org"
SRC_URI="http://ftp.musicbrainz.org/pub/musicbrainz/picard/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="nls"

DEPEND="
	dev-python/PyQt4[X,${PYTHON_USEDEP}]
	dev-qt/qtgui:4[accessibility]
	media-libs/mutagen"
RDEPEND="${DEPEND}"

RESTRICT="test" # doesn't work with ebuilds
S="${WORKDIR}/${PN}-release-${PV}"

DOCS=( AUTHORS.txt NEWS.txt README.md )

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
}
