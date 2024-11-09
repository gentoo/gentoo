# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="Free, easy, personal accounting for everyone"
HOMEPAGE="
	https://www.gethomebank.org/
	https://launchpad.net/homebank
"
SRC_URI="https://www.gethomebank.org/public/sources/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="+ofx"

RDEPEND="
	>=dev-libs/glib-2.39:2
	net-libs/libsoup:3.0
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
	x11-libs/pango
	ofx? ( >=dev-libs/libofx-0.8.3:= )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	>=dev-lang/perl-5.8.1
	dev-perl/XML-Parser
	>=dev-util/intltool-0.40.5
	sys-devel/gettext
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog README )

src_configure() {
	econf $(use_with ofx)
}
