# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MATE_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit python-r1 mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="MATE library to access weather information from online services"
LICENSE="GPL-2"
SLOT="0"

IUSE="debug gtk3 python"

REQUIRED_USE="
	gtk3? ( !python )
	python? ( ${PYTHON_REQUIRED_USE} )
	"

RDEPEND=">=dev-libs/glib-2.36:2[${PYTHON_USEDEP}]
	>=dev-libs/libxml2-2.6:2
	>=net-libs/libsoup-2.34:2.4
	>=sys-libs/timezone-data-2010k:0
	x11-libs/gdk-pixbuf:2
	virtual/libintl:0
	!gtk3? ( >=x11-libs/gtk+-2.24:2 )
	gtk3? ( >=x11-libs/gtk+-3.0:3 )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-2:2[${PYTHON_USEDEP}]
		>=dev-python/pygtk-2:2[${PYTHON_USEDEP}]
	)"

DEPEND="${RDEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.50.1:*
	sys-devel/gettext:*
	>=sys-devel/libtool-2.2.6:2
	virtual/pkgconfig:*"

src_prepare() {
	mate_src_prepare
	use python && python_copy_sources
}

src_configure() {
	mate_py_cond_func_wrap mate_src_configure \
		--enable-locations-compression \
		--disable-all-translations-in-one-xml \
		--with-gtk=$(usex gtk3 3.0 2.0) \
		$(use_enable python)
}

src_compile() {
	mate_py_cond_func_wrap default
}

src_install() {
	mate_py_cond_func_wrap mate_src_install
}
