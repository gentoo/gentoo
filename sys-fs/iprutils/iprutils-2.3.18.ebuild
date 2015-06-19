# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/iprutils/iprutils-2.3.18.ebuild,v 1.1 2014/12/25 13:02:26 pinkbyte Exp $

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="IBM's tools for support of the ipr SCSI controller"
SRC_URI="mirror://sourceforge/iprdd/${P}-src.tgz"
HOMEPAGE="http://sourceforge.net/projects/iprdd/"

SLOT="0"
LICENSE="IBM"
KEYWORDS="~ppc ~ppc64"

DEPEND=">=sys-libs/ncurses-5.4-r5
	>=sys-apps/pciutils-2.1.11-r1
	>=sys-fs/sysfsutils-1.3.0
	virtual/udev"

RDEPEND="${DEPEND}
	virtual/logger"

S="${WORKDIR}/${PN}"

src_prepare() {
	# Respect CFLAGS and LDFLAGS, bug #377757
	sed -i \
		-e '/^CFLAGS/s/= -g/+=/' \
		-e 's/$(CFLAGS)/\0 $(LDFLAGS)/g' \
		Makefile || die

	epatch_user
}

src_compile() {
	# Respect CC, bug #377757
	emake CC="$(tc-getCC)"
}

src_install () {
	emake INSTALL_MOD_PATH="${D}" install

	newinitd "${FILESDIR}"/iprinit iprinit
	newinitd "${FILESDIR}"/iprupdate iprupdate
	newinitd "${FILESDIR}"/iprdump iprdump
}

pkg_postinst() {
	einfo "This package also contains several init.d files. "
	einfo "You should add them to your default runlevels as follows:"
	einfo "rc-update add iprinit default"
	einfo "rc-update add iprdump default"
	einfo "rc-update add iprupdate default"
}
