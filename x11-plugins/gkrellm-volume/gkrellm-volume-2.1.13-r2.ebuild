# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
inherit gkrellm-plugin eutils

IUSE="alsa"
DESCRIPTION="A mixer control plugin for gkrellm"
HOMEPAGE="http://gkrellm.luon.net/volume.php"
SRC_URI="http://gkrellm.luon.net/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha amd64 ~ppc ~sparc x86"

DEPEND="alsa? ( media-libs/alsa-lib )"

S=${WORKDIR}/${PN}

PLUGIN_SO=volume.so

src_prepare() {
	epatch "${FILESDIR}/${P}-reenable.patch"
	epatch "${FILESDIR}/${P}-Respect-LDFLAGS.patch"
}

src_compile() {
	local myconf=""
	use alsa && myconf="${myconf} enable_alsa=1"
	make ${myconf} || die "make failed"
}
