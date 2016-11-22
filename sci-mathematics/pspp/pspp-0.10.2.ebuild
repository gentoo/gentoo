# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils elisp-common

DESCRIPTION="Program for statistical analysis of sampled data"
HOMEPAGE="https://www.gnu.org/software/pspp/pspp.html"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cairo doc emacs examples gtk ncurses nls perl postgres static-libs"

RDEPEND="
	dev-libs/libxml2:2=
	sci-libs/gsl:0=
	sys-devel/gettext:0=
	sys-libs/readline:0=
	sys-libs/zlib:0=
	virtual/libiconv
	cairo? ( x11-libs/cairo:0=[svg] )
	emacs? ( virtual/emacs )
	gtk? (
			x11-libs/gtk+:3=
			x11-libs/gtksourceview:3.0= )
	ncurses? ( sys-libs/ncurses:0= )
	postgres? ( dev-db/postgresql:=[server] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )"

SITEFILE=50${PN}-gentoo.el

src_configure() {
	econf \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		$(use_with cairo) \
		$(use_with gtk gui) \
		$(use_with ncurses libncurses) \
		$(use_with perl perl-module) \
		$(use_with postgres libpq)
}

src_compile() {
	default
	use doc && emake html pdf
	use emacs && elisp-compile *.el
}

src_install() {
	default
	if use doc; then
		dodoc doc/pspp{,-dev}.pdf
		insinto /usr/share/doc/${PF}/html
		dodoc -r doc/pspp{,-dev}.html
	fi
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
	if use emacs; then
		elisp-install ${PN} *.el *.elc
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
	prune_libtool_files --all
}

pkg_postinst () {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
