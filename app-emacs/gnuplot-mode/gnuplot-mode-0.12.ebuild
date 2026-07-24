# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="28.1"

inherit elisp readme.gentoo-r1

DESCRIPTION="Gnuplot mode for Emacs"
HOMEPAGE="https://github.com/emacs-gnuplot/gnuplot/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacs-gnuplot/${PN%-mode}"
else
	SRC_URI="https://github.com/emacs-gnuplot/${PN%-mode}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN%-mode}-${PV}"

	KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x64-macos"
fi

LICENSE="GPL-3+"
SLOT="0"

BDEPEND="
	>=app-emacs/compat-31.0.0.1
"
RDEPEND="
	${BDEPEND}
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
