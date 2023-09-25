# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PN="MAKEDEV"
MY_VER=${PV%.*}
MY_REL=${PV#${MY_VER}.}
MY_P="${MY_PN}-${MY_VER}"

DESCRIPTION="Program used for creating device files in /dev"
HOMEPAGE="https://people.redhat.com/nalin/MAKEDEV/"
SRC_URI="https://people.redhat.com/nalin/MAKEDEV/${MY_P}-${MY_REL}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="build selinux"

GROUP_DEPEND="
	acct-group/disk
	acct-group/floppy
	acct-group/kmem
	acct-group/lp
	acct-group/tty
	acct-group/uucp
"
IDEPEND="build? ( ${GROUP_DEPEND} )"
RDEPEND="${GROUP_DEPEND}
	!<sys-apps/baselayout-2.0.0_rc"

PATCHES=(
	"${FILESDIR}"/${P}-headers.patch # bug #339674
)

src_compile() {
	use selinux && export SELINUX=1
	emake CC="$(tc-getCC)" OPTFLAGS="${CFLAGS}"
}

src_install() {
	# set devdir to makedevdir so we don't have to worry about /dev
	emake install DESTDIR="${D}" makedevdir=/sbin devdir=/sbin
	dodoc *.txt
	keepdir /dev
}

pkg_postinst() {
	if use build ; then
		# Set up a base set of nodes to make recovery easier, bug #368597
		"${ROOT}"/sbin/MAKEDEV -c "${ROOT}"/etc/makedev.d \
			-d "${ROOT}"/dev console hda input ptmx std sd tty

		# Trim useless nodes
		rm -f "${ROOT}"/dev/fd[0-9]* # floppy
		rm -f "${ROOT}"/dev/sd[a-d][a-z]* "${ROOT}"/dev/sd[e-z]* # excess sata/scsi
		rm -f "${ROOT}"/dev/tty[a-zA-Z]* # excess tty
	fi
}
