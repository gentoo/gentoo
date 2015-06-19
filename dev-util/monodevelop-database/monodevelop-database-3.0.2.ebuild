# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/monodevelop-database/monodevelop-database-3.0.2.ebuild,v 1.3 2012/12/07 04:55:30 phajdan.jr Exp $

EAPI="4"

inherit mono multilib versionator

DESCRIPTION="Database Browser Extension for MonoDevelop"
HOMEPAGE="http://www.monodevelop.com/"
SRC_URI="http://download.mono-project.com/sources/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="=dev-util/monodevelop-$(get_version_component_range 1-2)*"

DEPEND="${RDEPEND}
	x11-misc/shared-mime-info
	>=dev-util/intltool-0.35
	virtual/pkgconfig"

MAKEOPTS="${MAKEOPTS} -j1"

src_install() {
	default
	mono_multilib_comply
}
