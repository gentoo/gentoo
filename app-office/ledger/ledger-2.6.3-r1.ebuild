# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils elisp-common autotools

DESCRIPTION="A double-entry accounting system with a command-line reporting interface"
HOMEPAGE="http://ledger-cli.org/"
SRC_URI="mirror://github/jwiegley/${PN}/${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x64-macos"
SLOT="0"
IUSE="emacs debug gnuplot ofx static-libs xml vim-syntax"

DEPEND="
	dev-libs/gmp:0
	dev-libs/libpcre
	ofx? ( >=dev-libs/libofx-0.9 )
	xml? ( dev-libs/expat )
	emacs? ( virtual/emacs )
	gnuplot? ( sci-visualization/gnuplot )"
RDEPEND="${DEPEND}
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )"

DOCS=(sample.dat README NEWS)

SITEFILE=50${PN}-gentoo.el

src_prepare() {
	sed -i -e "/ledger_LDFLAGS/d" Makefile.am
	eautoreconf
}

src_configure() {
	# Autodetection of dependencies may fail in the case of:
	# USE=emacs disabled, app-editors/emacs not installed, app-editors/xemacs installed
	use emacs || export EMACS=no
	econf \
		$(use_enable debug) \
		$(use_with emacs lispdir "${EPREFIX}/${SITELISP}/${PN}") \
		$(use_enable ofx) \
		$(use_enable static-libs static) \
		$(use_enable xml)
}

src_install() {
	default

	# One script uses vi, the outher the Finance perl module
	# Did not add more use flags though
	exeinto /usr/share/${PN}/scripts
	doexe scripts/{entry,getquote,bal,bal-huquq}

	# Remove timeclock since it is part of Emacs
	rm -f "${ED}${SITELISP}/${PN}"/timeclock.*

	use emacs && elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	if use gnuplot; then
		mv scripts/report ledger-report
		dobin ledger-report
	fi

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins ledger.vim
	fi

	use static-libs || find "${ED}" -name '*.la' -exec rm -f '{}' +
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
