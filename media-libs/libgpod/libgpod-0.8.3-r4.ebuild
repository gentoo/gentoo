# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools udev

DESCRIPTION="Shared library to access the contents of an iPod"
HOMEPAGE="http://www.gtkpod.org/libgpod/"
SRC_URI="mirror://sourceforge/gtkpod/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="+gtk ios +udev"

RDEPEND="
	>=app-pda/libplist-1.0:=
	>=dev-db/sqlite-3:3
	>=dev-libs/glib-2.16:2
	dev-libs/libxml2:2
	sys-apps/sg3_utils
	gtk? ( x11-libs/gdk-pixbuf:2 )
	ios? ( app-pda/libimobiledevice:= )
	udev? ( virtual/udev )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/libxslt
	dev-util/intltool
	dev-util/gtk-doc-am
	sys-devel/gettext
	virtual/pkgconfig
"

DOCS=( AUTHORS NEWS README{,.overview,.sqlite,.SysInfo} TROUBLESHOOTING )

PATCHES=(
	"${FILESDIR}"/${P}-comment.patch # bug 537968
	"${FILESDIR}"/${P}-segfault.patch # bug 565052
	"${FILESDIR}"/${P}-pkgconfig_overlinking.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-pygobject
		--disable-static
		--without-hal
		--without-mono
		--without-python
		--with-udev-dir="$(get_udevdir)"
		$(use_enable gtk gdk-pixbuf)
		$(use_with ios libimobiledevice)
		$(use_enable udev)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	rm "${ED}"/usr/$(get_libdir)/pkgconfig/libgpod-sharp.pc || die
	rmdir "${ED}"/tmp || die
	find "${ED}" -name '*.la' -type f -delete || die
}
