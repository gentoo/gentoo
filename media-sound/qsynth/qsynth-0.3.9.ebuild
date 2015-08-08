# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
LANGS="cs de fr ru sr"

inherit qt4-r2 eutils

DESCRIPTION="A Qt application to control FluidSynth"
HOMEPAGE="http://qsynth.sourceforge.net/"
SRC_URI="mirror://sourceforge/qsynth/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug jack alsa pulseaudio"
KEYWORDS="~amd64 ppc ~x86"

DEPEND=">=dev-qt/qtcore-4.2:4
	>=dev-qt/qtgui-4.2:4
	>=media-sound/fluidsynth-1.0.7a[jack?,alsa?,pulseaudio?]
	x11-libs/libX11"
RDEPEND="${DEPEND}"

REQUIRED_USE="|| ( alsa jack pulseaudio )"

DOCS="AUTHORS ChangeLog README TODO TRANSLATORS"

src_configure() {
	econf $(use_enable debug)
	eqmake4 "${PN}.pro" -o "${PN}.mak"
}

src_compile() {
	"$(qt4_get_bindir)"/lupdate "${PN}.pro" || die "lupdate failed"
	qt4-r2_src_compile
}

src_install () {
	qt4-r2_src_install

	# The desktop file is invalid, and we also change the command
	# depending on useflags
	rm -rf "${D}/usr/share/applications/qsynth.desktop"

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
