# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gkrellm-plugin

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

PATCHES=( "${FILESDIR}/${P}-Respect-LDFLAGS.patch" )

src_compile() {
	addpredict /dev/snd
	emake enable_nls=$(usex nls 1 0)
}
