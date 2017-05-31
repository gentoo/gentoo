# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp-common eutils

DESCRIPTION="GNU Forth is a fast and portable implementation of the ANSI Forth language"
HOMEPAGE="https://www.gnu.org/software/gforth"
SRC_URI="mirror://gnu/gforth/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris"
IUSE="emacs"

DEPEND="dev-libs/ffcall
	emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.7.0-make-elc.patch"
	epatch_user
}

src_configure() {
	# May want to add a USE flag for --enable-force-cdiv, if necessary
	# At this point I do not know when that is appropriate, and I don't
	# want to add an ebuild-specific USE flag without understanding.
	econf \
		--without-check \
		$(use emacs || echo "--without-lispdir")
}

src_compile() {
	# Parallel make breaks here
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS BUGS ChangeLog NEWS* README* ToDo doc/glossaries.doc doc/*.ps

	if use emacs; then
		elisp-install ${PN} gforth.el gforth.elc
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
