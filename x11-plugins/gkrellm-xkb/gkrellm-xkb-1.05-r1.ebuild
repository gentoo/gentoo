# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gkrellm-plugin

DESCRIPTION="XKB keyboard switcher for gkrellm2"
HOMEPAGE="http://tripie.sweb.cz/gkrellm/xkb/"
SRC_URI="http://tripie.sweb.cz/gkrellm/xkb/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="app-admin/gkrellm[X]"
RDEPEND+=" ${COMMON_DEPEND}"
DEPEND+=" ${COMMON_DEPEND}"

PLUGIN_SO=xkb.so

PATCHES=( "${FILESDIR}/${PN}-makefile.patch" )

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}
