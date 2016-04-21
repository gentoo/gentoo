# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils udev

DESCRIPTION="Library for identifying Wacom tablets and their model-specific features"
HOMEPAGE="http://linuxwacom.sourceforge.net/"
SRC_URI="mirror://sourceforge/linuxwacom/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc static-libs"

RDEPEND="
	dev-libs/glib:2
	virtual/libgudev:=
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_prepare() {
	if ! use doc; then
		sed -e 's:^\(SUBDIRS = .* \)doc:\1:' -i Makefile.in || die
	fi
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	local udevdir="$(get_udevdir)"
	dodir "${udevdir}/rules.d"
	# generate-udev-rules must be run from inside tools directory
	pushd tools > /dev/null || die
	./generate-udev-rules > "${ED}/${udevdir}/rules.d/65-libwacom.rules" || die "generating udev rules failed"
	popd > /dev/null || die
	use doc && dohtml -r doc/html/*
	prune_libtool_files
}
