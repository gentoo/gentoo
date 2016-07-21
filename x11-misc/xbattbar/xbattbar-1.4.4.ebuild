# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
	epatch "${FILESDIR}"/${PN}-1.4.4.patch

	sed -i \
		-e "s:usr/lib:usr/$(get_libdir):" \
		xbattbar.c || die
}

src_compile() {
	use kernel_linux && append-flags -Dlinux
	emake CC=$(tc-getCC) LIBDIR="$(get_libdir)"
	python_fix_shebang ${PN}-check-sys
}

src_install() {
	emake install DESTDIR="${D}" LIBDIR="$(get_libdir)"
	dodoc README
}
