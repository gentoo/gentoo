# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit elisp toolchain-funcs

DESCRIPTION="Yet another Canna client on Emacsen"
HOMEPAGE="http://www.ceres.dti.ne.jp/~knak/yc.html"
SRC_URI="http://www.ceres.dti.ne.jp/~knak/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ppc x86"
IUSE=""

RDEPEND="app-i18n/canna"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	sed -i '/$(CC)/s/ -o / $(CFLAGS) $(LDFLAGS) -o /' Makefile

	default
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	elisp_src_install

	dobin icanna
	dodoc "${FILESDIR}"/sample.{dot.emacs,hosts.canna}
}

pkg_postinst() {
	elisp_pkg_postinst

	elog "See the sample.dot.emacs in ${EPREFIX}/usr/share/doc/${PF}."
	elog
	elog "And If you use unix domain socket for connecting the canna server,"
	elog "please confirm that there's *no* following line in your ~/.emacs:"
	elog '  (setq yc-server-host "localhost")'
	elog
	elog "If you use inet domain socket for connecting the canna server,"
	elog "please modify as following in ${EPREFIX}/etc/conf.d/canna:"
	elog '  CANNASERVER_OPTS="-inet"'
	elog
	elog "And create ${EPREFIX}/etc/hosts.canna."
	elog "See the sample.hosts.canna in ${EPREFIX}/usr/share/doc/${PF}."
}
