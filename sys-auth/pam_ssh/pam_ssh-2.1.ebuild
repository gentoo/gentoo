# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit pam eutils flag-o-matic readme.gentoo

DESCRIPTION="Uses ssh-agent to provide single sign-on"
HOMEPAGE="http://pam-ssh.sourceforge.net/"
SRC_URI="mirror://sourceforge/pam-ssh/${P}.tar.xz"

LICENSE="BSD-2 BSD ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~ia64-linux ~x86-linux"
IUSE=""

# Only supports OpenSSH via `ssh-agent` #282993
DEPEND="virtual/pam
	dev-libs/openssl:0="
RDEPEND="${DEPEND}
	net-misc/openssh"

DOC_CONTENTS="
	You can enable pam_ssh for system authentication by enabling
	the pam_ssh USE flag on sys-auth/pambase.
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-dot-ssh-check.patch #503424#c5
}

src_configure() {
	# hide all the otherwise-exported symbols that may clash with
	# other software loading the PAM modules (see bug #274924 as an
	# example).
	append-ldflags -Wl,--version-script="${FILESDIR}"/pam_symbols.ver

	# Set the cache var so the configure script doesn't go probing hardcoded
	# file system paths and picking up the wrong thing.
	export ac_cv_openssldir=''

	# Avoid cross-compiling funkiness and requiring openssh at build time.
	export PATH_SSH_AGENT="${EPREFIX}/usr/bin/ssh-agent"

	econf \
		"--with-pam-dir=$(getpam_mod_dir)"
}

src_install() {
	default
	prune_libtool_files --modules
	readme.gentoo_create_doc
}

pkg_preinst() {
	if has_version "<${CATEGORY}/${PN}-2.0" ; then #554150
		ewarn "Upstream pam_ssh has changed where ssh keys live.  Only keys in your"
		ewarn "~/.ssh/login-keys.d/ will be accepted for authentication."
	fi
}
