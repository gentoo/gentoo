# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/glib-sharp/glib-sharp-2.12.10.ebuild,v 1.5 2012/02/16 12:06:28 pacho Exp $

EAPI="4"

inherit gtk-sharp-module

SLOT="2"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
IUSE=""

RESTRICT="test"

PATCHES=( "${FILESDIR}/${PN}-2.12.10-glib-header.patch" )
