# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gkrellm-plugin

MY_P="${P/rellm-/}"

DESCRIPTION="GKrellM2 plugin for monitoring keyboard LEDs"
HOMEPAGE="http://heim.ifi.uio.no/~oyvinha/gkleds/"
SRC_URI="http://heim.ifi.uio.no/~oyvinha/e107_files/downloads/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="2"
KEYWORDS="alpha amd64 ~ppc ~sparc x86"
IUSE=""

COMMON_DEPEND="app-admin/gkrellm[X]"
DEPEND+="  ${COMMON_DEPEND} x11-proto/inputproto"
RDEPEND+=" ${COMMON_DEPEND} x11-libs/libXtst"

S="${WORKDIR}/${MY_P}"

PLUGIN_SO="src/.libs/gkleds.so"
