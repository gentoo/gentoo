# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

GIT_ECLASS=""
if [[ ${PV} = *9999* ]]; then
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="git://github.com/rafaelmartins/marrie.git
		https://github.com/rafaelmartins/marrie.git"
fi

inherit distutils-r1 ${GIT_ECLASS}

DESCRIPTION="A simple podcast client that runs on the Command Line Interface"
HOMEPAGE="https://github.com/rafaelmartins/marrie"

SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
if [[ ${PV} = *9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
fi

LICENSE="BSD"
SLOT="0"
IUSE="doc"

RDEPEND="
	dev-python/setuptools
	>=dev-python/feedparser-5.1.3"
DEPEND="${RDEPEND}
	doc? ( dev-python/docutils )"

src_compile() {
	distutils-r1_src_compile
	if use doc; then
		rst2html.py README.rst marrie.html || die "rst2html.py failed"
	fi
}

src_install() {
	distutils-r1_src_install
	if use doc; then
		dohtml marrie.html
	fi
}

pkg_postinst() {
	distutils-r1_pkg_postinst
	elog
	elog "You'll need a media player and a file downloader."
	elog "Recommended packages: net-misc/wget and media-video/mplayer"
	elog
}
