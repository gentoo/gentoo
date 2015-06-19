# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3-lrctf/quake3-lrctf-1.1.ebuild,v 1.5 2011/12/14 17:23:13 vapier Exp $

EAPI=2

MOD_DESC="offhand grapple all-weapons capture the flag mod"
MOD_NAME="Loki's Revenge CTF"
MOD_DIR="lrctf"

inherit games games-mods

HOMEPAGE="http://www.lrctf.com/"
SRC_URI="http://lrctf.com/release/LRCTF_Q3A_v${PV}_full.zip"

LICENSE="LRCTF"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dedicated opengl"
