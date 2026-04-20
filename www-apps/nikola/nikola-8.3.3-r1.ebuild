# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 optfeature pypi shell-completion

DESCRIPTION="A static website and blog generator"
HOMEPAGE="https://getnikola.com/"
SRC_URI="$(pypi_sdist_url --no-normalize)"

LICENSE="MIT Apache-2.0 CC0-1.0 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
RESTRICT="test" # needs coveralls

BDEPEND="dev-python/docutils[${PYTHON_USEDEP}]" # needs rst2man to build manpage
RDEPEND="${BDEPEND}
	dev-python/babel[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	dev-python/doit[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	dev-python/natsort[${PYTHON_USEDEP}]
	dev-python/piexif[${PYTHON_USEDEP}]
	dev-python/pillow[jpeg,${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/pyrss2gen[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/unidecode[${PYTHON_USEDEP}]
	dev-python/yapsy[${PYTHON_USEDEP}]"

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
