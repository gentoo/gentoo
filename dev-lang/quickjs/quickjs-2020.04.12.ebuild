# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Small and embeddable JavaScript (ES2020) engine"
HOMEPAGE="https://bellard.org/quickjs/"
SRC_URI="https://bellard.org/quickjs/${P//./-}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_unpack() {
	default
	mv "${P//./-}" "${P}"
}

src_prepare() {
	default
	sed -i "s,/usr/local,${EPREFIX}/usr,;s,FLAGS=,FLAGS+=," Makefile
	sed -Ei "/( |HOST_|QJSC_)CC=/d;s/(HOST|QJSC)_CC/CC/g" Makefile
}

src_install() {
	tc-export CC
	emake DESTDIR="${D}" install
	einstalldocs
}
