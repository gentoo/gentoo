# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils xdg-utils git-r3 autotools

DESCRIPTION="Qt application to control FluidSynth"
HOMEPAGE="https://qsynth.sourceforge.io/"
EGIT_REPO_URI="https://git.code.sf.net/p/qsynth/code"

LICENSE="GPL-2"
SLOT="0"
IUSE="+alsa debug jack pulseaudio"
KEYWORDS=""

BDEPEND="
	dev-qt/linguist-tools:5
"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-sound/fluidsynth:=[jack?,alsa?,pulseaudio?]
"
RDEPEND="${DEPEND}"

REQUIRED_USE="|| ( alsa jack pulseaudio )"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	sed -e "/@gzip.*mandir)\/man1/d" -i Makefile.in || die
	econf \
		$(use_enable debug)

	eqmake5 ${PN}.pro -o ${PN}.mak
}

src_install() {
	emake DESTDIR="${D}" INSTALL_ROOT="${D}" install
	einstalldocs

	# The desktop file is invalid, and we also change the command
	# depending on useflags
	rm "${D}/usr/share/applications/qsynth.desktop" || die

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

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
