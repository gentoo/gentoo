# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/yc/yc-4.0.13.ebuild,v 1.9 2012/10/20 10:02:21 ago Exp $

EAPI=3

inherit elisp toolchain-funcs

DESCRIPTION="Yet another Canna client on Emacsen"
HOMEPAGE="http://www.ceres.dti.ne.jp/~knak/yc.html"
SRC_URI="http://www.ceres.dti.ne.jp/~knak/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND=">=app-i18n/canna-3.6"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	sed -e 's:$(CC) -o $(PROGRAM) $(OBJS):$(CC) ${CFLAGS} ${LDFLAGS} -o $(PROGRAM) $(OBJS):' -i Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}

src_install() {
	elisp-install ${PN} *.el *.elc || die
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
	dobin icanna || die
	newdoc "${FILESDIR}"/sample.dot.emacs-4 sample.dot.emacs || die
	dodoc "${FILESDIR}"/sample.hosts.canna || die
}

pkg_postinst() {
	elisp-site-regen
	elog "See the sample.dot.emacs file in /usr/share/doc/${PF}/."
	elog
	elog "And If you use unix domain socket for connecting the canna server, "
	elog "  please confirm that there's *no* following line in your .emacs ."
	elog "  (setq yc-server-host \"localhost\")"
	elog
	elog "If you use inet domain socket for connecting the canna server, "
	elog "  please modify as following in /etc/conf.d/canna."
	elog "  CANNASERVER_OPTS=\"-inet\""
	elog "  And create /etc/hosts.canna."
	elog "  (see the sample.hosts.canna file in /usr/share/doc/${PF}/)"
}

pkg_postrm() {
	elisp-site-regen
}
