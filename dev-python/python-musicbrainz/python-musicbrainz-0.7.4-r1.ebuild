# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

MY_PN="${PN}2"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python Bindings for the MusicBrainz XML Web Service"
HOMEPAGE="http://musicbrainz.org"
SRC_URI="http://ftp.musicbrainz.org/pub/musicbrainz/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE="doc examples"

RDEPEND="media-libs/libdiscid"
DEPEND="${RDEPEND}
	doc? ( dev-python/epydoc )"
# epydoc is called as a script, so no PYTHON_USEDEP

S="${WORKDIR}/${MY_P}"

python_compile_all() {
	if use doc; then
		einfo "Generation of documentation"
		esetup.py docs
	fi
}

python_test() {
	esetup.py test
}

python_install_all() {
	dodoc AUTHORS.txt CHANGES.txt README.txt

	if use doc; then
		dohtml html/*
	fi

	if use examples; then
		docinto examples
		dodoc examples/*.txt
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.py
	fi
}
