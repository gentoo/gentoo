# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1
DISABLE_AUTOFORMATTING=true
inherit eutils distutils-r1 readme.gentoo

DESCRIPTION="A cross-platform music tagger"
HOMEPAGE="http://picard.musicbrainz.org/"
SRC_URI="http://ftp.musicbrainz.org/pub/musicbrainz/picard/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="+acoustid +cdda nls"

DEPEND="dev-python/PyQt4[X,${PYTHON_USEDEP}]
	media-libs/mutagen
	acoustid? ( >=media-libs/chromaprint-1.0[tools] )
	cdda? ( >=media-libs/libdiscid-0.1.1 )"
RDEPEND="${DEPEND}"

RESTRICT="test" # doesn't work with ebuilds
S=${WORKDIR}/${PN}-release-${PV}
DOCS="AUTHORS.txt NEWS.txt"

DOC_CONTENTS="If you are upgrading Picard and it does not start,
try removing Picard's settings:
    rm ~/.config/MusicBrainz/Picard.conf

You should set the environment variable BROWSER to something like
    firefox '%s' &
to let python know which browser to use."

src_compile() {
	distutils-r1_src_compile $(use nls || echo "--disable-locales")
}

src_install() {
	distutils-r1_src_install --disable-autoupdate --skip-build \
		$(use nls || echo "--disable-locales")

	doicon picard.ico
	domenu picard.desktop
	readme.gentoo_create_doc
}
