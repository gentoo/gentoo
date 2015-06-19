# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/gkrellmss/gkrellmss-2.6-r2.ebuild,v 1.3 2014/04/07 19:58:47 ssuominen Exp $

EAPI=5
inherit eutils gkrellm-plugin

DESCRIPTION="A plugin for GKrellM2 that has a VU meter and a sound chart"
HOMEPAGE="http://members.dslextreme.com/users/billw/gkrellmss/gkrellmss.html"
SRC_URI="http://web.wt.net/~billw/gkrellmss/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="nls"

RDEPEND="=sci-libs/fftw-3*
	media-libs/alsa-lib"
DEPEND="${RDEPEND}"

PLUGIN_SO="src/gkrellmss.so"
PLUGIN_DOCS="Themes"

src_prepare() {
	epatch "${FILESDIR}"/${P}-Respect-LDFLAGS.patch
}

src_compile() {
	local myconf
	use nls && myconf+=" enable_nls=1"

	addpredict /dev/snd
	emake ${myconf}
}
