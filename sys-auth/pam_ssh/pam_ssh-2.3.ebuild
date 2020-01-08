# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pam flag-o-matic readme.gentoo-r1

DESCRIPTION="Uses ssh-agent to provide single sign-on"
HOMEPAGE="http://pam-ssh.sourceforge.net/"
SRC_URI="mirror://sourceforge/pam-ssh/${P}.tar.xz"

LICENSE="BSD-2 BSD ISC"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

# Only supports OpenSSH via `ssh-agent` #282993
DEPEND="sys-libs/pam
	dev-libs/openssl:0="
RDEPEND="${DEPEND}
	net-misc/openssh"

PATCHES=(
	# 503424#c5
	"${FILESDIR}"/${PN}-2.1-dot-ssh-check.patch
)

src_configure() {
	# hide all the otherwise-exported symbols that may clash with
	# other software loading the PAM modules (see bug #274924 as an
	# example).
	append-ldflags -Wl,--version-script="${FILESDIR}"/pam_symbols.ver

	# Set the cache var so the configure script doesn't go probing hardcoded
	# file system paths and picking up the wrong thing.
	export ac_cv_openssldir=''

	# not needed now
	export ac_cv_exeext=no

	# Avoid cross-compiling funkiness and requiring openssh at build time.
	export PATH_SSH_AGENT="${EPREFIX}/usr/bin/ssh-agent"

	econf \
		"--with-pam-dir=$(getpam_mod_dir)"
}

src_install() {
	default

	# pam_ssh only builds plugins
	find "${D}" -name '*.la' -delete || die

	local DOC_CONTENTS="
		You can enable pam_ssh for system authentication by enabling
		the pam_ssh USE flag on sys-auth/pambase.
	"
	readme.gentoo_create_doc
}

pkg_preinst() {
	local i
	for i in "${REPLACING_VERSIONS}"; do
		if [[ ${i} == 1.* ]]; then #554150
			ewarn "Upstream pam_ssh has changed where ssh keys live. Only keys in your"
			ewarn "~/.ssh/login-keys.d/ will be accepted for authentication."
			return
		fi
	done
}

pkg_postinst() {
	readme.gentoo_print_elog
}
