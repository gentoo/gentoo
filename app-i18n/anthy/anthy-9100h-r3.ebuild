# Copyright 2003-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp-common

DESCRIPTION="Anthy -- free and secure Japanese input system"
HOMEPAGE="http://anthy.osdn.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/37536/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="emacs static-libs"

BDEPEND="emacs? ( >=app-editors/emacs-23.1:* )"
DEPEND=""
RDEPEND="${BDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-anthy_context_t.patch" )
DOCS=( AUTHORS ChangeLog DIARY NEWS README )

SITEFILE="50${PN}-gentoo.el"

src_configure() {
	econf \
		$(use_enable static-libs static) \
		EMACS="$(usex emacs "${EMACS}")"
}

src_install() {
	default
	find "${D}" -name "*.la" -type f -delete || die

	rm doc/Makefile* || die
	dodoc -r doc

	if use emacs; then
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
