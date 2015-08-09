# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="PAM base configuration files"
HOMEPAGE="http://www.gentoo.org/proj/en/base/pam/"
SRC_URI="http://dev.gentoo.org/~vapier/dist/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 -sparc-fbsd -x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="consolekit cracklib debug gnome-keyring minimal mktemp +nullok pam_krb5 pam_ssh passwdqc securetty selinux +sha512 systemd"

RESTRICT=binchecks

MIN_PAM_REQ=1.1.3

RDEPEND="
	|| (
		>=sys-libs/pam-${MIN_PAM_REQ}
		( sys-auth/openpam || ( sys-freebsd/freebsd-pam-modules sys-netbsd/netbsd-pam-modules ) )
	)
	consolekit? ( >=sys-auth/consolekit-0.4.6[pam] )
	cracklib? ( sys-libs/pam[cracklib] )
	gnome-keyring? ( >=gnome-base/gnome-keyring-2.32[pam] )
	mktemp? ( sys-auth/pam_mktemp )
	pam_krb5? (
		|| ( >=sys-libs/pam-${MIN_PAM_REQ} sys-auth/openpam )
		>=sys-auth/pam_krb5-4.3
	)
	pam_ssh? ( sys-auth/pam_ssh )
	passwdqc? ( >=sys-auth/pam_passwdqc-1.0.4 )
	selinux? ( sys-libs/pam[selinux] )
	sha512? ( >=sys-libs/pam-${MIN_PAM_REQ} )
	systemd? ( >=sys-apps/systemd-204[pam] )
	!<sys-apps/shadow-4.1.5-r1
	!<sys-freebsd/freebsd-pam-modules-6.2-r1
	!<sys-libs/pam-0.99.9.0-r1"
DEPEND="app-portage/portage-utils
	app-arch/xz-utils"

src_prepare() {
	epatch "${FILESDIR}"/${P}-selinux-note.patch #540096
}

src_compile() {
	local implementation linux_pam_version
	if has_version sys-libs/pam; then
		implementation=linux-pam
		local ver_str=$(qatom $(best_version sys-libs/pam) | cut -d ' ' -f 3)
		linux_pam_version=$(printf "0x%02x%02x%02x" ${ver_str//\./ })
	elif has_version sys-auth/openpam; then
		implementation=openpam
	else
		die "PAM implementation not identified"
	fi

	use_var() {
		local varname=$(echo "$1" | tr '[:lower:]' '[:upper:]')
		local usename=${2-$(echo "$1" | tr '[:upper:]' '[:lower:]')}
		local varvalue=$(usex ${usename})
		echo "${varname}=${varvalue}"
	}

	emake \
		GIT=true \
		$(use_var debug) \
		$(use_var cracklib) \
		$(use_var passwdqc) \
		$(use_var consolekit) \
		$(use_var systemd) \
		$(use_var GNOME_KEYRING gnome-keyring) \
		$(use_var selinux) \
		$(use_var nullok) \
		$(use_var mktemp) \
		$(use_var pam_ssh) \
		$(use_var securetty) \
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
	if use systemd && use consolekit; then
		ewarn "You are enabling 2 session trackers, ConsoleKit and systemd-logind"
		ewarn "at the same time. This is not recommended setup to have, please"
		ewarn "consider disabling either USE=\"consolekit\" or USE=\"systemd\."
	fi
}
