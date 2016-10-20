# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils flag-o-matic qmake-utils

DESCRIPTION="A Qt application to control FluidSynth"
HOMEPAGE="http://qsynth.sourceforge.net/"
SRC_URI="mirror://sourceforge/qsynth/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug jack alsa pulseaudio +qt5"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	qt5? (
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
		dev-qt/qtcore:5
	)
	!qt5? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
	media-sound/fluidsynth[jack?,alsa?,pulseaudio?]
	x11-libs/libX11"
DEPEND="${RDEPEND}
	qt5? ( dev-qt/linguist-tools:5 )
"

REQUIRED_USE="|| ( alsa jack pulseaudio )"

src_prepare() {
	default
	use qt5 && eapply "${FILESDIR}/${PN}-0.4.0-qt5-tagging.patch"
}

src_configure() {
	use qt5 && append-cxxflags -std=c++11
	econf \
		$(use_enable debug) \
		$(use_enable !qt5 qt4) \
		--with-qt"$(usex qt5 "5=$(qt5_get_bindir)/.." "4=$(qt4_get_bindir)/..")"

	# Emulate what the Makefile does, so that we can get the correct
	# compiler used.
	if use qt5 ; then
		eqmake5 ${PN}.pro -o ${PN}.mak
	else
		eqmake4 ${PN}.pro -o ${PN}.mak
	fi
}

src_install () {
	emake DESTDIR="${D}" INSTALL_ROOT="${D}" install
	einstalldocs

	# The desktop file is invalid, and we also change the command
	# depending on useflags
	rm "${ED}usr/share/applications/qsynth.desktop" || die

	local cmd
	if use jack; then
		cmd="qsynth"
	elif use pulseaudio; then
		cmd="qsynth -a pulseaudio"
	elif use alsa; then
		cmd="qsynth -a alsa"
	else
		cmd="qsynth -a oss"
	fi

	make_desktop_entry "${cmd}" Qsynth qsynth
}
