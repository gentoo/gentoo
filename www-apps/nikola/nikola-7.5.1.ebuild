# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/nikola/nikola-7.5.1.ebuild,v 1.1 2015/06/17 04:47:02 yngwin Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit distutils-r1

DESCRIPTION="A static website and blog generator"
HOMEPAGE="http://getnikola.com/"
MY_PN="Nikola"

if [[ ${PV} == *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/ralsina/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT-with-advertising Apache-2.0" # Gutenberg
SLOT="0"
IUSE="assets charts hyphenation ipython jinja markdown"
RESTRICT="test" # needs freezegun, coveralls, and phpserialize

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
	~dev-python/yapsy-1.10.423[${PYTHON_USEDEP}]
	virtual/python-imaging[${PYTHON_USEDEP}]
	assets? ( >=dev-python/webassets-0.10.1[${PYTHON_USEDEP}] )
	charts? ( ~dev-python/pygal-1.7.0[${PYTHON_USEDEP}] )
	hyphenation? ( >=dev-python/pyphen-0.9.1[${PYTHON_USEDEP}] )
	ipython? ( >=dev-python/ipython-1.2.1[${PYTHON_USEDEP}] )
	jinja? ( >=dev-python/jinja-2.7.2[${PYTHON_USEDEP}] )
	markdown? ( >=dev-python/markdown-2.4.0[${PYTHON_USEDEP}] )"
# more options as packages will be added:
#	livereload? ( =dev-python/livereload-2.3.2[${PYTHON_USEDEP}] )
#	micawber? ( >=dev-python/micawber-0.3.0[${PYTHON_USEDEP}] )
#	typogrify? ( >=dev-python/typogrify-2.0.4[${PYTHON_USEDEP}] )

src_install() {
	distutils-r1_src_install

	# hackish way to remove docs that ended up in the wrong place
	rm -rf "${D}"/usr/share/doc/${PN}

	dodoc AUTHORS.txt CHANGES.txt README.rst docs/*.txt
	doman docs/man/*
}
