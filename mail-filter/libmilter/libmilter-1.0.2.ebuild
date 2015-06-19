# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/libmilter/libmilter-1.0.2.ebuild,v 1.8 2014/05/04 16:04:35 maekke Exp $

EAPI="2"

inherit eutils multilib toolchain-funcs

# This library is part of sendmail, but it does not share the version number with it.
# In order to find the right libmilter version number, check SMFI_VERSION definition
# that can be found in ${S}/include/libmilter/mfapi.h (see also SM_LM_VRS_* defines).
# For example, version 1.0.1 has a SMFI_VERSION of 0x01000001.
SENDMAIL_VER=8.14.5

DESCRIPTION="The Sendmail Filter API (Milter)"
HOMEPAGE="http://www.sendmail.org/"
SRC_URI="ftp://ftp.sendmail.org/pub/sendmail/sendmail.${SENDMAIL_VER}.tar.gz"

LICENSE="Sendmail"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="ipv6 poll"

DEPEND="!mail-mta/sendmail
	!mail-mta/sendmail"
RDEPEND="!mail-mta/sendmail"

S="${WORKDIR}/sendmail-${SENDMAIL_VER}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-build-system.patch
	epatch "${FILESDIR}"/${PN}-sharedlib.patch

	local CC="$(tc-getCC)"
	local ENVDEF="-DNETUNIX -DNETINET"
	use ipv6 && ENVDEF="${ENVDEF} -DNETINET6"
	use poll && ENVDEF="${ENVDEF} -DSM_CONF_POLL=1"

	sed -e "s:@@CFLAGS@@:${CFLAGS}:" \
		-e "s:@@LDFLAGS@@:${LDFLAGS}:" \
		-e "s:@@CC@@:${CC}:" \
		-e "s:@@ENVDEF@@:${ENVDEF}:" \
		"${FILESDIR}/gentoo.config.m4" > "${S}/devtools/Site/site.config.m4" \
		|| die "failed to generate site.config.m4"
}

src_compile() {
	pushd libmilter
	emake -j1 MILTER_SOVER=${PV} || die "libmilter compilation failed"
	popd
}

src_install () {
	local MY_LIBDIR=/usr/$(get_libdir)
	dodir "${MY_LIBDIR}"
	emake DESTDIR="${D}" LIBDIR="${MY_LIBDIR}" MANROOT=/usr/share/man/man \
		SBINOWN=root SBINGRP=0 UBINOWN=root UBINGRP=0 \
		LIBOWN=root LIBGRP=0 GBINOWN=root GBINGRP=0 \
		MANOWN=root MANGRP=0 INCOWN=root INCGRP=0 \
		MSPQOWN=root CFOWN=root CFGRP=0 \
		MILTER_SOVER=${PV} \
		install -C obj.*/libmilter \
		|| die "install failed"

	dodoc libmilter/README
	dohtml libmilter/docs/*
}
