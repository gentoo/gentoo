# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
#DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python package for the generation of encapsulated PostScript figures"
HOMEPAGE="
	https://github.com/pyx-project/pyx
	https://pyx-project.org/
	https://pypi.org/project/PyX/"
# git 0f28343
SRC_URI="https://dev.gentoo.org/~grozin/${P}.tar.bz2
	test? ( https://www.w3.org/Graphics/SVG/Test/20110816/archives/W3C_SVG_11_TestSuite.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]
	virtual/tex-base
	virtual/latex-base
	dev-texlive/texlive-basic"

BDEPEND="${RDEPEND}
	doc? (
		$(python_gen_any_dep '
			dev-python/sphinx[latex,${PYTHON_USEDEP}]
			dev-python/sphinx_selective_exclude[${PYTHON_USEDEP}]
		')
	)
	test? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_selective_exclude[${PYTHON_USEDEP}]
		dev-python/testfixtures[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}"/pyx-0.14.1-unicode-latex.patch )

python_check_deps() {
	use doc || return 0
	python_has_version "dev-python/sphinx[latex,${PYTHON_USEDEP}]" \
		"dev-python/sphinx_selective_exclude[${PYTHON_USEDEP}]"
}

src_unpack() {
	unpack "${P}.tar.bz2"

	if use test; then
		mkdir "${S}"/test/svg/suite || die
		cd "${S}"/test/svg/suite || die
		unpack W3C_SVG_11_TestSuite.tar.gz
	fi
}

src_prepare() {
	sed -i \
		-e 's/^build_t1code=.*/build_t1code=1/' \
		-e 's/^build_pykpathsea=.*/build_pykpathsea=1/' \
		setup.cfg || die "setup.cfg fix failed"
	# stop test suite from downloading files
	sed -i \
		-e '/suite:/,$d' test/svg/Makefile || die
	distutils-r1_src_prepare
}

python_compile_all() {
	if use doc; then
		local -x VARTEXFONTS="${T}"/fonts
		emake -C "${S}"/manual latexpdf
		emake -C "${S}"/faq latexpdf
	fi
}

python_test() {
	emake -C test
}

python_install_all() {
	use doc && dodoc manual/_build/latex/manual.pdf faq/_build/latex/pyxfaq.pdf
	distutils-r1_python_install_all
}
