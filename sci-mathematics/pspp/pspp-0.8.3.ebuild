# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/pspp/pspp-0.8.3.ebuild,v 1.3 2014/12/28 16:54:20 titanofold Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit eutils elisp-common autotools-utils multilib

DESCRIPTION="Program for statistical analysis of sampled data"
HOMEPAGE="http://www.gnu.org/software/pspp/pspp.html"
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
	cairo? ( x11-libs/cairo:0= )
	emacs? ( virtual/emacs )
	gtk? (
			gnome-base/libglade:2.0
			x11-libs/gtk+:2
			>=x11-libs/gtksourceview-2.2:2.0 )
	ncurses? ( sys-libs/ncurses )
	postgres? ( dev-db/postgresql:=[server] )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )"

SITEFILE=50${PN}-gentoo.el

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.0-gettext.patch
	"${FILESDIR}"/${PN}-0.8.1-underlinking.patch
	"${FILESDIR}"/${PN}-0.8.1-oos.patch
)

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		$(use_with cairo)
		$(use_with gtk gui)
		$(use_with ncurses libncurses)
		$(use_with perl perl-module)
		$(use_with postgres libpq)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile pkglibdir="${EPREFIX}/usr/$(get_libdir)"
	use doc && autotools-utils_src_compile html pdf
	use emacs && elisp-compile *.el
}

src_install() {
	if use doc; then
		HTML_DOCS=( "${BUILD_DIR}"/doc/pspp{,-dev}.html )
		DOCS=( "${BUILD_DIR}"/doc/pspp{,-dev}.pdf )
	fi

	autotools-utils_src_install pkglibdir="${EPREFIX}/usr/$(get_libdir)"

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi

	if use emacs; then
		elisp-install ${PN} *.el *.elc
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst () {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
