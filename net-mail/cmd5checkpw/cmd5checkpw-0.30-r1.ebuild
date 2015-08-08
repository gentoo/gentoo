# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils fixheadtails user

MY_VER="030"

DESCRIPTION="A checkpassword compatible authentication program that used CRAM-MD5 authentication mode"
SRC_URI="http://www.fehcom.de/qmail/auth/${PN}-${MY_VER}_tgz.bin"
HOMEPAGE="http://www.fehcom.de/qmail/smtpauth.html"

LICENSE="public-domain RSA"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

pkg_setup() {
	enewuser cmd5checkpw 212 -1 /dev/null bin
	ewarn
	ewarn "this version is in NO WAY COMPATIBLE with cmd5checkpw-0.2x"
	ewarn "it actually receives the authentication credentials"
	ewarn "in a different order then the old implementation"
	ewarn "see bug #100693 for details"
	ewarn "this version IS needed by >=qmail-1.03-r16"
	ewarn
}

src_unpack() {
	# The old code moved the file in DISTDIR, which is forbidden.
	# It's read-only.
	cd "${WORKDIR}"
	rm -f ${PN}-${MY_VER}.tar.gz
	ln -s "${DISTDIR}"/${PN}-${MY_VER}_tgz.bin ${PN}-${MY_VER}.tar.gz
	unpack ./${PN}-${MY_VER}.tar.gz
	cd "${S}"

	epatch "${FILESDIR}"/euid_${MY_VER}.diff
	epatch "${FILESDIR}"/reloc.diff

	sed -e 's:-c -g -Wall -O3:$(OPTCFLAGS):' -i Makefile

	ht_fix_file Makefile
}

src_compile() {
	emake OPTCFLAGS="${CFLAGS}" || die
}

src_install() {
	insinto /etc
	doins "${FILESDIR}"/poppasswd

	exeinto /bin
	doexe cmd5checkpw
	doman cmd5checkpw.8

	fowners cmd5checkpw /etc/poppasswd /bin/cmd5checkpw
	fperms 400 /etc/poppasswd
	fperms u+s /bin/cmd5checkpw
}

pkg_postinst() {
	chmod 400 "${ROOT}"/etc/poppasswd
	chown cmd5checkpw "${ROOT}"/etc/poppasswd
}
