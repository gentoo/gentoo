# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="In-buffer completion front-end"
HOMEPAGE="https://company-mode.github.io/
	https://github.com/company-mode/company-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"
fi

LICENSE="GPL-3+"
SLOT="0"

ELISP_REMOVE="
	test/elisp-tests.el
"
PATCHES=(
	"${FILESDIR}/${PN}-company-icons-root.patch"
)

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

	insinto "${SITEETC}/${PN}"
	doins -r icons

	doinfo doc/company.info
}
