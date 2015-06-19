# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rplay/rplay-3.3.2-r1.ebuild,v 1.10 2014/08/10 21:11:24 slyfox Exp $

inherit autotools eutils multilib user

DESCRIPTION="Play sounds on remote Unix systems, without sending audio data over the network"
HOMEPAGE="http://rplay.doit.org/"
SRC_URI="http://rplay.doit.org/dist/${P}.tar.gz mirror://debian/pool/main/r/rplay/rplay_${PV}-12.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="media-sound/gsm"
DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup rplayd ""
	enewuser rplayd "" "" "" rplayd
}

src_unpack() {
	unpack ${A}
	epatch "${WORKDIR}"/rplay_${PV}-12.diff
	cd "${S}"
	EPATCH_FORCE="yes" EPATCH_SUFFIX="dpatch" epatch debian/patches
	epatch "${FILESDIR}"/${P}-built-in_function_exit.patch
	eautoreconf
}

src_compile() {
	econf \
		--enable-rplayd-user=rplayd \
		--enable-rplayd-group=rplayd
	emake || die
}

src_install() {
	einstall || die
}
