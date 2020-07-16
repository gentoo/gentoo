# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Auto-complete package"
HOMEPAGE="https://github.com/auto-complete/auto-complete/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+ FDL-1.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
RESTRICT="test"

RDEPEND="app-emacs/popup"
BDEPEND="${RDEPEND}
	doc? ( app-text/pandoc )"

ELISP_REMOVE="${PN}-pkg.el"
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	use doc && emake -C doc
}

src_install() {
	elisp_src_install

	# install dictionaries
	insinto "${SITEETC}/${PN}"
	doins -r dict

	dodoc README.md TODO.md etc/test.txt
	if use doc; then
		docinto html
		dodoc doc/manual.html doc/changes.html doc/style.css doc/*.png
	fi
}
