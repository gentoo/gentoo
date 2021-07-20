# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp-common

DESCRIPTION="GNU Forth is a fast and portable implementation of the ANSI Forth language"
HOMEPAGE="https://www.gnu.org/software/gforth"
SRC_URI="mirror://gnu/gforth/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris"
IUSE="+check emacs"

DEPEND="dev-libs/ffcall
	emacs? ( >=app-editors/emacs-23.1:* )"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo.el"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.0-make-elc.patch
	"${FILESDIR}"/${PN}-0.7.3-rdynamic.patch
	"${FILESDIR}"/${PN}-0.7.3-rdynamic-auto.patch
	"${FILESDIR}"/${PN}-0.7.3-CFLAGS-LDFLAGS.patch
)

src_prepare() {
	default

	# gforth uses both $LIBTOOL and $GNU_LIBTOOL.
	# Let's settle on the former: bug #799371
	if [[ -n $LIBTOOL ]]; then
		export GNU_LIBTOOL=$LIBTOOL
		# ./configure does not generate it, but slibtool assumes
		# it's around
		ln -s ${EPREFIX}/usr/bin/libtool libtool || die
	fi

	# We patches both configure and configure.ac.
	# Avoid reruining aclocal.
	touch aclocal.m4 configure || die
}

src_configure() {
	econf \
		$(use emacs || echo "--without-lispdir") \
		$(use_with check)
}

src_compile() {
	# Parallel make breaks here
	emake -j1
}

src_install() {
	default

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
