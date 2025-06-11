# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10,11,12,13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 optfeature pypi shell-completion

DESCRIPTION="A static website and blog generator"
HOMEPAGE="https://getnikola.com/"
SRC_URI="$(pypi_sdist_url --no-normalize)"

LICENSE="MIT Apache-2.0 CC0-1.0 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
RESTRICT="test" # needs coveralls

BDEPEND=">=dev-python/docutils-0.13[${PYTHON_USEDEP}]" # needs rst2man to build manpage
RDEPEND="${BDEPEND}
	>=dev-python/babel-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/blinker-1.3[${PYTHON_USEDEP}]
	>=dev-python/doit-0.32[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.3.5[${PYTHON_USEDEP}]
	>=dev-python/mako-1.0[${PYTHON_USEDEP}]
	>=dev-python/markdown-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/natsort-3.5.2[${PYTHON_USEDEP}]
	>=dev-python/piexif-1.0.3[${PYTHON_USEDEP}]
	>=dev-python/pygments-1.6[${PYTHON_USEDEP}]
	>=dev-python/pyrss2gen-1.1[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/setuptools-67.2.0[${PYTHON_USEDEP}]
	>=dev-python/unidecode-0.04.16[${PYTHON_USEDEP}]
	>=dev-python/yapsy-1.11.223[${PYTHON_USEDEP}]
	dev-python/pillow[jpeg,${PYTHON_USEDEP}]
	dev-python/cloudpickle[${PYTHON_USEDEP}]"

PATCHES=("${FILESDIR}/${P}-site-packages.patch")

python_compile_all() {
	nikola tabcompletion --shell=bash > ${PN}.bashcomp || die
	nikola tabcompletion --shell=zsh > ${PN}.zshcomp || die
}

src_install() {
	distutils-r1_src_install

	# hackish way to remove docs that ended up in the wrong place
	rm -r "${ED}/usr/share/doc/${PN}" || die

	dodoc AUTHORS.txt CHANGES.txt README.rst docs/*.rst
	gunzip "${ED}/usr/share/man/man1/${PN}.1.gz" || die

	newbashcomp ${PN}.bashcomp ${PN}
	newzshcomp ${PN}.zshcomp _${PN}
}

pkg_postinst() {
	optfeature "chart generation" dev-python/pygal
	optfeature "hyphenation support" dev-python/pyphen
	optfeature "notebook compilation and LESS support" dev-python/ipython
	optfeature "alternative templating engine to Mako" dev-python/jinja2
	optfeature "built-in web server support" dev-python/aiohttp
	optfeature "monitoring file system events" dev-python/watchdog
	optfeature "extracting metadata from web media links" dev-python/micawber
}
