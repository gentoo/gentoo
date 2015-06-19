# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellm-leds/gkrellm-leds-0.8.2.ebuild,v 1.1 2010/07/28 12:50:27 lack Exp $

EAPI="3"
inherit gkrellm-plugin

IUSE=""
MY_P=${P/rellm-/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="GKrellM2 plugin for monitoring keyboard LEDs"
SRC_URI="http://heim.ifi.uio.no/~oyvinha/e107_files/downloads/${MY_P}.tar.gz"
HOMEPAGE="http://heim.ifi.uio.no/~oyvinha/gkleds/"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~amd64"

DEPEND="x11-proto/inputproto"
RDEPEND="x11-libs/libXtst"

PLUGIN_SO="src/.libs/gkleds.so"
