# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic qmake-utils

DESCRIPTION="A Qt application to control FluidSynth"
HOMEPAGE="http://qsynth.sourceforge.net/"
SRC_URI="mirror://sourceforge/qsynth/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug jack alsa pulseaudio"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	media-sound/fluidsynth[jack?,alsa?,pulseaudio?]
	x11-libs/libX11"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5
"

REQUIRED_USE="|| ( alsa jack pulseaudio )"

PATCHES=( "${FILESDIR}/${PN}-0.4.0-qt5-tagging.patch" )

src_configure() {
	append-cxxflags -std=c++11
	econf \
		$(use_enable debug) \
		--with-qt5=$(qt5_get_bindir)/..

	eqmake5 ${PN}.pro -o ${PN}.mak
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
