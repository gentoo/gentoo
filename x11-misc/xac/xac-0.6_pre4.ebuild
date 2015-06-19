# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xac/xac-0.6_pre4.ebuild,v 1.7 2013/05/11 07:44:07 patrick Exp $

inherit toolchain-funcs eutils multilib

DESCRIPTION="Xorgautoconfig (xac) generates configuration files for X.org"
HOMEPAGE="http://dev.gentoo.org/~josejx/xac.html"
LICENSE="GPL-2"
KEYWORDS="~amd64 ppc ppc64 ~x86"
SLOT="0"
IUSE="livecd"
DEPEND=">=dev-lang/python-2.3
	   sys-apps/pciutils"
RDEPEND=">=dev-lang/python-2.3
		x11-base/xorg-server"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

src_unpack() {
	unpack ${A}
	cd "${S}"

	### Replace /usr/lib/xac with libdir version
	sed -i "s:/usr/lib/xac:/usr/$(get_libdir)/xac:" xac

	### Fix the x86 bios call with newer glibc
	epatch "${FILESDIR}/x86-biosfix.patch"

	### Make setup.py executable
	chmod +x "${S}/src/setup.py"
}

src_compile() {
	### Compile the C bindings
	cd "${S}"/src
	./setup.py build || die "Failed to build the C modules"
}

src_install() {
	local xac_base="/usr/$(get_libdir)/xac"

	dosbin "${S}"/xac

	### Install the C mods
	cd "${S}"/src
	./setup.py install --root "${D}" || die "Failed to install the C modules"

	dodir "${xac_base}"
	insinto ${xac_base}
	doins "${S}"/py/*

	### Only install the init scripts if livecd is enabled
	if use livecd; then
		newinitd "${S}"/xac.init xac
		newconfd "${S}"/xac.conf xac
	fi
}
