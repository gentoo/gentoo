# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

PATCHLEVEL="7"

DESCRIPTION="This is the DHCP/BOOTP client written by RedHat"
HOMEPAGE="http://ftp.debian.org/debian/pool/main/p/pump/"
SRC_URI="mirror://debian/pool/main/p/${PN}/${PN}_${PV}.orig.tar.gz
	mirror://debian/pool/main/p/${PN}/${PN}_${PV}-${PATCHLEVEL}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm hppa ia64 ppc sparc x86"
IUSE=""

DEPEND=">=dev-libs/popt-1.5"
RDEPEND="${DEPEND}"

src_prepare() {
	# Fix Debian patch to fit epatch logic
	sed -i \
		-e 's:/debian::g' \
		-e '/^---/s:pump-0.8.24.orig/::' \
		-e '/^+++/s:pump-0.8.24/::' \
		"${WORKDIR}/${PN}_${PV}-${PATCHLEVEL}.diff" || die "sed on ${PN}_${PV}-${PATCHLEVEL}.diff failed"

	# Apply Debians pump patchset - they fix things good :)
	# Debian patchset 7 include gentoo patchset too
	epatch "${WORKDIR}/${PN}_${PV}-${PATCHLEVEL}.diff"
	# Add LC_ALL workaround to make sure that patches are applied in right order(bug 471666)
	LC_ALL=C EPATCH_FORCE="yes" EPATCH_SOURCE="patches" EPATCH_SUFFIX="patch" epatch

	# respect AR, wrt bug #458482
	tc-export AR

	epatch_user
}

src_compile() {
	emake CC="$(tc-getCC)" DEB_CFLAGS="-fPIC ${CFLAGS}" pump
}

src_install() {
	exeinto /sbin
	doexe pump

	doman pump.8
	dodoc changelog CREDITS

	dolib.a libpump.a
	doheader pump.h
}
