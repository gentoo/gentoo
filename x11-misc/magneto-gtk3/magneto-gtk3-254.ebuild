# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

DESCRIPTION="Entropy Package Manager notification applet GTK3 frontend"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

SRC_URI="mirror://sabayon/sys-apps/entropy-${PV}.tar.bz2"
S="${WORKDIR}/entropy-${PV}/magneto"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	~app-misc/magneto-loader-${PV}[${PYTHON_USEDEP}]
	dev-libs/gobject-introspection
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	emake DESTDIR="${D}" LIBDIR="usr/lib" magneto-gtk3-install || die "make install failed"
	python_optimize "${D}/usr/lib/entropy/magneto/magneto/gtk3"
}
