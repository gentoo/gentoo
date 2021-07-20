# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit xdg

DESCRIPTION="Free, easy, personal accounting for everyone"
HOMEPAGE="http://homebank.free.fr/index.php"
SRC_URI="http://homebank.free.fr/public/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="+ofx"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND=">=dev-libs/glib-2.39
	>=net-libs/libsoup-2.26
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	>=x11-libs/gtk+-3.22:3
	x11-libs/pango
	ofx? ( >=dev-libs/libofx-0.8.3:= )"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-lang/perl-5.8.1
	dev-perl/XML-Parser
	>=dev-util/intltool-0.40.5
	sys-devel/gettext
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog README )

src_prepare() {
	default

	# avoid using eautoreconf
	sed -i -e 's|\$(datadir)/appdata|\$(datadir)/metainfo|' data/Makefile.{am,in} || die
}

src_configure() {
	econf $(use_with ofx)
}
