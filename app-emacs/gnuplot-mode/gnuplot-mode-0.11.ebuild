# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp readme.gentoo-r1

DESCRIPTION="Gnuplot mode for Emacs"
HOMEPAGE="https://github.com/emacs-gnuplot/gnuplot"
SRC_URI="https://github.com/emacs-gnuplot/${PN%-mode}/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${PN%-mode}-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ppc ppc64 ~sparc x86 ~x64-macos"

RDEPEND="
	sci-visualization/gnuplot
"

SITEFILE="50${PN}-gentoo.el"
DOCS=( CHANGELOG.org README.org )
DOC_CONTENTS="Please see ${SITELISP}/${PN}/gnuplot.el for the complete
	documentation."

src_prepare() {
	elisp_src_prepare

	# Erase broken tests
	echo "(provide 'gnuplot-test-context)" > gnuplot-test-context.el || die
}
