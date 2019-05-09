# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools bash-completion-r1

DESCRIPTION="A fast, lightweight quick launch bar"
HOMEPAGE="https://github.com/rodolf0/wbar"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="gtk"
RDEPEND="
	media-libs/imlib2[X]
	x11-libs/libX11
	gtk? (
		dev-libs/glib
		gnome-base/libglade
		media-libs/freetype:2
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2
	)
"
DEPEND="
	${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"
PATCHES=(
	"${FILESDIR}"/${PN}-2.3.3-desktopfile.patch
	"${FILESDIR}"/${PN}-2.3.3-nowerror.patch
	"${FILESDIR}"/${PN}-2.3.3-test.patch
	"${FILESDIR}"/${PN}-2.3.4-automake-1.13.patch
	"${FILESDIR}"/${PN}-2.3.4-c++11.patch
	"${FILESDIR}"/${PN}-2.3.4-completion.patch
)

src_prepare() {
	default

	use gtk || eapply "${FILESDIR}"/${PN}-2.3.4-gtk.patch

	sed -i \
		-e "/^bashcompletiondir/s:=.*$:=$(get_bashcompdir):" \
		etc/Makefile.am || die #482358

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable gtk wbar-config)
}
