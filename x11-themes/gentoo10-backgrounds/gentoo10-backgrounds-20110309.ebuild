# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Gentoo - 10 Years Compiling Background Artwork"
HOMEPAGE="https://www.gentoo.org/proj/en/pr/releases/10.0/graphics.xml"

SRC_URI="https://dev.gentoo.org/~flameeyes/${P}.tar.xz"

LICENSE="CC-BY-SA-3.0"
KEYWORDS="amd64 ~mips x86"
IUSE=""

RDEPEND=""
DEPEND="app-arch/xz-utils"

S="${WORKDIR}/${PN}"

SLOT="0"

src_prepare() {
	sed -i -e "s:/usr/:${EPREFIX}/usr/:" *.xml || die
}

src_compile() { :; }
src_test() { :; }

src_install() {

	insinto /usr/share/backgrounds/gentoo10
	doins -r {purple,blue,red}.xml netbook standard wide wider || die

	insinto /usr/share/gnome-background-properties
	doins desktop-*.xml || die

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
