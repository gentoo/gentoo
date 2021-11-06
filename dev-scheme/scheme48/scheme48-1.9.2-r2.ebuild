# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit elisp-common flag-o-matic toolchain-funcs

DESCRIPTION="Scheme48 is an implementation of the Scheme Programming Language"
HOMEPAGE="https://www.s48.org/"
SRC_URI="https://www.s48.org/${PV}/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc emacs"

RDEPEND="emacs? ( >=app-editors/emacs-23.1:* )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/CVE-2014-4150.patch )

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default

	append-cflags -fno-strict-aliasing

	sed -i \
		-e "/# Cygwin/,/fi/d" \
		-e "s/\tar /\t$(tc-getAR) /" \
		-e "s/\tranlib/\t$(tc-getRANLIB) /" \
		-e "/\/COPYING/d" \
		-e "/for .*html/,/done/d" \
		Makefile.in
}

src_configure() {
	econf --docdir=/usr/share/doc/${PF}
}

src_compile() {
	default

	if use emacs; then
		elisp-compile emacs/*.el
	fi
}

src_install() {
	# weird parallel failures!
	emake -j1 DESTDIR="${D}" install

	if use doc; then
		DOCS=( README doc/*.txt )
		HTML_DOCS=( doc/html/. )
	else
		rm -f "${ED}"/usr/share/doc/${PF}/man*
	fi
	einstalldocs

	if use emacs; then
		elisp-install ${PN} emacs/*.el{,c}
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi

	# this symlink clashes with gambit
	rm "${ED}"/usr/bin/scheme-r5rs || die
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
