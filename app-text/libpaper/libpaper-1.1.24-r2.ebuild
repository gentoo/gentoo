# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/libpaper/libpaper-1.1.24-r2.ebuild,v 1.12 2014/06/09 23:31:01 vapier Exp $

EAPI=4

inherit eutils autotools multilib-minimal

MY_PV=${PV/_p/+nmu}
DESCRIPTION="Library for handling paper characteristics"
HOMEPAGE="http://packages.debian.org/unstable/source/libpaper"
SRC_URI="mirror://debian/pool/main/libp/libpaper/${PN}_${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""
RDEPEND="abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20130224-r10
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
DEPEND=""

S="${WORKDIR}/${PN}-${MY_PV}"

DOCS=( README ChangeLog debian/changelog )

src_prepare() {
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}"	econf \
		--disable-static
}

multilib_src_install_all() {
	prune_libtool_files --all
	einstalldocs

	dodir /etc
	(paperconf 2>/dev/null || echo a4) > "${ED}"/etc/papersize \
		|| die "papersize config failed"

	if ! has_version app-text/libpaper ; then
		echo
		elog "run e.g. \"paperconfig -p letter\" as root to use letter-pagesizes"
		echo
	fi
}
