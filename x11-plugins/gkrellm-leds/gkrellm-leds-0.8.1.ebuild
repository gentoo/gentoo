# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit gkrellm-plugin

IUSE=""
MY_P=${P/rellm-/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="GKrellM2 plugin for monitoring keyboard LEDs"
SRC_URI="http://heim.ifi.uio.no/~oyvinha/e107_files/downloads/${MY_P}.tar.gz"
HOMEPAGE="http://heim.ifi.uio.no/~oyvinha/gkleds/"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc alpha amd64"
RESTRICT="test"

DEPEND="x11-proto/inputproto"
RDEPEND="x11-libs/libXtst"

PLUGIN_SO=gkleds.so

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Includes for gcc-4
	sed -i -e '/^#include <stdio.h>/a#include <string.h>' src/gkleds_com.h || die "Patch failed"
}
