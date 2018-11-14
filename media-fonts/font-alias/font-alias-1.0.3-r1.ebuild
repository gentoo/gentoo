# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit xorg-2

DESCRIPTION="X.Org font aliases"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}
	x11-apps/mkfontscale
	>=media-fonts/font-util-1.1.1-r1"

PATCHES=( "${FILESDIR}"/${P}-cvs-tags.patch ) #521786
