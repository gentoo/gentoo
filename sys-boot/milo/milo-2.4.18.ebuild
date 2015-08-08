# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit flag-o-matic eutils

# Currently tested Systems:
#
# 	Ruffian: UX164, BX164
#

DESCRIPTION="The Alpha MIniLOader, for Alpha Machines without SRM"
HOMEPAGE="http://milo.core-systems.de/"

# ive tested this, and it seems to make little difference
# which kernel version you use, so it makes sense to use the
# latest available 2.2 kernel with the latest bugfixes/drivers/etc.

kernel_version="2.2.25"
milo_version="2.2-18"
ldmilo_patch="20010430"

# milo-2.2-18.tar.bz2 :- latest milo sources
# linux-2.2.25.tar.bz2 :- latest linux 2.2 kernel sources
# ldmilo-patched-20010430 :- Ruffian ldmilo utility, with bugfixes by Jay Eastabrook
# linload.exe :- linload utility (ldmilo equivalent for non-ruffians).

SRC_URI="http://www.suse.de/~stepan/source/milo-${milo_version}.tar.bz2
	mirror://kernel/linux/kernel/v2.2/linux-${kernel_version}.tar.bz2
	http://dev.gentoo.org/~taviso/milo/ldmilo-patched-${ldmilo_patch}
	http://ftp.namesys.com/pub/reiserfs-for-2.2/linux-2.2.20-reiserfs-3.5.35.diff.bz2
	http://dev.gentoo.org/~taviso/milo/linload.exe
	http://www.ibiblio.org/pub/Linux/docs/HOWTO/MILO-HOWTO"

#
# milo license is dec palcode license, dec bios emulation license, and gpl-2 rolled
# into one big ugly package.
#
# the dec licenses say you can basically do anything you like, including modify
# and redistribute for profit or non-profit, as long as its for use with Alpha
# architecture.
#

LICENSE="MILO"
SLOT="0"

KEYWORDS="-* ~alpha"
IUSE=""

DEPEND="sys-apps/kbd
	>=sys-apps/sed-4"
RDEPEND="sys-fs/mtools"

S=${WORKDIR}/milo-${milo_version}

# You can change the default MILO serial
# number here, the MILO default is "Linux_is_Great!".
# There are some below that i have made you can
# use if you want, just uncomment the one you like.
#
# if you want to see how this works, to make your own
# look at mkserial_no.c in the filesdir.
#
##### Linux_is_Great! ###################
#milo_serial_number0=0x73695f78756e694c
#milo_serial_number1=0x002174616572475f
#
##### Gentoo Linux. #####################
milo_serial_number0=0x4c206f6f746e6547
milo_serial_number1=0x0000002e78756e69
#
##### Gentoo/Alpha. #####################
#milo_serial_number0=0x412f6f6f746e6547
#milo_serial_number1=0x0000002e6168706c
#
##### Gentoo MILO. ######################
#milo_serial_number0=0x4d206f6f746e6547
#milo_serial_number1=0x000000002e4f4c49
#
##### |d|i|g|i|t|a|l| ###################
#milo_serial_number0=0x697c677c697c647c
#milo_serial_number1=0x007c6c7c617c747c;
#

src_unpack() {
	# unpack everything the kernel and milo sources
	unpack linux-${kernel_version}.tar.bz2
	unpack milo-${milo_version}.tar.bz2

	# gcc3 fixes, and some tweaks to get a build, also
	# reiserfs support for the kernel (and milo).
	cd ${WORKDIR}/linux; epatch ${FILESDIR}/linux-${kernel_version}-gcc3-milo.diff || die
	cd ${WORKDIR}/linux; epatch ${DISTDIR}/linux-2.2.20-reiserfs-3.5.35.diff.bz2 || die
	cd ${S}; epatch ${FILESDIR}/milo-${milo_version}-gcc3-gentoo.diff || die
}

src_compile() {
	unset MILO_ARCH
	for arches in	"Alpha-XLT  XLT"		\
			"Alpha-XL   XL"			\
			"AlphaBook1 BOOK1"		\
			"Avanti     AVANTI" 	\
			"Cabriolet  CABRIOLET"	\
			"EB66       EB66"		\
			"EB66+      EB66P"		\
			"EB64+      EB64P"		\
			"EB164      EB164"		\
			"PC164      PC164"		\
			"LX164      LX164"		\
			"SX164      SX164"		\
			"Noname     NONAME"		\
			"Takara     TAKARA"		\
			"Mikasa     MIKASA"		\
			"Alcor      ALCOR"		\
			"Miata      MIATA"		\
			"Ruffian    RUFFIAN"	\
			"Platform2000   P2K"	\
			"UDB        UDB"
	do
		if [ -z "${MILO_IMAGE}" ]; then
			MILO_ARCH="${MILO_ARCH} \"${arches}\""
		else
			if echo ${arches} | grep -i ${MILO_IMAGE}; then
				MILO_ARCH="\"${arches}\""
			fi
		fi
	done

	if [ -z "${MILO_ARCH}" ]; then
		eerror "Sorry, but ${MILO_IMAGE} doesnt look valid to me"
		eerror "Consult the Alpha installation guide, or the ebuild"
		eerror "for a list of available Alphas."
		die "${MILO_IMAGE} not supported, or not recognised."
	fi

	sed -i "s!__MILO_ARCHES__!${MILO_ARCH}!g" ${S}/tools/scripts/build

	ewarn
	ewarn "seriously, this is going to take a while, go get some coffee..."
	ewarn
	einfo "this ebuild will build the standard MILO images, similar to those"
	einfo "distributed with some distributions, and the images provided with"
	einfo "the official MILO sources."
	einfo
	einfo "of course, the beauty of MILO is it can support any device supported"
	einfo "by the linux kernel, so if you need support for non-standard hardware"
	einfo "set the path to the .config you want in \$custom_milo_kernel_config and"
	einfo "i will use it instead of the default."
	ewarn

	einfon "continuing in 10 seconds ..."
	epause 10

	# get kernel configured
	cp ${custom_milo_kernel_config:-${S}/Documentation/config/linux-2.2.19-SuSE.config} \
		${WORKDIR}/linux/.config
	cd ${WORKDIR}/linux; yes n | make oldconfig || die "unable to configure kernel."

	# we're building a generic kernel that defaults to ev5, but theres no
	# reason why we cant tweak the instruction set.
	# im not sure if you can actually pull a system performance gain/faster
	# boot from optimising milo, but at least you'll get a faster milo pager ;)
	mcpu_flag="`get-flag mcpu`"
	if [ ! -z "${mcpu_flag}" ]; then
		sed -i "s/\(CFLAGS := \$(CFLAGS) \)-mcpu=ev5$/\1-mcpu=${mcpu_flag:-ev5}/g" \
			${WORKDIR}/linux/arch/alpha/Makefile
	fi

	# build the generic linux kernel, of course if you have
	# hardware not supported by this generic kernel, you are free
	# to hack it (or the .config used here).
	einfo "building a generic kernel for use with milo..."
	unset CC DISTCC_HOSTS; make dep vmlinux || die "unable to build generic kernel for milo."
	cat ${FILESDIR}/objstrip.c > ${WORKDIR}/linux/arch/alpha/boot/tools/objstrip.c

	# make the objstrip utility.
	gcc ${WORKDIR}/linux/arch/alpha/boot/tools/objstrip.c -o \
		${WORKDIR}/linux/arch/alpha/boot/tools/objstrip || die "couldnt build objstrip."
	einfo "kernel build complete."
	einfo "building milo images..."

	# we have a choice here, milo can set the serial number to just about
	# anything we like, the milo author has chosen "Linux_is_Great!", which
	# is a bit cheesy, but we will leave it as default if user hasnt chosen
	# something else.
	# see above for options.

	append-flags -DMILO_SERIAL_NUMBER0="${milo_serial_number0:-0x73695f78756e694c}"
	append-flags -DMILO_SERIAL_NUMBER1="${milo_serial_number1:-0x002174616572475f}"

	# the Makefile missed this :-/
	cd ${S}/tools/common; make || die "couldnt make commonlib."

	# build all the milo images.
	cd ${S}; tools/scripts/build || die "failed to build milo images."

	# put the ldmilo utility there.
	cp ${DISTDIR}/ldmilo-patched-${ldmilo_patch} ${S}/binaries/ldmilo.exe
	cp ${DISTDIR}/linload.exe ${S}/binaries/linload.exe

}

src_install() {

	cd ${S}; dodir /opt/milo
	insinto /opt/milo

	einfo "Installing MILO images..."
	for i in binaries/*
	do
		einfo "	${i}"
		doins ${i}
	done

	cd ${S}/Documentation

	dodoc ChangeLog filesystem Nikita.Todo README.milo Todo LICENSE README.BSD Stuff WhatIsMilo \
		${FILESDIR}/README-gentoo ${FILESDIR}/mkserial_no.c ${DISTDIR}/MILO-HOWTO

}

pkg_postinst() {
	einfo "The MILO images have been installed into /opt/milo."
	einfo "There are instructions in /usr/share/doc/${P} for making MILO boot floppies."
	einfo "Alternative methods, (flash, srm, debug monitor, etc) are described in the MILO-HOWTO."
	einfo
	einfo "The important docs to read are the README-gentoo and the MILO-HOWTO."
	einfo
	ewarn "PLEASE, PLEASE, PLEASE, let me know if this works or not, i need to know which systems"
	ewarn "need tweaking, and which ones are good to go. You can email me at taviso@gentoo.org"
	einfo
}
