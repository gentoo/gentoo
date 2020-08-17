# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit pam python-any-r1

DESCRIPTION="PAM base configuration files"
HOMEPAGE="https://github.com/gentoo/pambase"
SRC_URI="https://github.com/gentoo/pambase/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="caps debug elogind minimal mktemp +nullok pam_krb5 pam_ssh +passwdqc pwquality securetty selinux +sha512 systemd"

RESTRICT="binchecks"

REQUIRED_USE="
	?? ( elogind systemd )
	?? ( passwdqc pwquality )
"

MIN_PAM_REQ=1.4.0

RDEPEND="
	>=sys-libs/pam-${MIN_PAM_REQ}
	elogind? ( sys-auth/elogind[pam] )
	mktemp? ( sys-auth/pam_mktemp )
	pam_krb5? (
		>=sys-libs/pam-${MIN_PAM_REQ}
		sys-auth/pam_krb5
	)
	caps? ( sys-libs/libcap[pam] )
	pam_ssh? ( sys-auth/pam_ssh )
	passwdqc? ( sys-auth/passwdqc )
	pwquality? ( dev-libs/libpwquality[pam] )
	selinux? ( sys-libs/pam[selinux] )
	sha512? ( >=sys-libs/pam-${MIN_PAM_REQ} )
	systemd? ( sys-apps/systemd[pam] )
"

BDEPEND="$(python_gen_any_dep '
		dev-python/jinja[${PYTHON_USEDEP}]
	')"

python_check_deps() {
	has_version -b "dev-python/jinja[${PYTHON_USEDEP}]"
}

S="${WORKDIR}/${PN}-${P}"

src_configure() {
	${EPYTHON} ./${PN}.py \
	$(usex caps '--libcap' '') \
	$(usex debug '--debug' '') \
	$(usex elogind '--elogind' '') \
	$(usex minimal '--minimal' '') \
	$(usex mktemp '--mktemp' '') \
	$(usex nullok '--nullok' '') \
	$(usex pam_krb5 '--krb5' '') \
	$(usex pam_ssh '--pam-ssh' '') \
	$(usex passwdqc '--passwdqc' '') \
	$(usex pwquality '--pwquality' '') \
	$(usex securetty '--securetty' '') \
	$(usex selinux '--selinux' '') \
	$(usex sha512 '--sha512' '') \
	$(usex systemd '--systemd' '')
}

src_test() { :; }

src_install() {
	dopamd -r stack/.
}
