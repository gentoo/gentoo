# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/nikola/nikola-7.6.0.ebuild,v 1.3 2015/07/27 02:42:23 yngwin Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit distutils-r1

DESCRIPTION="A static website and blog generator"
HOMEPAGE="http://getnikola.com/"
SRC_URI="http://dev.gentoo.org/~yngwin/distfiles/a-study-in-scarlet.txt"
MY_PN="Nikola"

if [[ ${PV} == *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/ralsina/${PN}.git"
else
	SRC_URI+=" mirror://pypi/${MY_PN:0:1}/${MY_PN}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT Apache-2.0 CC0-1.0 public-domain"
SLOT="0"
IUSE="assets charts ghpages hyphenation ipython jinja markdown watchdog webmedia websocket"
RESTRICT="test" # needs coveralls

DEPEND=">=dev-python/docutils-0.12[${PYTHON_USEDEP}]" # needs rst2man to build manpage
RDEPEND="${DEPEND}
	>=dev-python/blinker-1.3[${PYTHON_USEDEP}]
	~dev-python/doit-0.28.0[${PYTHON_USEDEP}]
	>=dev-python/logbook-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.3.5[${PYTHON_USEDEP}]
	>=dev-python/mako-1.0[${PYTHON_USEDEP}]
	>=dev-python/natsort-3.5.2[${PYTHON_USEDEP}]
	>=dev-python/pygments-1.6[${PYTHON_USEDEP}]
	>=dev-python/PyRSS2Gen-1.1[${PYTHON_USEDEP}]
	~dev-python/python-dateutil-2.4.2[${PYTHON_USEDEP}]
	>=dev-python/setuptools-5.4.1[${PYTHON_USEDEP}]
	>=dev-python/requests-2.2.0[${PYTHON_USEDEP}]
	>=dev-python/unidecode-0.04.16[${PYTHON_USEDEP}]
	~dev-python/yapsy-1.11.223[${PYTHON_USEDEP}]
	virtual/python-imaging[${PYTHON_USEDEP}]
	assets? ( >=dev-python/webassets-0.10.1[${PYTHON_USEDEP}] )
	charts? ( ~dev-python/pygal-1.7.0[${PYTHON_USEDEP}] )
	ghpages? ( >=dev-python/ghp-import-0.4.1[${PYTHON_USEDEP}] )
	hyphenation? ( >=dev-python/pyphen-0.9.1[${PYTHON_USEDEP}] )
	ipython? ( >=dev-python/ipython-1.2.1[${PYTHON_USEDEP}] )
	jinja? ( >=dev-python/jinja-2.7.2[${PYTHON_USEDEP}] )
	markdown? ( >=dev-python/markdown-2.4.0[${PYTHON_USEDEP}] )
	watchdog? ( ~dev-python/watchdog-0.8.3[${PYTHON_USEDEP}] )
	webmedia? ( >=dev-python/micawber-0.3.0[${PYTHON_USEDEP}] )
	websocket? ( ~dev-python/ws4py-0.3.4[${PYTHON_USEDEP}] )"
#	typography? ( >=dev-python/typogrify-2.0.4[${PYTHON_USEDEP}] ) # needs smartypants

src_prepare() {
	# replace Gutenberg licensed version with our public domain version (bug #552372)
	rm nikola/data/samplesite/stories/a-study-in-scarlet.txt || die
	cp "${DISTDIR}"/a-study-in-scarlet.txt nikola/data/samplesite/stories/ || die
}

src_install() {
	distutils-r1_src_install

	# hackish way to remove docs that ended up in the wrong place
	rm -rf "${D}"/usr/share/doc/${PN}

	dodoc AUTHORS.txt CHANGES.txt README.rst docs/*.txt
	doman docs/man/${PN}.1.gz
}
