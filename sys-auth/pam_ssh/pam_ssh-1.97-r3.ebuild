# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit pam autotools eutils flag-o-matic

DESCRIPTION="Uses ssh-agent to provide single sign-on"
HOMEPAGE="http://pam-ssh.sourceforge.net/"
SRC_URI="mirror://sourceforge/pam-ssh/${P}.tar.bz2"

LICENSE="BSD-2 BSD ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~ia64-linux ~x86-linux"
IUSE=""

# Doesn't work on OpenPAM; looks for OpenSSH at build time (bug
# #282993) and won't work with other implementations either
RDEPEND="sys-libs/pam
	net-misc/openssh"

DEPEND="${RDEPEND}
	sys-devel/libtool"

src_prepare() {
	epatch "${FILESDIR}/${P}-doublefree.patch"
	epatch "${FILESDIR}/${P}-EOF.patch"
	eautoreconf
}

src_configure() {
	# hide all the otherwise-exported symbols that may clash with
	# other software loading the PAM modules (see bug #274924 as an
	# example).
	append-ldflags -Wl,--version-script="${FILESDIR}"/pam_symbols.ver

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
