# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="PAM base configuration files"
HOMEPAGE="http://www.gentoo.org/proj/en/base/pam/"
SRC_URI="http://dev.gentoo.org/~flameeyes/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="debug cracklib passwdqc consolekit gnome-keyring selinux mktemp pam_ssh +sha512 pam_krb5 minimal"
RESTRICT="binchecks"

RDEPEND="
	|| (
		>=sys-libs/pam-0.99.9.0-r1
		( sys-auth/openpam
		  || ( sys-freebsd/freebsd-pam-modules sys-netbsd/netbsd-pam-modules )
		)
	)
	cracklib? ( >=sys-libs/pam-0.99[cracklib] )
	consolekit? ( >=sys-auth/consolekit-0.3[pam] )
	gnome-keyring? ( >=gnome-base/gnome-keyring-2.20[pam] )
	selinux? ( >=sys-libs/pam-0.99[selinux] )
	passwdqc? ( >=sys-auth/pam_passwdqc-1.0.4 )
	mktemp? ( sys-auth/pam_mktemp )
	pam_ssh? ( sys-auth/pam_ssh )
	sha512? ( >=sys-libs/pam-1.0.1 )
	pam_krb5? (
		|| ( >=sys-libs/pam-1.1.0 sys-auth/openpam )
		>=sys-auth/pam_krb5-4.3
	)
	!<sys-freebsd/freebsd-pam-modules-6.2-r1
	!<sys-libs/pam-0.99.9.0-r1"
DEPEND="app-portage/portage-utils"

src_compile() {
	local implementation=
	local linux_pam_version=
	if has_version sys-libs/pam; then
		implementation="linux-pam"
		local ver_str=$(qatom `best_version sys-libs/pam` | cut -d ' ' -f 3)
		linux_pam_version=$(printf "0x%02x%02x%02x" ${ver_str//\./ })
	elif has_version sys-auth/openpam; then
		implementation="openpam"
	else
		die "PAM implementation not identified"
	fi

	use_var() {
		local varname=$(echo $1 | tr [a-z] [A-Z])
		local usename=${2-$(echo $1 | tr [A-Z] [a-z])}
		local varvalue=$(use $usename && echo yes || echo no)
		echo "${varname}=${varvalue}"
	}

	emake \
		GIT=true \
		$(use_var debug) \
		$(use_var cracklib) \
		$(use_var passwdqc) \
		$(use_var consolekit) \
		$(use_var GNOME_KEYRING gnome-keyring) \
		$(use_var selinux) \
		$(use_var mktemp) \
		$(use_var PAM_SSH pam_ssh) \
		$(use_var sha512) \
		$(use_var KRB5 pam_krb5) \
		$(use_var minimal) \
		IMPLEMENTATION=${implementation} \
		LINUX_PAM_VERSION=${linux_pam_version}
}

src_test() { :; }

src_install() {
	emake GIT=true DESTDIR="${ED}" install
}

pkg_postinst() {
	if use sha512; then
		elog "Starting from version 20080801, pambase optionally enables"
		elog "SHA512-hashed passwords. For this to work, you need sys-libs/pam-1.0.1"
		elog "built against sys-libs/glibc-2.7 or later."
		elog "If you don't have support for this, it will automatically fallback"
		elog "to MD5-hashed passwords, just like before."
		elog
		elog "Please note that the change only affects the newly-changed passwords"
		elog "and that SHA512-hashed passwords will not work on earlier versions"
		elog "of glibc or Linux-PAM."
	fi
}
