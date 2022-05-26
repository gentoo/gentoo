# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MY_PN="Nikola"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A static website and blog generator"
HOMEPAGE="https://getnikola.com/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT Apache-2.0 CC0-1.0 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="assets charts hyphenation ipython jinja server watchdog webmedia"
REQUIRED_USE="server? ( watchdog )"
RESTRICT="test" # needs coveralls

DEPEND=">=dev-python/docutils-0.13[${PYTHON_USEDEP}]" # needs rst2man to build manpage
RDEPEND="${DEPEND}
	>=dev-python/Babel-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/blinker-1.3[${PYTHON_USEDEP}]
	>=dev-python/doit-0.32[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.3.5[${PYTHON_USEDEP}]
	>=dev-python/mako-1.0[${PYTHON_USEDEP}]
	>=dev-python/markdown-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/natsort-3.5.2[${PYTHON_USEDEP}]
	>=dev-python/piexif-1.0.3[${PYTHON_USEDEP}]
	>=dev-python/pygments-1.6[${PYTHON_USEDEP}]
	>=dev-python/PyRSS2Gen-1.1[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.6.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/unidecode-0.04.16[${PYTHON_USEDEP}]
	>=dev-python/yapsy-1.11.223[${PYTHON_USEDEP}]
	dev-python/pillow[jpeg,${PYTHON_USEDEP}]
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	assets? ( >=dev-python/webassets-0.10.1[${PYTHON_USEDEP}] )
	charts? ( >=dev-python/pygal-2.0.1[${PYTHON_USEDEP}] )
	hyphenation? ( >=dev-python/pyphen-0.9.1[${PYTHON_USEDEP}] )
	ipython? ( >=dev-python/ipython-2.0.0[notebook,${PYTHON_USEDEP}] )
	jinja? ( >=dev-python/jinja-2.7.2[${PYTHON_USEDEP}] )
	server? ( dev-python/aiohttp[${PYTHON_USEDEP}] )
	watchdog? ( >=dev-python/watchdog-0.8.3[${PYTHON_USEDEP}] )
	webmedia? ( >=dev-python/micawber-0.3.0[${PYTHON_USEDEP}] )"

src_install() {
	distutils-r1_src_install

	# hackish way to remove docs that ended up in the wrong place
	rm -r "${ED}/usr/share/doc/${PN}" || die

	dodoc AUTHORS.txt CHANGES.txt README.rst docs/*.rst
	gunzip "${ED}/usr/share/man/man1/${PN}.1.gz" || die
}
