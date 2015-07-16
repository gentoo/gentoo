# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/wildmidi/wildmidi-0.2.3.5.ebuild,v 1.9 2015/07/16 12:20:52 klausman Exp $

EAPI=5
inherit base autotools readme.gentoo

DESCRIPTION="Midi processing library and a midi player using the gus patch set"
HOMEPAGE="http://wildmidi.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ppc ppc64 x86"
IUSE="alsa debug"

DEPEND="alsa? ( media-libs/alsa-lib )"
RDEPEND="${DEPEND}
	media-sound/timidity-freepats"

src_prepare() {
	DOC_CONTENTS="${PN} is using timidity-freepats for midi playback.
		A default configuration file was placed on /etc/${PN}.cfg.
		For more information please read the ${PN}.cfg manpage."

	# Workaround for parallel make
	sed -i -e "/^wildmidi_libs/s:=.*:= libWildMidi.la:" "${S}"/src/Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		--disable-werror \
		$(use_enable debug) \
		$(use alsa || echo --with-oss)
}

src_install() {
	base_src_install
	find "${D}" -name '*.la' -exec rm -f {} +
	insinto /etc
	doins "${FILESDIR}"/${PN}.cfg
	readme.gentoo_create_doc
}
