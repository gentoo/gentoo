# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/lilo/lilo-22.8-r2.ebuild,v 1.7 2013/04/09 10:05:19 ssuominen Exp $

inherit eutils flag-o-matic toolchain-funcs

DOLILO_V="0.5"
IUSE="static minimal pxeserial device-mapper"

DESCRIPTION="Standard Linux boot loader"
HOMEPAGE="http://lilo.go.dyndns.org/pub/linux/lilo/"
DOLILO_TAR="dolilo-${DOLILO_V}.tar.bz2"
MY_P=${P}.src

SRC_URI="http://home.san.rr.com/johninsd/pub/linux/lilo/${MY_P}.tar.gz
	ftp://metalab.unc.edu/pub/Linux/system/boot/lilo/${MY_P}.tar.gz
	ftp://metalab.unc.edu/pub/Linux/system/boot/lilo/obsolete/${MY_P}.tar.gz
	mirror://gentoo/${DOLILO_TAR}"

SLOT="0"
LICENSE="BSD GPL-2"
KEYWORDS="-* amd64 x86"

DEPEND=">=sys-devel/bin86-0.15.5"
RDEPEND="device-mapper? ( >=sys-fs/lvm2-2.02.45 )"

src_unpack() {
	unpack ${MY_P}.tar.gz

	cd "${S}"

	# Correctly document commandline options -v and -V, bug #43554
	epatch "${FILESDIR}/${P}-correct-usage-info.patch"
	# Install manpages to correct location, do not rely on incorrect manpath output, bug #117135
	# Do not strip the main binary, it upsets portage, bug #140210
	# Do not install diag1.img, bug #149887
	epatch "${FILESDIR}/${P}-makefile.patch"

	# this patch is needed when booting PXE and the device you're using
	# emulates vga console via serial console.
	# IE..  B.B.o.o.o.o.t.t.i.i.n.n.g.g....l.l.i.i.n.n.u.u.x.x and stair stepping.
	use pxeserial && epatch "${FILESDIR}/${P}-novga.patch"
	use device-mapper || epatch "${FILESDIR}/${P}-nodevmapper.patch"

	unpack ${DOLILO_TAR}
}

src_compile() {
	# lilo needs this. bug #140209
	export LC_ALL=C

	# hardened automatic PIC plus PIE building should be suppressed
	# because of assembler instructions that cannot be compiled PIC
	HARDENED_CFLAGS="`test-flags-CC -fno-pic -nopie`"

	# we explicitly prevent the custom CFLAGS for stability reasons
	if use static; then
		emake CC="$(tc-getCC) ${HARDENED_CFLAGS}" lilo.static || die
		mv lilo.static lilo || die
	else
		emake CC="$(tc-getCC) ${HARDENED_CFLAGS}" lilo || die
	fi
}

src_install() {
	keepdir /boot
	make ROOT="${D}" install || die

	if use !minimal; then
		into /
		dosbin "${S}"/dolilo/dolilo

		into /usr
		dosbin keytab-lilo.pl

		insinto /etc
		newins "${FILESDIR}"/lilo.conf lilo.conf.example

		newconfd "${S}"/dolilo/dolilo.conf.d dolilo.example

		doman manPages/*.[5-8]
		dodoc CHANGES INCOMPAT README*
		docinto samples ; dodoc sample/*
	fi
}

# Check whether LILO is installed
# This function is from /usr/sbin/mkboot from debianutils, with copyright:
#
#   Debian GNU/Linux
#   Copyright 1996-1997 Guy Maor <maor@debian.org>
#
# Modified for Gentoo for use with the lilo ebuild by:
#   Martin Schlemmer <azarah@gentoo.org> (16 Mar 2003)
#
lilocheck () {
	local bootpart=
	local rootpart="$(mount | grep -v "tmpfs" | grep -v "rootfs" | grep "on / " | cut -f1 -d " ")"

	echo
	einfon "Checking for LILO ..."

	if [ "$(whoami)" != "root" ]
	then
		echo; echo
		eerror "Only root can check for LILO!"
		return 1
	fi

	if [ -z "${rootpart}" ]
	then
		echo; echo
		eerror "Could not determine root partition!"
		return 1
	fi

	if [ ! -f /etc/lilo.conf -o ! -x /sbin/lilo ]
	then
		echo " No"
		return 1
	fi

	bootpart="$(sed -n "s:^boot[ ]*=[ ]*\(.*\)[ ]*:\1:p" /etc/lilo.conf)"

	if [ -z "${bootpart}" ]
	then
		# lilo defaults to current root when 'boot=' is not present
		bootpart="${rootpart}"
	fi

	if ! dd if=${bootpart} ibs=16 count=1 2>&- | grep -q 'LILO'
	then
		echo; echo
		ewarn "Yes, but I couldn't find a LILO signature on ${bootpart}"
		ewarn "Check your /etc/lilo.conf, or run /sbin/lilo by hand."
		return 1
	fi

	echo " Yes, on ${bootpart}"

	return 0
}

pkg_postinst() {
	if [ ! -e "${ROOT}/boot/boot.b" -a ! -L "${ROOT}/boot/boot.b" ]
	then
		[ -f "${ROOT}/boot/boot-menu.b" ] && \
			ln -snf boot-menu.b "${ROOT}/boot/boot.b"
	fi

	if [ "${ROOT}" = "/" ] && use !minimal;
	then
		if lilocheck
		then
			einfo "Running DOLILO to complete the install ..."
			# do not redirect to /dev/null because it may display some input
			# prompt
			/sbin/dolilo
			if [ "$?" -ne 0 ]
			then
				echo
				ewarn "Running /sbin/dolilo failed!  Please check what the problem is"
				ewarn "before your next reboot."

				ebeep 5
				epause 5
			fi
		fi
		echo
	fi
	if use !minimal; then
		echo
		einfo "Issue 'dolilo' instead of 'lilo' to have a friendly wrapper that"
		einfo "handles mounting and unmounting /boot for you. It can do more then"
		einfo "that when asked, edit /etc/conf.d/dolilo to harness it's full potential."
		ebeep 5
		epause 3
		echo
	fi
}
