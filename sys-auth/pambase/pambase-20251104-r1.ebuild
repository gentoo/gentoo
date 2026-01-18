# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit edo pam python-any-r1 readme.gentoo-r1

DESCRIPTION="PAM base configuration files"
HOMEPAGE="https://github.com/gentoo/pambase"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="
		https://anongit.gentoo.org/git/proj/pambase.git
		https://github.com/gentoo/pambase.git
	"
else
	SRC_URI="https://gitweb.gentoo.org/proj/pambase.git/snapshot/${P}.tar.bz2"

	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="caps debug elogind gnome-keyring homed minimal mktemp +nullok pam_krb5 pam_ssh +passwdqc pwhistory pwquality securetty selinux sha512 sssd systemd +yescrypt"

RESTRICT="binchecks"

REQUIRED_USE="
	?? ( elogind systemd )
	?? ( passwdqc pwquality )
	?? ( sha512 yescrypt )
	pwhistory? ( || ( passwdqc pwquality ) )
	homed? ( !pam_krb5 )
	pam_krb5? ( !homed )
"

MIN_PAM_REQ=1.4.0

RDEPEND="
	>=sys-libs/pam-${MIN_PAM_REQ}
	elogind? ( sys-auth/elogind[pam] )
	gnome-keyring? ( gnome-base/gnome-keyring[pam] )
	mktemp? ( sys-auth/pam_mktemp )
	pam_krb5? (
		>=sys-libs/pam-${MIN_PAM_REQ}
		sys-auth/pam_krb5
	)
	caps? ( sys-libs/libcap[pam] )
	pam_ssh? ( sys-auth/pam_ssh )
	passwdqc? ( >=sys-auth/passwdqc-1.4.0-r1 )
	pwquality? ( dev-libs/libpwquality[pam] )
	selinux? ( sys-libs/pam[selinux] )
	sha512? ( >=sys-libs/pam-${MIN_PAM_REQ} )
	homed? ( sys-apps/systemd[homed] )
	systemd? ( sys-apps/systemd[pam] )
	yescrypt? ( sys-libs/libxcrypt[system] )
	sssd? ( sys-auth/sssd )
"
BDEPEND="
	$(python_gen_any_dep '
		dev-python/jinja2[${PYTHON_USEDEP}]
	')
"

python_check_deps() {
	python_has_version "dev-python/jinja2[${PYTHON_USEDEP}]"
}

src_configure() {
	local crypt=md5
	# TODO: sha256, blowfish, gost_yescrypt
	use sha512 && crypt=sha512
	use yescrypt && crypt=yescrypt

	local pamargs=(
		# Not all 'upstream' options are (currently) wired up
		# in the ebuild.
		#
		# TODO: pam_shells
		$(usev caps '--caps')
		$(usev debug '--debug')
		$(usev elogind '--elogind')
		$(usev gnome-keyring '--gnome-keyring')
		$(usev homed '--homed')
		$(usev minimal '--minimal')
		$(usev mktemp '--mktemp')
		$(usev nullok '--nullok')
		$(usev pam_krb5 '--krb5')
		$(usev pam_ssh '--pam-ssh')
		$(usev passwdqc '--passwdqc')
		$(usev pwhistory '--pwhistory')
		$(usev pwquality '--pwquality')
		$(usev securetty '--securetty')
		$(usev selinux '--selinux')
		$(usex systemd '--systemd' '--openrc')
		$(usev sssd '--sssd')

		--encrypt=${crypt}
	)

	edo ${EPYTHON} ./${PN}.py "${pamargs[@]}"
}

src_test() { :; }

src_install() {
	local DOC_CONTENTS

	if use passwdqc; then
		DOC_CONTENTS="To amend the existing password policy please see the man 5 passwdqc.conf
				page and then edit the /etc/security/passwdqc.conf file"
	fi

	if use pwquality; then
		DOC_CONTENTS="To amend the existing password policy please see the man 5 pwquality.conf
				page and then edit the /etc/security/pwquality.conf file"
	fi

	{ use passwdqc || use pwquality; } && readme.gentoo_create_doc

	dopamd -r stack/.
}

pkg_postinst() {
	{ use passwdqc || use pwquality; } && readme.gentoo_print_elog
}
