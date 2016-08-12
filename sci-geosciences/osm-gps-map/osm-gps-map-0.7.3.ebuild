# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=1

inherit eutils autotools gnome2 distutils-r1

DESCRIPTION="A gtk+ viewer for OpenStreetMap files"
HOMEPAGE="https://nzjrs.github.com/osm-gps-map/"
SRC_URI="http://www.johnstowers.co.nz/files/${PN}/${P}.tar.gz
python? ( http://www.johnstowers.co.nz/files/${PN}/python-osmgpsmap-${PV}.tar.gz )"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="+introspection python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/glib-2.16.0:2
	>=net-libs/libsoup-2.4.0:2.4
	>=x11-libs/cairo-1.6.0
	>=x11-libs/gtk+-2.14.0:2[introspection?]
	x11-libs/gdk-pixbuf:2[introspection?]
	introspection? ( dev-libs/gobject-introspection )
	python? ( ${PYTHON_DEPS}
		dev-python/pygtk:2[${PYTHON_USEDEP}]
		dev-python/pygobject:2[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	gnome-base/gnome-common:3
	virtual/pkgconfig"

PYTHON_S="${WORKDIR}/python-osmgpsmap-${PV}"

src_configure() {
	# Configure script does not accept quoted EPREFIX...
	gnome2_src_configure \
		$(use_enable introspection) \
		--docdir=/usr/share/doc/${PF} \
		--enable-fast-install \
		--disable-static
}

src_prepare() {
	epatch "${FILESDIR}/${P}-fix-docs-location.patch" \
	       "${FILESDIR}/${P}-fix-introspection.patch"
	eautoreconf

	gnome2_src_prepare

	if use python ; then
		cd "${PYTHON_S}" || die
		epatch "${FILESDIR}/${P}-fix-python-setup.py.patch"
	fi
}

src_compile() {
	gnome2_src_compile

	if use python ; then
		cd "${PYTHON_S}" || die
		CFLAGS="${CFLAGS} -I\"${S}\"/src" LDFLAGS="${LDFLAGS} -L\"${S}\"/src/.libs" distutils-r1_src_compile
	fi
}

src_install() {
	gnome2_src_install

	if use python ; then
		cd "${PYTHON_S}" || die
		distutils-r1_src_install
	fi
}
