# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp readme.gentoo-r1

DESCRIPTION="Gnuplot mode for Emacs"
HOMEPAGE="https://github.com/emacsorphanage/gnuplot"
SRC_URI="https://github.com/emacsorphanage/${PN%-mode}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN%-mode}-${PV}"

LICENSE="GPL-3+ gnuplot"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="doc"

BDEPEND="doc? ( virtual/latex-base )"
RDEPEND="sci-visualization/gnuplot[-emacs(-)]"

PATCHES=( "${FILESDIR}"/${PN}-0.8.0-tests.patch )

SITEFILE="50${PN}-gentoo.el"
DOCS=(CHANGELOG.org README.org)
DOC_CONTENTS="Please see ${SITELISP}/${PN}/gnuplot.el for the complete
	documentation."

src_prepare() {
	elisp_src_prepare

	# Erase broken tests
	echo "(provide 'gnuplot-test-context)" > gnuplot-test-context.el || die
}

src_compile() {
	elisp_src_compile
	use doc && { pdflatex gpelcard || die; }
}

src_install() {
	elisp_src_install
	doinfo gnuplot.info
	use doc && dodoc gpelcard.pdf
}
