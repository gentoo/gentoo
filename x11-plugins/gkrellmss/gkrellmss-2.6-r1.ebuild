# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit gkrellm-plugin

DESCRIPTION="A plugin for GKrellM2 that has a VU meter and a sound chart"
HOMEPAGE="http://members.dslextreme.com/users/billw/gkrellmss/gkrellmss.html"
SRC_URI="http://web.wt.net/~billw/gkrellmss/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ~sparc x86"
IUSE="nls"

RDEPEND="=sci-libs/fftw-3*
	media-libs/alsa-lib"
DEPEND="${RDEPEND}"

PLUGIN_SO="src/gkrellmss.so"
PLUGIN_DOCS="Themes"

src_compile() {
	local myconf
	use nls && myconf+=" enable_nls=1"

	addpredict /dev/snd
	emake ${myconf}
}
