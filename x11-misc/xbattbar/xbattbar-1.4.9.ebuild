# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic multilib toolchain-funcs

DESCRIPTION="Advanced Power Management battery status display for X"
HOMEPAGE="https://packages.qa.debian.org/x/xbattbar.html"
SRC_URI="mirror://debian/pool/main/x/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="
	dev-lang/perl
	x11-libs/libX11
"
RDEPEND="
	${DEPEND}
	!ppc? ( >=sys-power/acpi-1.5 )
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.4.5.patch
	"${FILESDIR}"/${PN}-1.4.8-const.patch
)

src_prepare() {
	default

	sed -i \
		-e "s:usr/lib:usr/$(get_libdir):" \
		xbattbar.c || die

	tc-export PKG_CONFIG
}

src_compile() {
	use kernel_linux && append-flags -Dlinux

	emake \
		CC=$(tc-getCC) \
		LIBDIR="$(get_libdir)" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" install
	dodoc README
}
