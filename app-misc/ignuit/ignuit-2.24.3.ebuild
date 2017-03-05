# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools gnome2

DESCRIPTION="Memorization aid based on the Leitner flashcard system"
HOMEPAGE="http://homepages.ihug.co.nz/~trmusson/programs.html#ignuit"
#SRC_URI="http://homepages.ihug.co.nz/~trmusson/stuff/${P}.tar.gz"
# Upstream has put this out as an "emergency release" onto Google Drive; mirror it..
SRC_URI="https://dev.gentoo.org/~leio/distfiles/${P}.testing.tar.gz"
S="${WORKDIR}/${P}.testing"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="examples latex"

RDEPEND="
	>=app-text/gnome-doc-utils-0.3.2
	dev-libs/glib:2
	dev-libs/libxml2:2
	>=dev-libs/libxslt-1.1.28
	>=gnome-base/libgnomeui-2.24.5
	>=gnome-base/gconf-3.2.6:2
	gnome-base/libglade:2.0
	>=media-libs/gstreamer-1.8.2:1.0
	x11-libs/gtk+:2
	x11-libs/pango
	latex? (
		app-text/dvipng
		virtual/latex-base
	)
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.50.0
	sys-devel/gettext
	app-text/gnome-doc-utils
"

src_prepare() {
	eautoreconf # Needed to fix bogus intltool rules
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
