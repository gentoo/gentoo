# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

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

		# remove cruft
		rm -f html/api-objects.txt || die
		HTML_DOCS=( html/. )
	fi
}

python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all

	dodoc AUTHORS.txt CHANGES.txt README.txt

	if use examples; then
		docinto examples
		dodoc examples/*.{txt,py}
	fi
}
