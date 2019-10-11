# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="PAM base configuration files"
HOMEPAGE="https://github.com/gentoo/pambase"
SRC_URI="https://dev.gentoo.org/~vapier/dist/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="consolekit +cracklib debug elogind gnome-keyring minimal mktemp +nullok pam_krb5 pam_ssh passwdqc securetty selinux +sha512 systemd"

RESTRICT="binchecks"

MIN_PAM_REQ=1.1.3

RDEPEND="
	|| (
		>=sys-libs/pam-${MIN_PAM_REQ}
		( sys-auth/openpam sys-freebsd/freebsd-pam-modules )
	)
	consolekit? ( sys-auth/consolekit[pam] )
	cracklib? ( sys-libs/pam[cracklib] )
	elogind? ( sys-auth/elogind[pam] )
	gnome-keyring? ( gnome-base/gnome-keyring[pam] )
	mktemp? ( sys-auth/pam_mktemp )
	pam_krb5? (
		|| ( >=sys-libs/pam-${MIN_PAM_REQ} sys-auth/openpam )
		sys-auth/pam_krb5
	)
	pam_ssh? ( sys-auth/pam_ssh )
	passwdqc? ( sys-auth/pam_passwdqc )
	selinux? ( sys-libs/pam[selinux] )
	sha512? ( >=sys-libs/pam-${MIN_PAM_REQ} )
	systemd? ( sys-apps/systemd[pam] )
"
DEPEND="
	app-arch/xz-utils
	app-portage/portage-utils
"

PATCHES=(
	"${FILESDIR}"/${P}-selinux-note.patch #540096
	"${FILESDIR}"/${P}-elogind.patch #599498
)

pkg_setup() {
	local stcnt=0

	use consolekit && stcnt=$((stcnt+1))
	use elogind && stcnt=$((stcnt+1))
	use systemd && stcnt=$((stcnt+1))

	if [[ ${stcnt} -gt 1 ]] ; then
		ewarn "You are enabling ${stcnt} session trackers at the same time."
		ewarn "This is not a recommended setup to have. Please consider enabling"
		ewarn "only one of USE=\"consolekit\", USE=\"elogind\" or USE=\"systemd\"."
	fi
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
		$(use_var elogind) \
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
