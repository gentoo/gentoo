# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson elisp-common

DESCRIPTION="Another Anthy - Japanese character set input library for Unicode"
HOMEPAGE="https://github.com/fujiwarat/anthy-unicode"
SRC_URI="https://github.com/fujiwarat/anthy-unicode/releases/download/${PV}/${P}.tar.xz"

# GPL-2+ for dictionaries
LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="emacs"

DEPEND="emacs? ( app-editors/emacs:* )"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_configure() {
	local emesonargs=(
		-Demacs_path="$(usev emacs ${EMACS})"
		-Dlisp_dir="$(usev emacs ${SITELISP})"
		$(meson_feature emacs)
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	rm doc/Makefile* || die
	dodoc -r doc

	if use emacs; then
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	else
		rm -r "${ED}"/usr/share/emacs || die
	fi
}

pkg_preinst() {
	if ! has_version app-i18n/anthy-unicode; then
		show_migrate_warning=true
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen

	if [[ -n ${show_migrate_warning} ]]; then
		ewarn "The path of the private dictionary has changed with anthy-unicode:"
		ewarn "app-i18n/anthy: ~/.anthy"
		ewarn "app-i18n/anthy-unicode: ~/.config/anthy"
		ewarn " "
		ewarn "To migrate the private dictionary, launch:"
		ewarn "anthy-dic-tool-unicode --migrate"
		ewarn " "
		ewarn "To make sure you only use anthy-unicode, please update all installed anthy's packages:"
		has_version "<app-dicts/kasumi-2.6" && ewarn "app-dicts/kasumi"
		has_version "<app-i18n/fcitx-anthy-5.1.9" && ewarn "app-i18n/fcitx-anthy"
		has_version "<app-i18n/ibus-anthy-1.5.17-r1" && ewarn "app-i18n/ibus-anthy"
		has_version "<app-i18n/scim-anthy-1.3.2" && ewarn "scim-anthy"
		has_version "<app-i18n/uim-1.9.6[anthy]" && ewarn "app-i18n/uim"
		has_version "<dev-libs/m17n-lib-1.8.6-r1[anthy]" && ewarn "dev-libs/m17n-lib"
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
