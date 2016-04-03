# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit eutils mono-env python-single-r1 udev

DESCRIPTION="Shared library to access the contents of an iPod"
HOMEPAGE="http://www.gtkpod.org/libgpod/"
SRC_URI="mirror://sourceforge/gtkpod/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+gtk python +udev ios mono static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=app-pda/libplist-1.0:=
	>=dev-db/sqlite-3:3
	>=dev-libs/glib-2.16:2
	dev-libs/libxml2:2
	sys-apps/sg3_utils
	gtk? ( x11-libs/gdk-pixbuf:2 )
	ios? ( app-pda/libimobiledevice:= )
	python? (
		${PYTHON_DEPS}
		>=media-libs/mutagen-1.8[${PYTHON_USEDEP}]
		>=dev-python/pygobject-2.8:2[${PYTHON_USEDEP}]
		)
	udev? ( virtual/udev )
	mono? (
		>=dev-lang/mono-1.9.1
		>=dev-dotnet/gtk-sharp-2.12
		)
"
DEPEND="${RDEPEND}
	python? ( >=dev-lang/swig-1.3.24:0 )
	dev-libs/libxslt
	dev-util/intltool
	dev-util/gtk-doc-am
	sys-devel/gettext
	virtual/pkgconfig
"

DOCS="AUTHORS NEWS README* TROUBLESHOOTING"

PATCHES=(
	"${FILESDIR}"/${P}-comment.patch #537968
	"${FILESDIR}"/${P}-segfault.patch #565052
)

pkg_setup() {
	use mono && mono-env_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable udev) \
		$(use_enable gtk gdk-pixbuf) \
		$(use_enable python pygobject) \
		--without-hal \
		$(use_with ios libimobiledevice) \
		--with-udev-dir="$(get_udevdir)" \
		$(use_with python) \
		$(use_with mono)
}

src_install() {
	default
	rmdir "${ED}"/tmp
	prune_libtool_files --modules
}
