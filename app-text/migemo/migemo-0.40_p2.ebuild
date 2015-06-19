# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/migemo/migemo-0.40_p2.ebuild,v 1.9 2014/04/24 09:05:23 ago Exp $

EAPI=5
# jruby: dev-ruby/ruby-romkan not work
USE_RUBY="ruby19"

inherit autotools elisp-common eutils ruby-ng

MY_PV=${PV/_/}
DESCRIPTION="Migemo is Japanese Incremental Search Tool"
HOMEPAGE="http://0xcc.net/migemo/"
SRC_URI="https://github.com/yshl/migemo-for-Ruby-1.9/archive/${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 sparc x86"
IUSE="emacs"

ruby_add_bdepend "dev-ruby/ruby-romkan dev-ruby/bsearch"

DEPEND="${DEPEND}
	app-dicts/migemo-dict[-unicode]
	emacs? ( virtual/emacs
		app-emacs/apel )"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo.el"

RUBY_PATCHES=(
	"${FILESDIR}/${PN}-0.40-r5-without-emacs.patch"
	"${FILESDIR}/${P}-ruby-ng.patch"
)
RUBY_S="migemo-for-Ruby-1.9-${MY_PV}"

all_ruby_prepare() {
	cp "${EPREFIX}"/usr/share/migemo/migemo-dict .
	eautoreconf
}

each_ruby_configure() {
	RUBY="${RUBY}" econf $(use_with emacs) --with-lispdir="${SITELISP}/${PN}"
}

each_ruby_install() {
	emake DESTDIR="${ED}" \
		$(use emacs || echo "lispdir=") install
}

all_ruby_install() {
	rm "${ED}"/usr/share/migemo/migemo-dict

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
	dodoc AUTHORS ChangeLog INSTALL README
}

pkg_postinst() {
	if use emacs; then
		elisp-site-regen
		elog "Migemo adviced search is no longer enabled as a site default."
		elog "Add the following line to your ~/.emacs file to enable it:"
		elog "  (require 'migemo)"
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
