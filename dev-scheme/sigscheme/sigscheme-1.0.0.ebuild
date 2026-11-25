# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit flag-o-matic meson

DESCRIPTION="SigScheme is an R5RS Scheme interpreter for embedded use"
HOMEPAGE="https://github.com/uim/sigscheme"
SRC_URI="https://github.com/uim/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	use elibc_musl && append-cflags -D_GNU_SOURCE # bug 906864

	sed -i "/^docdir/s/$/ + '-${PVR}'/" meson.build
}

src_configure() {
	local emesonargs=(
		-Dreal=true
		-Dsrfi180=true
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	dodir /usr/share/doc/${PF}/html
	mv "${ED}"/usr/share/doc/${PF}/*.html "${ED}"/usr/share/doc/${PF}/html
}
