# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=16ffeba5ef96c4c8e0cd39860b5402e25e304601
NEED_EMACS=25.1

inherit elisp

DESCRIPTION="In-buffer completion front-end"
HOMEPAGE="https://company-mode.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}"/${PN}-company-icons-root.patch )

SITEFILE="50${PN}-gentoo.el"
DOCS=( CONTRIBUTING.md README.md NEWS.md )

src_prepare() {
	elisp_src_prepare

	sed "s|@SITEETC@|${SITEETC}/${PN}|" -i company.el || die
}

src_compile() {
	elisp_src_compile

	emake -C doc company.info
}

src_test() {
	emake test-batch
}

src_install() {
	elisp_src_install

	insinto ${SITEETC}/${PN}
	doins -r icons

	doinfo doc/company.info
}
