# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libwacom/libwacom-0.11.ebuild,v 1.9 2015/04/14 10:55:04 ago Exp $

EAPI=5
inherit eutils udev

DESCRIPTION="Library for identifying Wacom tablets and their model-specific features"
HOMEPAGE="http://linuxwacom.sourceforge.net/"
SRC_URI="mirror://sourceforge/linuxwacom/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86"
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
	pushd tools > /dev/null
	./generate-udev-rules > "${ED}/${udevdir}/rules.d/65-libwacom.rules" ||
		die "generating udev rules failed"
	popd > /dev/null
	use doc && dohtml -r doc/html/*
	prune_libtool_files
}
