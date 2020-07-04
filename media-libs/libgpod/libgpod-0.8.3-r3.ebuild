# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools mono-env udev

DESCRIPTION="Shared library to access the contents of an iPod"
HOMEPAGE="http://www.gtkpod.org/libgpod/"
SRC_URI="mirror://sourceforge/gtkpod/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="+gtk +udev ios mono"

RDEPEND="
	>=app-pda/libplist-1.0:=
	>=dev-db/sqlite-3:3
	>=dev-libs/glib-2.16:2
	dev-libs/libxml2:2
	sys-apps/sg3_utils
	gtk? ( x11-libs/gdk-pixbuf:2 )
	ios? ( app-pda/libimobiledevice:= )
	udev? ( virtual/udev )
	mono? (
		>=dev-lang/mono-1.9.1
		>=dev-dotnet/gtk-sharp-2.12
	)
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
	"${FILESDIR}"/${P}-comment.patch #537968
	"${FILESDIR}"/${P}-segfault.patch #565052
	"${FILESDIR}"/${P}-mono4.patch
	"${FILESDIR}"/${P}-pkgconfig_overlinking.patch
)

pkg_setup() {
	use mono && mono-env_pkg_setup
}

src_prepare() {
	default

	# mono-4 fixes from Fedora
	sed -e "s#public DateTime#public System.DateTime#g" \
		-i bindings/mono/libgpod-sharp/Artwork.cs || die
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable udev) \
		$(use_enable gtk gdk-pixbuf) \
		--disable-pygobject \
		--without-hal \
		$(use_with ios libimobiledevice) \
		--with-udev-dir="$(get_udevdir)" \
		--without-python \
		$(use_with mono)
}

src_install() {
	default
	rmdir "${ED}"/tmp || die
	find "${D}" -name '*.la' -type f -delete || die
}
