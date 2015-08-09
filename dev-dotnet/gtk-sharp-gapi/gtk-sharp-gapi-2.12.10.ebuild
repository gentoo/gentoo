# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
