# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib toolchain-funcs

# This library is part of sendmail, but it does not share the version number with it.
# In order to find the right libmilter version number, check SMFI_VERSION definition
# that can be found in ${S}/include/libmilter/mfapi.h (see also SM_LM_VRS_* defines).
# For example, version 1.0.1 has a SMFI_VERSION of 0x01000001.
SENDMAIL_VER=8.15.2

DESCRIPTION="The Sendmail Filter API (Milter)"
HOMEPAGE="http://www.sendmail.org/"
SRC_URI="ftp://ftp.sendmail.org/pub/sendmail/sendmail.${SENDMAIL_VER}.tar.gz"

LICENSE="Sendmail"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="ipv6 poll"

DEPEND="!mail-mta/sendmail
	!mail-mta/sendmail"
RDEPEND="!mail-mta/sendmail"

S="${WORKDIR}/sendmail-${SENDMAIL_VER}"

# build system patch copied from sendmail ebuild
# glibc patch from opensuse
PATCHES=(
	"${FILESDIR}/sendmail-8.14.6-build-system.patch"
	"${FILESDIR}/${PN}-sharedlib.patch"
	"${FILESDIR}/${PN}-glibc-2.30.patch"
	)

src_prepare() {
	default

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
	emake -j1 MILTER_SOVER=${PV}
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
		install -C obj.*/libmilter

	dodoc libmilter/README
	dodoc libmilter/docs/*
}
