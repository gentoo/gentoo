# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=ubuntu-themes

DESCRIPTION="GTK2/GTK3 Ambiance and Radiance themes from Ubuntu"
HOMEPAGE="https://packages.ubuntu.com/zesty/light-themes"
SRC_URI="
	mirror://ubuntu/pool/main/${MY_PN:0:1}/${MY_PN}/${MY_PN}_${PV}.orig.tar.gz
	https://dev.gentoo.org/~pacho/${PN}/Gentoo-Buttons-r1.tar.xz
"

LICENSE="CC-BY-SA-3.0 CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

BDEPEND="app-arch/xz-utils"
RDEPEND="
	x11-themes/gtk-engines-murrine
"

S="${WORKDIR}"/${MY_PN}-${PV}

src_prepare() {
	cp -RL Ambiance/ Ambiance-Gentoo || die
	cp -RL Radiance/ Radiance-Gentoo || die
	sed -i -e 's/Ambiance/Ambiance-Gentoo/g' Ambiance-Gentoo/index.theme \
		Ambiance-Gentoo/metacity-1/metacity-theme-1.xml || die
	sed -i -e 's/Radiance/Radiance-Gentoo/g' Radiance-Gentoo/index.theme \
		Radiance-Gentoo/metacity-1/metacity-theme-1.xml || die
	sed -i -e 's/nselected_bg_color:#f07746/nselected_bg_color:#755fbb/g' \
		Ambiance-Gentoo/gtk-2.0/gtkrc Ambiance-Gentoo/gtk-3.*/settings.ini \
		Radiance-Gentoo/gtk-2.0/gtkrc Radiance-Gentoo/gtk-3.*/settings.ini || die
	sed -i -e 's/selected_bg_color #f07746/selected_bg_color #755fbb/g' \
		Ambiance-Gentoo/gtk-3.*/gtk-main.css \
		Radiance-Gentoo/gtk-3.*/gtk-main.css || die

	cp -f "${WORKDIR}"/Gentoo-Buttons/*.png "${S}"/Ambiance-Gentoo/metacity-1/. || die
	cp -f "${WORKDIR}"/Gentoo-Buttons/*.png "${S}"/Radiance-Gentoo/metacity-1/. || die
	cp -f "${WORKDIR}"/Gentoo-Buttons/assets/*.png "${S}"/Ambiance-Gentoo/gtk-3.0/assets/. || die
	cp -f "${WORKDIR}"/Gentoo-Buttons/assets/*.png "${S}"/Ambiance-Gentoo/gtk-3.20/assets/. || die
	cp -f "${WORKDIR}"/Gentoo-Buttons/assets/*.png "${S}"/Radiance-Gentoo/gtk-3.0/assets/. || die
	cp -f "${WORKDIR}"/Gentoo-Buttons/assets/*.png "${S}"/Radiance-Gentoo/gtk-3.20/assets/. || die

	eapply_user
}

src_compile() {
	:
}

src_install() {
	insinto /usr/share/themes
	doins -r Radiance* Ambiance*
}
