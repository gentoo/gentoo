# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils elisp-common

DESCRIPTION="A double-entry accounting system with a command-line reporting interface"
HOMEPAGE="http://ledger-cli.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc emacs"

SITEFILE=50${PN}-gentoo-${PV}.el

RDEPEND="
	<dev-libs/boost-1.58:=
	dev-libs/gmp:0
	dev-libs/mpfr:0
	emacs? ( virtual/emacs )
"
DEPEND="${RDEPEND}
	dev-libs/utfcpp
	doc? ( sys-apps/texinfo )
"

DOCS=(README-1ST README.md)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build emacs EMACSLISP)
		$(cmake-utils_use_build doc DOCS)
		$(cmake-utils_use_build doc WEB_DOCS)
		-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/${PF}
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	use doc && cmake-utils_src_make doc
}

src_install() {
	enable_cmake-utils_src_install

	use emacs && elisp-site-file-install "${FILESDIR}/${SITEFILE}"
}

pkg_postinst() {
	use emacs && elisp-site-regen

	einfo
	einfo "Since version 3, vim support is released separately."
	einfo "See https://github.com/ledger/vim-ledger"
	einfo
}

pkg_postrm() {
	use emacs && elisp-site-regen
}

# rainy day TODO:
# - IUSE python
# - IUSE test
