# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG=no
GNOME2_LA_PUNT="yes"
PYTHON_REQ_USE="xml"
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils gnome2 python-single-r1 multilib bash-completion-r1

MY_PN=${PN/-core}
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="GNOME Desktop Applets: Core library for desktop applets"
SRC_URI="http://gdesklets.de/files/${MY_P}.tar.bz2"
HOMEPAGE="http://gdesklets.de"
LICENSE="GPL-2"

IUSE="dbus"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"

# is libgsf needed for runtime or just compiling?
# only need expat for python-2.4, I think
RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2:2
	>=gnome-base/librsvg-2.8
	>=gnome-base/libgtop-2.8.2
	>=dev-python/pygtk-2.10[${PYTHON_USEDEP}]
	>=dev-python/libbonobo-python-2.6[${PYTHON_USEDEP}]
	>=dev-python/gconf-python-2.6[${PYTHON_USEDEP}]
	>=dev-python/pygobject-2.6:2[${PYTHON_USEDEP}]
	>=dev-python/pyorbit-2.0.1[${PYTHON_USEDEP}]
	|| ( >=dev-python/gnome-vfs-python-2.6[${PYTHON_USEDEP}] >=dev-python/libgnome-python-2.6[${PYTHON_USEDEP}] )
	>=dev-libs/expat-1.95.8
	dbus? ( dev-python/dbus-python[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-.in-files.patch \
		"${FILESDIR}"/${P}-CFLAGS.patch

	python_fix_shebang .

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure --disable-static
}

src_install() {
	gnome2_src_install

	# Install bash completion script
	dobashcomp contrib/bash/gdesklets

	# Install the gdesklets-control-getid script
	insinto /usr/$(get_libdir)/gdesklets
	insopts -m0555
	doins "${FILESDIR}"/gdesklets-control-getid
}
