# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="X10 MouseRemote"
HOMEPAGE="http://www4.pair.com/gribnif/ha/"
SRC_URI="http://www4.pair.com/gribnif/ha/MouseRemote.tar.gz"
S="${WORKDIR}"/MouseRemote

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="virtual/perl-Time-HiRes"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-fix-warnings.patch
	"${FILESDIR}"/${P}-fix-clang-16.patch
)

src_compile() {
	emake -C MultiMouse \
		CC="$(tc-getCC)" \
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

	newinitd "${FILESDIR}"/mouseremote.start-r1 mouseremote
	newconfd "${FILESDIR}"/mouseremote.conf mouseremote
}

pkg_postinst() {
	[[ -e /dev/mumse ]] || mkfifo "${ROOT}"/dev/mumse
	[[ -e /dev/x10fifo ]] || mkfifo "${ROOT}"/dev/x10fifo

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
	elog "Configure the daemon is run in ${EROOT}/etc/conf.d/mouseremote."
	elog
	elog "See ${EROOT}/usr/share/doc/${PF} on how to configure the buttons."
}
