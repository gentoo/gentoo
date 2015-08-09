# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils toolchain-funcs

MY_PN="MAKEDEV"
MY_VER=${PV%.*}
MY_REL=${PV#${MY_VER}.}
MY_P="${MY_PN}-${MY_VER}"
DESCRIPTION="program used for creating device files in /dev"
HOMEPAGE="http://people.redhat.com/nalin/MAKEDEV/"
SRC_URI="http://people.redhat.com/nalin/MAKEDEV/${MY_P}-${MY_REL}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="build selinux"

RDEPEND="!<sys-apps/baselayout-2.0.0_rc"
DEPEND=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-headers.patch #339674
}

src_compile() {
	use selinux && export SELINUX=1
	emake CC="$(tc-getCC)" OPTFLAGS="${CFLAGS}" || die
}

src_install() {
	# set devdir to makedevdir so we dont have to worry about /dev
	emake install DESTDIR="${D}" makedevdir=/sbin devdir=/sbin || die
	dodoc *.txt
	keepdir /dev
}

pkg_postinst() {
	if use build ; then
		# set up a base set of nodes to make recovery easier #368597
		"${ROOT}"/sbin/MAKEDEV -c "${ROOT}"/etc/makedev.d \
			-d "${ROOT}"/dev console hda input ptmx std sd tty
		# trim useless nodes
		rm -f "${ROOT}"/dev/fd[0-9]* # floppy
		rm -f "${ROOT}"/dev/sd[a-d][a-z]* "${ROOT}"/dev/sd[e-z]* # excess sata/scsi
		rm -f "${ROOT}"/dev/tty[a-zA-Z]* # excess tty
	fi
}
