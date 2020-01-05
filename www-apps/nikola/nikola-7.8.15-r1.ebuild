# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

MY_PN="Nikola"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A static website and blog generator"
HOMEPAGE="https://getnikola.com/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT Apache-2.0 CC0-1.0 public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE="assets charts ghpages hyphenation ipython jinja watchdog webmedia websocket"
RESTRICT="test" # needs coveralls

DEPEND=">=dev-python/docutils-0.12[${PYTHON_USEDEP}]" # needs rst2man to build manpage
RDEPEND="${DEPEND}
	>=dev-python/blinker-1.3[${PYTHON_USEDEP}]
	>=dev-python/doit-0.29.0[${PYTHON_USEDEP}]
	>=dev-python/logbook-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.3.5[${PYTHON_USEDEP}]
	>=dev-python/mako-1.0[${PYTHON_USEDEP}]
	>=dev-python/markdown-2.4.0[${PYTHON_USEDEP}]
	>=dev-python/natsort-3.5.2[${PYTHON_USEDEP}]
	>=dev-python/piexif-1.0.3[${PYTHON_USEDEP}]
	>=dev-python/pygments-1.6[${PYTHON_USEDEP}]
	>=dev-python/PyRSS2Gen-1.1[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.4[${PYTHON_USEDEP}]
	>=dev-python/setuptools-20.3[${PYTHON_USEDEP}]
	>=dev-python/requests-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/unidecode-0.04.16[${PYTHON_USEDEP}]
	>=dev-python/yapsy-1.11.223[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	assets? ( >=dev-python/webassets-0.10.1[${PYTHON_USEDEP}] )
	charts? ( >=dev-python/pygal-2.0.1[${PYTHON_USEDEP}] )
	ghpages? ( >=dev-python/ghp-import-0.4.1[${PYTHON_USEDEP}] )
	hyphenation? ( >=dev-python/pyphen-0.9.1[${PYTHON_USEDEP}] )
	ipython? ( >=dev-python/ipython-2.0.0[notebook,${PYTHON_USEDEP}] )
	jinja? ( >=dev-python/jinja-2.7.2[${PYTHON_USEDEP}] )
	watchdog? ( ~dev-python/watchdog-0.8.3[${PYTHON_USEDEP}] )
	webmedia? ( >=dev-python/micawber-0.3.0[${PYTHON_USEDEP}] )
	websocket? ( ~dev-python/ws4py-0.3.4[${PYTHON_USEDEP}] )"
#	typography? ( >=dev-python/typogrify-2.0.4[${PYTHON_USEDEP}] ) # needs smartypants

S="${WORKDIR}/${MY_P}"

src_install() {
	distutils-r1_src_install

	# hackish way to remove docs that ended up in the wrong place
	rm -rv "${D}/usr/share/doc/${PN}" || die

	dodoc AUTHORS.txt CHANGES.txt README.rst docs/*.txt
	gunzip "docs/man/${PN}.1.gz" || die
	doman "docs/man/${PN}.1"
}
