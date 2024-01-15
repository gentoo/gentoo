# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME2_EAUTORECONF=yes
inherit gnome2

DESCRIPTION="The GNOME Structured File Library"
HOMEPAGE="https://gitlab.gnome.org/GNOME/libgsf"

LICENSE="LGPL-2.1"
SLOT="0/114" # libgsf-1.so version
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"
IUSE="bzip2 gtk +introspection test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.36:2
	>=dev-libs/libxml2-2.4.16:2
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	gtk? (
		x11-libs/gdk-pixbuf:2
		virtual/imagemagick-tools
	)
	introspection? ( >=dev-libs/gobject-introspection-1:= )
"
DEPEND="${RDEPEND}
	>=dev-build/gtk-doc-am-1.12
	dev-libs/gobject-introspection-common
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
	test? ( dev-perl/XML-Parser )
"

PATCHES=(
	"${FILESDIR}"/1.14.49-skip-valgrind-tests.patch
	"${FILESDIR}"/1.14.51-libxml2-2.12.patch
)

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_with bzip2 bz2) \
		$(use_enable introspection) \
		$(use_with gtk gdk-pixbuf)
}
