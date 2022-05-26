# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Firmware tool for Broadcom 43xx-based wireless devices using mac80211"
HOMEPAGE="https://bues.ch/b43/fwcutter/"
SRC_URI="https://bues.ch/b43/fwcutter/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ppc ppc64 x86"

src_compile() {
	emake CC="$(tc-getCC)" V=1
}

src_install() {
	# Install fwcutter
	dobin ${PN}
	doman ${PN}.1
	dodoc README
}

pkg_postinst() {
	einfo "Firmware may be downloaded from http://linuxwireless.org."
	einfo "This version of fwcutter works with all b43 driver versions."
}
