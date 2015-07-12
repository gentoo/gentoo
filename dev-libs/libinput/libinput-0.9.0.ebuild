# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libinput/libinput-0.9.0.ebuild,v 1.12 2015/07/12 09:23:56 jer Exp $

EAPI="5"

inherit eutils

DESCRIPTION="Library to handle input devices in Wayland"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/libinput/"
SRC_URI="http://www.freedesktop.org/software/${PN}/${P}.tar.xz"

# License appears to be a variant of libtiff
LICENSE="libtiff"
SLOT="0/7"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86"
IUSE=""
RESTRICT="test"

RDEPEND="
	>=dev-libs/libevdev-0.4
	>=sys-libs/mtdev-1.1
	virtual/libudev
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	# Doc handling in kinda strange but everything
	# is available in the tarball already.
	sed -e 's/^\(SUBDIRS =.*\)doc\(.*\)$/\1\2/' \
		-i Makefile.am Makefile.in || die
}

src_configure() {
	# gui can be built but will not be installed
	# building documentation silently fails with graphviz syntax errors
	econf \
		--disable-documentation \
		--disable-event-gui \
		--disable-tests
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc -r doc/html
	prune_libtool_files
}
