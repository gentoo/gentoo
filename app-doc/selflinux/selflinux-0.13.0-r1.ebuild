# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="SelfLinux-${PV}"

DESCRIPTION="A german-language hypertext tutorial about Linux"
HOMEPAGE="https://www.selflinux.org/"
SRC_URI="https://www.selflinux.org/download/${MY_P}/${MY_P}-html.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="FDL-1.1+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

HTML_DOCS=( "." )

BDEPEND="media-gfx/pngcrush"

src_prepare() {
	default

	# Fix all png files, as they report "broken IDAT window length"
	for png_file in bilder/mwm_mwm_mwm*; do
		pngcrush -fix -force -ow "${png_file}" || die
	done
}
