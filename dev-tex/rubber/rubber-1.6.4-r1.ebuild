# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1

if [[ ${PV} == "9999" ]] || [[ -n "${EGIT_COMMIT_ID}" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/latex-rubber/${PN}.git"
else
	# NOTE: Cannot be "PYPI_PN=latex-rubber" + "inherit pypi" due to missing tests
	SRC_URI="https://gitlab.com/latex-rubber/${PN}/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~ppc ~riscv ~x86"
fi

DESCRIPTION="A LaTeX wrapper for automatically building documents"
HOMEPAGE="https://gitlab.com/latex-rubber/rubber"

LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/latex-base"

# Test dependencies:
# - app-text/texlive-core for rubber's 'cweave' test
# - dev-lang/R for rubber's 'knitr' test (requires knitr R library, currently disabled)
# - dev-texlive/texlive-latexextra for rubber's 'combine' test (currently disabled)
BDEPEND="
	${RDEPEND}
	virtual/texi2dvi
	test? (
		app-text/ghostscript-gpl
		app-text/texlive-core
		dev-tex/biber
		dev-tex/biblatex
		dev-tex/glossaries
		dev-tex/latex-beamer
		$(python_gen_cond_dep 'dev-tex/pythontex[${PYTHON_USEDEP}]')
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-pstricks
		media-gfx/asymptote
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.4-pythontex.patch
)

pkg_setup() {
	# https://bugs.gentoo.org/727996
	export VARTEXFONTS="${T}"/fonts
}

python_test() {
	cd tests || die

	# Disable the broken 'combine' test as it uses the 'combine' as a
	# latex package when it is only a document class (probably only in
	# newer versions of combine). Also note that this tests works
	# under debian 'buster'. TODO: Look into potential modifications
	# done by debian.
	touch combine/disable || die

	# This test does not work under Gentoo nor Debian 'buster'.
	# TODO: Investigate why it does not work.
	touch cweb-latex/disable || die

	# TODO: Investigate why the following are failing.
	touch fig2dev-dvi/disable || die
	touch fig2dev-path/disable || die
	touch fig2dev-path-inplace/disable || die
	touch fig2dev-path-into/disable || die
	touch graphicx-dotted-files/disable || die
	touch hooks-input-file/disable || die
	touch knitr/disable || die

	# Even tough metapost is available, those tests fail on Gentoo
	# (while they succeed on Debian 'buster').
	# TODO: Determine why.
	# ERROR:mpost:I can't read MetaPost's log file, this is wrong.
	touch metapost/disable || die
	# expected error message not reported by Rubber
	touch metapost-error/disable || die
	# ERROR:mpost:I can't read MetaPost's log file, this is wrong.
	touch metapost-input/disable || die

	./run.sh * || die "Tests failed with ${EPYTHON}"
}

python_install() {
	local my_install_args=(
		--mandir="${EPREFIX}/usr/share/man"
		--infodir="${EPREFIX}/usr/share/info"
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
	)

	distutils-r1_python_install "${my_install_args[@]}"
}

src_install() {
	distutils-r1_src_install

	# Fix file misplacements
	dodir /usr/share/man/fr
	mv "${D}"/usr/share/{doc/man-fr,man/fr/man1} || die
	mv "${D}"/usr/share/{doc/man-en,man/man1} || die
	mv "${D}"/usr/share/doc/{rubber.*,${PF}/} || die
}
