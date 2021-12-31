# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit elisp-common

DESCRIPTION="Command line utilities to work with desktop menu entries"
HOMEPAGE="https://freedesktop.org/wiki/Software/desktop-file-utils"
SRC_URI="https://www.freedesktop.org/software/${PN}/releases/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="emacs"

RDEPEND=">=dev-libs/glib-2.12:2
	emacs? ( virtual/emacs )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig
"

SITEFILE=50${PN}-gentoo.el

DOCS=( AUTHORS ChangeLog HACKING NEWS README )

src_prepare() {
	default
	sed -i -e '/SUBDIRS =/s:misc::' Makefile.in || die
}

src_configure() {
	econf "$(use_with emacs lispdir "${SITELISP}"/${PN})"
}

src_compile() {
	default
	use emacs && elisp-compile misc/desktop-entry-mode.el
}

src_install() {
	default
	if use emacs; then
		elisp-install ${PN} misc/*.el misc/*.elc || die
		elisp-site-file-install "${FILESDIR}"/${SITEFILE} || die
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
