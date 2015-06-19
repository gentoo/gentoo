# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_ssh/pam_ssh-1.97-r1.ebuild,v 1.9 2012/11/01 13:50:43 ulm Exp $

EAPI=2

inherit pam autotools eutils

DESCRIPTION="Uses ssh-agent to provide single sign-on"
HOMEPAGE="http://pam-ssh.sourceforge.net/"
SRC_URI="mirror://sourceforge/pam-ssh/${P}.tar.bz2"

LICENSE="BSD-2 BSD ISC"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~ia64-linux ~x86-linux"
IUSE=""

# Doesn't work on OpenPAM.
DEPEND="sys-libs/pam
	sys-devel/libtool"

RDEPEND="sys-libs/pam
	virtual/ssh"

src_prepare() {
	epatch "${FILESDIR}/${P}-doublefree.patch"
	eautoreconf
}

src_configure() {
	econf \
		"--with-pam-dir=$(getpam_mod_dir)" \
		|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README TODO || die

	find "${D}" -name '*.la' -delete || die "Unable to remove libtool archives."
}

pkg_postinst() {
	elog "You can enable pam_ssh for system authentication by enabling"
	elog "the ssh USE flag on sys-auth/pambase."
}
