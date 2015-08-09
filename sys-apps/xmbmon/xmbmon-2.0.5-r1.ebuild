# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

MY_P=${PN}${PV//.}
DESCRIPTION="Mother Board Monitor Program for X Window System"
HOMEPAGE="http://www.nt.phys.kyushu-u.ac.jp/shimizu/download/download.html"
SRC_URI="http://www.nt.phys.kyushu-u.ac.jp/shimizu/download/xmbmon/${MY_P}.tar.gz
	http://www.nt.phys.kyushu-u.ac.jp/shimizu/download/xmbmon/${MY_P}_fflush.patch"
#	http://www.nt.phys.kyushu-u.ac.jp/shimizu/download/xmbmon/${MY_P}_A7N8X-VM.patch

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE="X"

DEPEND="X? ( x11-libs/libXt
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libICE )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# epatch ${DISTDIR}/${MY_P}_A7N8X-VM.patch
	epatch "${DISTDIR}"/${MY_P}_fflush.patch
	epatch "${FILESDIR}"/${P}-amd64.patch
	epatch "${FILESDIR}"/${P}-pid.patch
	epatch "${FILESDIR}"/${P}-loopback.patch
	sed -i \
		-e "/^CFLAGS=/s/-O3/${CFLAGS}/" \
		-e '/^LDFLAGS=-s$/d' \
		Makefile.in || die
	sed -i \
		-e '/^[[:space:]]*CC=gcc/s,.*,:;,' \
		configure || die
}

src_compile() {
	econf || die "Configure failed"
	emake mbmon || die "Make mbmon failed"
	if use X ; then
		emake xmbmon || die "Make xmbmon failed"
	fi
}

src_install() {
	dosbin mbmon || die "mbmon failed"
	doman mbmon.1
	dodoc ChangeLog* ReadMe* mbmon-rrd.pl

	if use X ; then
		dosbin xmbmon || die "xmbmon failed"
		doman xmbmon.1x
		insinto /etc/X11/app-defaults/
		newins xmbmon.resources XMBmon
	fi

	newinitd "${FILESDIR}"/mbmon.rc mbmon
	newconfd "${FILESDIR}"/mbmon.confd mbmon
}

pkg_postinst() {
	echo
	einfo "These programs access SMBus/ISA-IO ports without any kind"
	einfo "of checking.  It is, therefore, very dangerous and may cause"
	einfo "a system-crash. Make sure you read ReadMe,"
	einfo "section 4, 'How to use!'"
	echo
}
