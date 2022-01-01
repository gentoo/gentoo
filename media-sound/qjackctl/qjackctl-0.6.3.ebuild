# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic qmake-utils xdg

DESCRIPTION="Qt GUI to control the JACK Audio Connection Kit and ALSA sequencer connections"
HOMEPAGE="https://qjackctl.sourceforge.io/"
SRC_URI="mirror://sourceforge/qjackctl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa dbus debug portaudio"

BDEPEND="dev-qt/linguist-tools:5"
RDEPEND="
	app-arch/gzip
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	virtual/jack
	alsa? ( media-libs/alsa-lib )
	dbus? ( dev-qt/qtdbus:5 )
	portaudio? ( media-libs/portaudio )"
DEPEND="${RDEPEND}"

src_configure() {
	append-cxxflags -std=c++11
	local myeconfargs=(
		$(use_enable alsa alsa-seq)
		$(use_enable dbus)
		$(use_enable debug)
		$(use_enable portaudio)
		--enable-jack-version
	)
	econf "${myeconfargs[@]}"
	eqmake5 ${PN}.pro -o ${PN}.mak
}

src_compile() {
	emake -f ${PN}.mak
}

src_install() {
	default

	gunzip "${D}/usr/share/man/man1/qjackctl.fr.1.gz" || die
	gunzip "${D}/usr/share/man/man1/qjackctl.1.gz" || die
}
