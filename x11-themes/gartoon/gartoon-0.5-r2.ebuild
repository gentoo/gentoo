# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Gartoon SVG icon theme"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc sparc ~x86"
SLOT="0"

RESTRICT="binchecks strip"

S=${WORKDIR}/${PN}

pkg_setup() {
	mydest="/usr/share/icons/${PN}"
}

src_prepare() {
	sed -i \
		-e "s:\(^pixmap_path\) \(\".*\"$\):\1 \"${mydest}/scalable/stock\":" \
		scalable/stock/iconrc || die
}

src_install() {
	insinto ${mydest}
	doins index.theme scalable/stock/iconrc

	dodoc AUTHORS README scalable/stock/changelog_mula.txt

	for dir in apps devices emblems filesystems mimetypes stock; do
		cd "${S}"/scalable/${dir}
		insinto ${mydest}/scalable/${dir}
		for svg in *svg; do
			doins ${svg}
		done
	done

	dosym gnome-lockscreen.svg ${mydest}/scalable/apps/xfce-system-lock.svg
	dosym control-center2.svg ${mydest}/scalable/apps/xfce-system-settings.svg
	dosym gnome-logout.svg ${mydest}/scalable/apps/xfce-system-exit.svg
	dosym mozilla-firefox.svg ${mydest}/scalable/apps/firefox-icon.svg
	dosym gnome-globe.svg ${mydest}/scalable/apps/firefox-icon-unbranded.svg
}
