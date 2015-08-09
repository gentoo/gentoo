# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils toolchain-funcs user

#
# Mailbox format is determined by the 'mbox' and 'maildir'
# system USE flags.
#
# Mailbox path configuration denoted by the system USE
# flags.
#
# USE flag 'maildir' denotes ~/.maildir
# USE flag 'mbox' denotes /var/mail/username
#
# You can overwrite this by setting the POPA3D_HOME_MAILBOX
# environmental variable (see below) before emerge.
#
# Environmental variables.
#
# POPA3D_HOME_MAILBOX
#
# Overwrite the local user mailbox path. For example
# if you want qmail-styled ~/Mailbox you can set it
# to "Mailbox". For the traditional (although not in
# gentoo Maildir) set it to "Maildir".
#
# POPA3D_VIRTUAL_ONLY
#
# Set this field to "YES" if you dont want local users
# to have POP access. Setting this makes the POPA3D_HOME_MAILBOX
# variable effectively useless.
#
# POPA3D_VIRTUAL_HOME_PATH
#
# Set this field to the base virtual home path. For more information
# read the virtual guide here: http://forums.gentoo.org/viewtopic.php?t=82386
#
######
# 12/07/2005 - port001
# Version 1.0 introduced some increased default values for a number of
# configuration paramaters. These values are way too high for most systems.
MAX_SESSIONS=100 # Default is 500
MAX_SESSIONS_PER_SOURCE=10 # Default is 50

MAX_MAILBOX_MESSAGES=100000 # Default is 2097152
MAX_MAILBOX_OPEN_BYTES=100000000 # Default is 2147483647
MAX_MAILBOX_WORK_BYTES=150000000 # Default is 2147483647
######

IUSE="pam mbox +maildir"

DESCRIPTION="A security oriented POP3 server"
HOMEPAGE="http://www.openwall.com/popa3d/"

SRC_URI="http://www.openwall.com/popa3d/${P}.tar.gz
	mirror://gentoo/popa3d-0.6.3-vname-2.diff.gz
	maildir? ( mirror://gentoo/popa3d-0.5.9-maildir-2.diff.gz )"

LICENSE="Openwall"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

DEPEND=">=sys-apps/sed-4
	pam? ( >=sys-libs/pam-0.72
	       >=net-mail/mailbase-0.00-r8[pam] )"
RDEPEND="${DEPEND}"

REQUIRED_USE="^^ ( maildir mbox )"

pkg_setup() {
	echo
	ewarn
	ewarn "You can customize this ebuild with environmental variables."
	ewarn "If you don't set any I'll assume sensible defaults."
	ewarn
	ewarn "See inside this ebuild for details."
	ewarn
	echo

	enewgroup popa3d
	enewuser popa3d -1 -1 -1 popa3d
}

src_prepare(){
	epatch "${DISTDIR}"/popa3d-0.6.3-vname-2.diff.gz
	use maildir && epatch "${DISTDIR}"/popa3d-0.5.9-maildir-2.diff.gz
}

src_compile() {
	sed -i \
		-e "s:^\(#define MAX_SESSIONS\) .*$:\1 ${MAX_SESSIONS}:" \
		-e "s:^\(#define MAX_SESSIONS_PER_SOURCE\).*$:\1 ${MAX_SESSIONS_PER_SOURCE}:" \
		-e "s:^\(#define MAX_MAILBOX_MESSAGES\).*$:\1 ${MAX_MAILBOX_MESSAGES}:" \
		-e "s:^\(#define MAX_MAILBOX_OPEN_BYTES\).*$:\1 ${MAX_MAILBOX_OPEN_BYTES}:" \
		-e "s:^\(#define MAX_MAILBOX_WORK_BYTES\).*$:\1 ${MAX_MAILBOX_WORK_BYTES}:" \
			params.h || die "sed on params.h failed (1)"

	if use maildir ; then
		einfo "Mailbox format is: MAILDIR."
		if [[ -z ${POPA3D_HOME_MAILBOX} ]] ; then
			POPA3D_HOME_MAILBOX=".maildir"
		fi
	else
		einfo "Mailbox format is: MAILBOX."
	fi

	if [[ -n ${POPA3D_HOME_MAILBOX} ]] ; then
		einfo "Mailbox path: ~/${POPA3D_HOME_MAILBOX}"
		sed -i \
			-e "s:^\(#define MAIL_SPOOL_PATH.*\)$://\1:" \
			-e "s:^\(#define HOME_MAILBOX_NAME\).*$:\1 \"${POPA3D_HOME_MAILBOX}\":" \
				params.h || die "sed on params.h failed (2)"
	else
		einfo "Mailbox path: /var/mail/username"
	fi

	if [[ ${POPA3D_VIRTUAL_ONLY} = "YES" ]] ; then
		einfo "Virtual only, no local system users"
		sed -i -e "s:^\(#define VIRTUAL_ONLY\).*$:\1 1:" \
			params.h || die "sed on param.h failed (2.5)"
	fi

	if [[ -n ${POPA3D_VIRTUAL_HOME_PATH} ]] ; then
		einfo "Virtual home path set to: ${POPA3D_VIRTUAL_HOME_PATH}"
		sed -i \
			-e "s:^\(#define VIRTUAL_HOME_PATH\).*$:\1 \"$POPA3D_VIRTUAL_HOME_PATH\":" \
				params.h || die "sed on params.h failed (3)"
	fi

	if [[ ${POPA3D_VIRTUAL_ONLY} = "YES" ]] ; then
		einfo "Authentication method: Virtual."
	elif use pam ; then
		einfo "Authentication method: PAM."
		LIBS="${LIBS} -lpam"
		sed -i \
			-e "s:^\(#define AUTH_SHADOW\)[[:blank:]].*$:\1 0:" \
			-e "s:^\(#define AUTH_PAM\)[[:blank:]].*$:\1 1:" \
				params.h || die "sed on params.h failed (4)"
	else
		einfo "Authentication method: Shadow."
	fi

	sed -i \
		-e "s:^\(#define POP_STANDALONE\).*$:\1 1:" \
		-e "s:^\(#define POP_VIRTUAL\).*$:\1 1:" \
		-e "s:^\(#define VIRTUAL_VNAME\).*$:\1 1:" \
			params.h || die "sed on params.h failed (5)"

	sed -i \
		-e '/^CC =/d' \
		-e '/^CFLAGS =/d' \
		-e '/^LDFLAGS =/d' \
			Makefile || die "Makefile cleaning failed"

	emake LIBS="${LIBS} -lcrypt" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC=$(tc-getCC)
}

src_install() {
	into /usr

	dosbin popa3d
	doman popa3d.8
	dodoc DESIGN INSTALL CHANGES VIRTUAL CONTACT

	diropts -m 755
	dodir /var/empty
	keepdir /var/empty

	newinitd "${FILESDIR}"/popa3d-initrc popa3d

	if use pam ; then
		dodir /etc/pam.d/
		dosym /etc/pam.d/pop /etc/pam.d/popa3d
	fi
}
