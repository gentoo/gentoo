# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
LANGS="cs de es ru"

inherit qt4-r2 eutils flag-o-matic

DESCRIPTION="A Qt application to control FluidSynth"
HOMEPAGE="http://qsynth.sourceforge.net/"
SRC_URI="mirror://sourceforge/qsynth/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug jack alsa pulseaudio"
KEYWORDS="amd64 ppc x86"

DEPEND=">=dev-qt/qtcore-4.2:4
	>=dev-qt/qtgui-4.2:4
	>=media-sound/fluidsynth-1.0.7a[jack?,alsa?,pulseaudio?]
	x11-libs/libX11"
RDEPEND="${DEPEND}"

REQUIRED_USE="|| ( alsa jack pulseaudio )"

DOCS="AUTHORS ChangeLog README TODO TRANSLATORS"

src_prepare() {
	sed -e '/@install/,/share\/locale$/d' -i Makefile.in || die "sed translations failed"

	sed -e 's/@make/@\$(MAKE)/' -i Makefile.in || die "sed Makefile failed"

	qt4-r2_src_prepare
}

src_configure() {
	# Stupidly, qsynth's configure does *not* use pkg-config to
	# discover the presence of Qt4, but uses fixed paths; as they
	# don't really work that well for our case, let's just use this
	# nasty hack and be done with it. *NOTE*: this hinders
	# cross-compile.
	append-flags -I/usr/include/qt4
	append-ldflags -L/usr/$(get_libdir)/qt4

	econf \
		$(use_enable debug)
	eqmake4 "${PN}.pro" -o "${PN}.mak"
}

src_compile() {
	lupdate "${PN}.pro" || die "lupdate failed"
	qt4-r2_src_compile
}

src_install () {
	qt4-r2_src_install

	insinto /usr/share/locale
	local lang
	for lang in ${LANGS} ; do
		if use linguas_${lang} ; then
			doins "src/translations/${PN}_${lang}.qm"
		fi
	done

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
