# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_ssh/pam_ssh-1.98.ebuild,v 1.9 2013/12/23 09:14:48 vapier Exp $

EAPI=5
inherit pam eutils flag-o-matic readme.gentoo

DESCRIPTION="Uses ssh-agent to provide single sign-on"
HOMEPAGE="http://pam-ssh.sourceforge.net/"
SRC_URI="mirror://sourceforge/pam-ssh/${P}.tar.bz2"

LICENSE="BSD-2 BSD ISC"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~ia64-linux ~x86-linux"
IUSE=""

# Doesn't work on OpenPAM; looks for OpenSSH at build time (bug
# #282993) and won't work with other implementations either
RDEPEND="
	sys-libs/pam
	net-misc/openssh
"
DEPEND="${RDEPEND}
	sys-devel/libtool
"

DOC_CONTENTS="
	You can enable pam_ssh for system authentication by enabling
	the pam_ssh USE flag on sys-auth/pambase.
"

src_configure() {
	# hide all the otherwise-exported symbols that may clash with
	# other software loading the PAM modules (see bug #274924 as an
	# example).
	append-ldflags -Wl,--version-script="${FILESDIR}"/pam_symbols.ver

	econf \
		"--with-pam-dir=$(getpam_mod_dir)"
}

src_install() {
	default
	prune_libtool_files --modules
	readme.gentoo_create_doc
}
