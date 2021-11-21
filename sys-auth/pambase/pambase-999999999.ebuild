# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit pam python-any-r1 readme.gentoo-r1

DESCRIPTION="PAM base configuration files"
HOMEPAGE="https://github.com/gentoo/pambase"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gentoo/pambase.git"
else
	SRC_URI="https://github.com/gentoo/pambase/archive/${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
	S="${WORKDIR}/${PN}-${P}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="caps debug elogind gnome-keyring homed minimal mktemp +nullok pam_krb5 pam_ssh +passwdqc pwhistory pwquality securetty selinux +sha512 systemd yescrypt"

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
"

BDEPEND="$(python_gen_any_dep '
		dev-python/jinja[${PYTHON_USEDEP}]
	')"

python_check_deps() {
	has_version -b "dev-python/jinja[${PYTHON_USEDEP}]"
}

src_configure() {
	${EPYTHON} ./${PN}.py \
		$(usex caps '--caps' '') \
		$(usex debug '--debug' '') \
		$(usex elogind '--elogind' '') \
		$(usex gnome-keyring '--gnome-keyring' '') \
		$(usex homed '--homed' '') \
		$(usex minimal '--minimal' '') \
		$(usex mktemp '--mktemp' '') \
		$(usex nullok '--nullok' '') \
		$(usex pam_krb5 '--krb5' '') \
		$(usex pam_ssh '--pam-ssh' '') \
		$(usex passwdqc '--passwdqc' '') \
		$(usex pwhistory '--pwhistory' '') \
		$(usex pwquality '--pwquality' '') \
		$(usex securetty '--securetty' '') \
		$(usex selinux '--selinux' '') \
		$(usex sha512 '--sha512' '') \
		$(usex systemd '--systemd' '') \
	|| die
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
