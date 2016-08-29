# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python2_7 )

inherit autotools gnome2 python-r1 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="MATE library to access weather information from online services"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

IUSE="python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND=">=dev-libs/glib-2.36:2[${PYTHON_USEDEP}]
	>=dev-libs/libxml2-2.6:2
	>=net-libs/libsoup-2.34:2.4
	>=sys-libs/timezone-data-2010k:0
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.24:2
	virtual/libintl:0

	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-2:2[${PYTHON_USEDEP}]
		>=dev-python/pygtk-2:2[${PYTHON_USEDEP}]
	)"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40.3:*
	>=mate-base/mate-common-1.10:0
	sys-devel/gettext:*
	virtual/pkgconfig:*"

my_command() {
	if use python ; then
		python_foreach_impl run_in_build_dir $@
	else
		$@
	fi
}

src_prepare() {
	# Fix undefined use of MKDIR_P in python/Makefile.am.
	epatch "${FILESDIR}"/${PN}-1.6.1-fix-mkdirp.patch
	eautoreconf

	use python && python_copy_sources
	my_command gnome2_src_prepare
}

src_configure() {
	my_command gnome2_src_configure \
		--enable-locations-compression \
		--disable-all-translations-in-one-xml \
		$(use_enable python)
}

src_compile() {
	my_command gnome2_src_compile
}

DOCS="AUTHORS ChangeLog NEWS"

src_install() {
	my_command gnome2_src_install
}
