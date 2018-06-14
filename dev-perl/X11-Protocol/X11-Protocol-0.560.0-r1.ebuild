# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SMCCAM
MODULE_VERSION=0.56
inherit perl-module

DESCRIPTION="Client-side interface to the X11 Protocol"

LICENSE="${LICENSE} MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="x11-libs/libXrender
	x11-libs/libXext"
DEPEND="${RDEPEND}"
