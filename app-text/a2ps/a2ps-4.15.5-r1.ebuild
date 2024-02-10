# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools elisp-common

DESCRIPTION="Any to PostScript filter"
HOMEPAGE="https://www.gnu.org/software/a2ps/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="cjk emacs latex nls static-libs vanilla"

# a2ps-lpr-wrapper needs bash
RDEPEND="
	app-text/ghostscript-gpl
	app-text/libpaper:=
	>=app-text/psutils-1.17
	app-text/wdiff
	app-shells/bash:*
	dev-libs/boehm-gc
	>=sys-apps/coreutils-6.10-r1
	emacs? ( >=app-editors/emacs-23.1:* )
	latex? ( virtual/latex-base )
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/yacc
	>=dev-util/gperf-2.7.2
	nls? ( sys-devel/gettext )
"

SITEFILE="50${PN}-gentoo.el"

PATCHES=(
	"${FILESDIR}"/${PN}-4.15-lpr-wrapper.patch
)

src_prepare() {
	default

	use vanilla || eapply "${FILESDIR}"/${PN}-4.15-stdout.patch

	eautoreconf
}

src_configure() {
	export LANG=C LC_ALL=C

	econf \
		--cache-file="${S}"/config.cache \
		--enable-shared \
		$(use_enable static-libs static) \
		--sysconfdir="${EPREFIX}"/etc/a2ps \
		$(use_enable nls) \
		COM_netscape=no \
		COM_acroread=no \
		$(usev !latex COM_latex=no) \
		$(usev !emacs EMACS=no)
}

src_install() {
	emake \
		DESTDIR="${D}" \
		lispdir="${EPREFIX}${SITELISP}"/${PN} \
		install

	newdoc "${ED}"/usr/share/a2ps/README README.a2ps
	newdoc "${ED}"/usr/share/a2ps/ppd/README README.a2ps.ppd
	newdoc "${ED}"/usr/share/ogonkify/README README.ogonkify

	rm -f "${ED}"/usr/share/{a2ps,a2ps/ppd,ogonkify}/README || die

	find "${ED}" -name '*.la' -delete || die

	use emacs && elisp-site-file-install "${FILESDIR}"/${SITEFILE}

	dodoc ANNOUNCE AUTHORS ChangeLog FAQ NEWS README* THANKS TODO
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
