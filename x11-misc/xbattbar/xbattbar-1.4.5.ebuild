# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xbattbar/xbattbar-1.4.5.ebuild,v 1.2 2015/04/08 17:27:16 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils flag-o-matic multilib python-single-r1 toolchain-funcs

DESCRIPTION="Advanced Power Management battery status display for X"
HOMEPAGE="http://packages.qa.debian.org/x/xbattbar.html"
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
	${PYTHON_DEPS}
	!ppc? ( >=sys-power/acpi-1.5 )
" # ppc has APM

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.4.5.patch

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
	python_fix_shebang ${PN}-check-sys
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="$(get_libdir)" install
	dodoc README
}
