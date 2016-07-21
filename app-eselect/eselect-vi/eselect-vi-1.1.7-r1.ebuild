# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
inherit eutils

DESCRIPTION="Manages the /usr/bin/vi symlink"
HOMEPAGE="https://www.gentoo.org/"
SRC_URI="mirror://gentoo/vi.eselect-${PV}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=app-admin/eselect-1.0.6"

src_prepare() {
	epatch "${FILESDIR}/${P}-prefix.patch"
}

src_install() {
	insinto /usr/share/eselect/modules
	newins "${WORKDIR}/vi.eselect-${PV}" vi.eselect || die
}
