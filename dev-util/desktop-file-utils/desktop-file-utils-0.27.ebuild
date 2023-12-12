# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp-common meson

DESCRIPTION="Command line utilities to work with desktop menu entries"
HOMEPAGE="https://freedesktop.org/wiki/Software/desktop-file-utils/"
SRC_URI="https://www.freedesktop.org/software/${PN}/releases/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="emacs"

RDEPEND=">=dev-libs/glib-2.12:2"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	virtual/pkgconfig
	emacs? ( >=app-editors/emacs-23.1:* )
"

SITEFILE="50${PN}-gentoo.el"

DOCS=( AUTHORS ChangeLog HACKING NEWS README )

src_compile() {
	meson_src_compile
	use emacs && elisp-compile misc/desktop-entry-mode.el
}

src_install() {
	meson_src_install
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
