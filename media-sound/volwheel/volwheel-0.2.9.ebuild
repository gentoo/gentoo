# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="A volume control trayicon with mouse wheel support"
HOMEPAGE="https://oliwer.net/b/volwheel.html"
SRC_URI="https://github.com/oliwer/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~mips x86"
IUSE="alsa"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	dev-perl/Gtk2
	alsa? ( media-sound/alsa-utils )"

src_install() {
	./install.pl prefix="${EPREFIX}"/usr destdir="${D}" || die
	einstalldocs
}
