# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/monodevelop-debugger-gdb/monodevelop-debugger-gdb-3.0.2.ebuild,v 1.3 2012/12/07 04:56:23 phajdan.jr Exp $

EAPI="4"

inherit mono multilib versionator

DESCRIPTION="GDB Extension for MonoDevelop"
HOMEPAGE="http://www.monodevelop.com/"
SRC_URI="http://download.mono-project.com/sources/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND=">=dev-lang/mono-2.4
	=dev-util/monodevelop-$(get_version_component_range 1-2)*
	sys-devel/gdb"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

MAKEOPTS="${MAKEOPTS} -j1"

src_configure() {
	./configure --prefix=/usr
}

src_install() {
	default
	mono_multilib_comply
}
