# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-dotnet/gtk-sharp-gapi/gtk-sharp-gapi-2.12.10.ebuild,v 1.4 2010/09/12 04:29:15 josejx Exp $

EAPI=2

GTK_SHARP_MODULE_DIR=parser

inherit gtk-sharp-module

SLOT="2"
KEYWORDS="amd64 ppc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux"
IUSE=""

RESTRICT="test"

src_compile() {
	GTK_SHARP_MODULE_DIR="parser" gtk-sharp-module_src_compile
	GTK_SHARP_MODULE_DIR="generator" gtk-sharp-module_src_compile
}

src_install() {
	local exec
	mv_command="cp -pPR"
	GTK_SHARP_MODULE_DIR="parser" gtk-sharp-module_src_install
	GTK_SHARP_MODULE_DIR="generator" gtk-sharp-module_src_install
}
