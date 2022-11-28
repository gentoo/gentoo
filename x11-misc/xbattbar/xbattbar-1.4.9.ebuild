# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Advanced Power Management battery status display for X"
HOMEPAGE="https://packages.qa.debian.org/x/xbattbar.html"
SRC_URI="mirror://debian/pool/main/x/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="
	dev-lang/perl
	x11-libs/libX11"
RDEPEND="
	${DEPEND}
	!ppc? ( >=sys-power/acpi-1.5 )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.5-Makefile.patch
	"${FILESDIR}"/${PN}-1.4.8-const.patch
	"${FILESDIR}"/${PN}-1.4.9-implicit-int.patch
)

src_prepare() {
	default

	sed -i "s|/usr/lib|${EPREFIX}/usr/$(get_libdir)|" xbattbar.c || die
}

src_configure() {
	tc-export CC PKG_CONFIG
	use kernel_linux && append-cppflags -Dlinux
}

src_install() {
	emake DESTDIR="${ED}" LIBDIR="$(get_libdir)" install
	einstalldocs
}
