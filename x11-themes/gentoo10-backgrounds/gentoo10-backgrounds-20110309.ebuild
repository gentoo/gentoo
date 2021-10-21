# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Gentoo - 10 Years Compiling Background Artwork"
HOMEPAGE="https://www.gentoo.org/inside-gentoo/artwork/"
SRC_URI="https://dev.gentoo.org/~flameeyes/${P}.tar.xz"
S="${WORKDIR}/${PN}"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 ~mips x86"

BDEPEND="app-arch/xz-utils"

src_prepare() {
	default
	sed -i -e "s:/usr/:${EPREFIX}/usr/:" *.xml || die
}

src_install() {

	insinto /usr/share/backgrounds/gentoo10
	doins -r {purple,blue,red}.xml netbook standard wide wider

	insinto /usr/share/gnome-background-properties
	doins desktop-*.xml

	# KDE wallpapers
	for color in purple blue red; do
		insinto /usr/share/wallpapers/Gentoo10_${color}
		newins gentoo10-${color}-metadata.desktop metadata.desktop

		dodir /usr/share/wallpapers/Gentoo10_${color}/contents/images
		for file in */*/${color}.jpg; do
			dosym ../../../../backgrounds/gentoo10/"${file}" /usr/share/wallpapers/Gentoo10_${color}/contents/images/"$(basename "$(dirname "${file}")")".jpg
		done
	done
}
