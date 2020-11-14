# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="A volume control trayicon with mouse wheel support"
HOMEPAGE="https://oliwer.net/b/volwheel.html"
SRC_URI="https://olwtools.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~mips x86"
IUSE="alsa"

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	dev-perl/Gtk2
	alsa? ( media-sound/alsa-utils )"

PATCHES=(
	"${FILESDIR}"/${P}-perl516.patch
	"${FILESDIR}"/${P}-desktop-QA.patch
)

src_install() {
	./install.pl prefix="${EPREFIX}"/usr destdir="${D}" || die
	einstalldocs
}
