# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit gkrellm-plugin

IUSE="lirc"

S=${WORKDIR}/${PN}
DESCRIPTION="A minimalistic GKrellM2 plugin to control radio tuners"
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"
HOMEPAGE="http://gkrellm.luon.net/gkrellm-radio.php"

DEPEND="lirc? ( app-misc/lirc )"

SLOT="2"
LICENSE="GPL-2"
KEYWORDS="ppc sparc x86"

PLUGIN_SO=radio.so

src_compile() {
	use lirc && myconf="${myconf} WITH_LIRC=1"
	emake ${myconf} || die
}
