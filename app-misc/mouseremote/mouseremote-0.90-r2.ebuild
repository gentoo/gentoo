# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="X10 MouseRemote"
HOMEPAGE="http://www4.pair.com/gribnif/ha/"
SRC_URI="http://www4.pair.com/gribnif/ha/MouseRemote.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="virtual/perl-Time-HiRes"

S="${WORKDIR}/MouseRemote"

src_prepare() {
	eapply -p0 "${FILESDIR}"/${P}-makefile.diff
	eapply "${FILESDIR}"/${P}-gentoo.diff
	eapply -p0 "${FILESDIR}"/${P}-fix-warnings.diff

	eapply_user
}

src_compile() {
	cd MultiMouse && emake \
		CC=$(tc-getCC) \
		PREFIX=/usr \
		LOCKDIR=/var/lock \
	    JMANDIR=/usr/share/man/ja_JP.ujis
}

src_install() {
	dobin MultiMouse/multimouse
	dosbin MultiMouse/multimoused

	dodoc README MultiMouse/README.jis MultiMouse/README.newstuff
	newdoc MultiMouse/README README.MultiMouse
	newdoc client/MouseRemote.conf MouseRemote.conf.dist
	newdoc client/MouseRemote.pl MouseRemote.pl.dist
	newdoc client/MouseRemoteKeys.pl MouseRemoteKeys.pl.dist

	newinitd "${FILESDIR}"/mouseremote.start mouseremote
	newconfd "${FILESDIR}"/mouseremote.conf mouseremote
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
