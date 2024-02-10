# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=b3b9fa37ef9fd02471779130a0b53d87fa726ac1

inherit elisp

DESCRIPTION="In-buffer completion front-end"
HOMEPAGE="https://company-mode.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86 ~x64-macos"

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
