# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qmake-utils

DESCRIPTION="A Qt application to control the JACK Audio Connection Kit and ALSA sequencer connections"
HOMEPAGE="http://qjackctl.sourceforge.net/"
SRC_URI="mirror://sourceforge/qjackctl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="alsa dbus debug portaudio +qt5"

RDEPEND="
	virtual/jack
	qt5? ( dev-qt/qtcore:5 dev-qt/qtgui:5 dev-qt/qtxml:5 dev-qt/qtwidgets:5 dev-qt/qtx11extras:5 )
	!qt5? ( dev-qt/qtcore:4 dev-qt/qtgui:4 )
	alsa? ( media-libs/alsa-lib )
	dbus? ( dev-qt/qtdbus:4 )
	portaudio? ( media-libs/portaudio )"
DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog README TODO TRANSLATORS"

src_configure() {
	econf \
		$(use_with !qt5 qt4 "$(qt4_get_bindir)/..") \
		$(use_with qt5 qt5 "$(qt5_get_bindir)/..") \
		$(use_enable alsa alsa-seq) \
		$(use_enable dbus) \
		$(use_enable debug) \
		$(use_enable portaudio)

	# Emulate what the Makefile does, so that we can get the correct
	# compiler used.
	if use qt5 ; then
		eqmake5 ${PN}.pro -o ${PN}.mak
	else
		eqmake4 ${PN}.pro -o ${PN}.mak
	fi
}

src_compile() {
	emake -f ${PN}.mak
}
