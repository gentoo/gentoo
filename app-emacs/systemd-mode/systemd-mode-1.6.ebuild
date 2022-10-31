# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.4

inherit elisp

DESCRIPTION="Major mode for editing systemd units in GNU Emacs"
HOMEPAGE="https://github.com/holomorph/systemd-mode/"
SRC_URI="https://github.com/holomorph/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}"/${P}-directive-txt-files.patch )

DOCS=( README )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed "s|@SITEETC@|${EPREFIX}${SITEETC}/${PN}|" -i systemd.el || die
}

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}

src_install() {
	elisp_src_install

	insinto "${SITEETC}/${PN}"
	doins "${S}"/*.txt
}
