# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

S="${WORKDIR}/MouseRemote"
DESCRIPTION="X10 MouseRemote"
HOMEPAGE="http://www4.pair.com/gribnif/ha/"
SRC_URI="http://www4.pair.com/gribnif/ha/MouseRemote.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="virtual/perl-Time-HiRes"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-makefile.diff
	epatch "${FILESDIR}"/${PN}-gentoo-${PVR}.diff
}

src_compile() {
	cd MultiMouse && emake \
		CC=$(tc-getCC) \
		PREFIX=/usr \
		LOCKDIR=/var/lock \
	    JMANDIR=/usr/share/man/ja_JP.ujis || die
}

src_install() {
	dobin MultiMouse/multimouse || die
	dosbin MultiMouse/multimoused || die

	dodoc README MultiMouse/README.jis MultiMouse/README.newstuff || die
	newdoc MultiMouse/README README.MultiMouse || die
	newdoc client/MouseRemote.conf MouseRemote.conf.dist || die
	newdoc client/MouseRemote.pl MouseRemote.pl.dist || die
	newdoc client/MouseRemoteKeys.pl MouseRemoteKeys.pl.dist || die

	newinitd "${FILESDIR}"/mouseremote.start mouseremote || die
	newconfd "${FILESDIR}"/mouseremote.conf mouseremote || die
}

pkg_postinst() {
	[ -e /dev/mumse ] || mkfifo "${ROOT}"/dev/mumse
	[ -e /dev/x10fifo ] || mkfifo "${ROOT}"/dev/x10fifo

	elog "To use the mouse function in X, add the following to your XF86Config"
	elog "Section \"InputDevice\""
	elog "	Identifier  \"MouseREM\""
	elog "	Driver      \"mouse\""
	elog "	Option      \"Protocol\"      \"MouseSystems\""
	elog "	Option      \"Device\"        \"/dev/mumse\""
	elog "EndSection"
	elog
	elog "Don't forget to add the new device to the section \"ServerLayout\""
	elog "like:	InputDevice \"MouseREM\" \"SendCoreEvents\""
	elog
	elog "Enable the daemon with \"rc-update add mouseremote default\"."
	elog
	elog "Configure the daemon is run in /etc/conf.d/mouseremote."
	elog
	elog "See /usr/share/doc/${PF} on how to configure the buttons."
}
