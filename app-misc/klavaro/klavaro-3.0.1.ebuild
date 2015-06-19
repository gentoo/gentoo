# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/klavaro/klavaro-3.0.1.ebuild,v 1.3 2015/06/09 07:14:31 ago Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=yes

inherit autotools-utils versionator

MY_P="${PN}-$(delete_version_separator 2)"

DESCRIPTION="Another free touch typing tutor program"
HOMEPAGE="http://klavaro.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+static-libs"

RDEPEND="
	net-misc/curl
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/pango
"
# gtk+3 version needed
#	x11-libs/gtkdatabox

DEPEND="${RDEPEND}
	dev-util/intltool
	>=sys-devel/gettext-0.18.3
	dev-util/gtk-builder-convert
	"

PATCHES=(
	"${FILESDIR}"/${P}-out-of-source.patch
	"${FILESDIR}"/${P}-static.patch
	"${FILESDIR}"/${P}-datadir.patch
	"${FILESDIR}"/${PN}-desktop-keywords.patch
	)

S="${WORKDIR}"/${MY_P}
