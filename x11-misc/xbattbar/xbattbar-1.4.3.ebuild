# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xbattbar/xbattbar-1.4.3.ebuild,v 1.3 2012/02/16 19:36:21 phajdan.jr Exp $

EAPI=2
inherit eutils flag-o-matic multilib toolchain-funcs

DESCRIPTION="Advanced Power Management battery status display for X"
HOMEPAGE="http://packages.qa.debian.org/x/xbattbar.html"
SRC_URI="mirror://debian/pool/main/x/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND="dev-lang/perl
	x11-libs/libX11"
RDEPEND="${DEPEND}
	!ppc? ( >=sys-power/acpi-1.5 )" # ppc has APM

# XXX: Avoiding imake in purpose here.

src_prepare() {
	epatch "${FILESDIR}"/${P}.patch

	sed -i \
		-e "s:usr/lib:usr/$(get_libdir):" \
		xbattbar.c || die
}

src_compile() {
	[[ $(tc-arch) == amd64 ]] && export LIB_SUFFIX=64
	tc-export CC
	use kernel_linux && append-flags -Dlinux
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README
}
