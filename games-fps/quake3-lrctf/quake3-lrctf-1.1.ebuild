# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MOD_DESC="offhand grapple all-weapons capture the flag mod"
MOD_NAME="Loki's Revenge CTF"
MOD_DIR="lrctf"

inherit games games-mods

HOMEPAGE="http://www.lrctf.com/"
SRC_URI="http://lrctf.com/release/LRCTF_Q3A_v${PV}_full.zip"

LICENSE="LRCTF"
KEYWORDS="amd64 ~ppc x86"
IUSE="dedicated opengl"
