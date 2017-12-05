# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit perl-module

DESCRIPTION="A launcher for starting games in a second X session"
HOMEPAGE="https://code.google.com/p/xgamer/"
SRC_URI="https://xgamer.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.10
	>=x11-libs/gtk+-2.18:2
	>=dev-perl/Gtk2-1.120
	virtual/perl-File-Path
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	dev-perl/File-BaseDir
	dev-perl/XML-Twig
	dev-perl/glib-perl
	x11-misc/numlockx
	media-gfx/feh"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}"/${P}-desktopfile.patch
	"${FILESDIR}"/${P}-perl526.patch
)

pkg_postinst() {
	elog "optional dependencies:"
	elog "  x11-wm/openbox (integrates well)"
}
