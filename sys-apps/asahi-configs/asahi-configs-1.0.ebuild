# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="Asahi Linux configurations"
HOMEPAGE="https://asahilinux.org/"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~arm64"

src_unpack() {
	mkdir "${S}" || die
	cp "${FILESDIR}"/* "${S}/" || die
}

src_install() {
	insinto /etc/xdg/
	newins "${FILESDIR}/kcminput" kcminputrc
	newins "${FILESDIR}/baloo" baloofilerc

	insinto /etc/X11/xorg.conf.d/
	newins "${FILESDIR}/xorg-modeset" 30-modesetting.conf
	newins "${FILESDIR}/xorg-naturalscroll" 20-natural-scrolling.conf

	exeinto /etc/profile.d/
	newexe "${FILESDIR}/envvars" asahi.sh
}
