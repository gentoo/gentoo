# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="DVD-themes (background and menu) for vdr-burn"
HOMEPAGE="http://www.vdr-wiki.de/wiki/index.php/Vorlagen_(burn-plugin)"
SRC_URI="http://vdr.websitec.de/download/${PN}/${P}.tar.gz"

LICENSE="FDL-1.2" # only
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-plugins/vdr-burn-0.0.9-r2"

S="${WORKDIR}/templates"

src_install() {

	insinto /usr/share/vdr/burn
	insopts -m0644 -ovdr -gvdr
	doins "${S}"/*.png
}
