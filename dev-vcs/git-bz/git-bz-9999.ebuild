# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 pypy )
PYTHON_REQ_USE='sqlite'

EGIT_REPO_URI="git://git.fishsoup.net/${PN}
	http://git.fishsoup.net/cgit/${PN}"
inherit git-r3 python-single-r1

DESCRIPTION="Bugzilla subcommand for git"
HOMEPAGE="http://www.fishsoup.net/software/git-bz/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-vcs/git"
DEPEND="app-text/asciidoc
	app-text/xmlto"

src_configure() {
	# custom script
	./configure --prefix="${EPREFIX}/usr" || die
}

src_compile() {
	emake ${PN}.1
}

src_install() {
	default
	python_fix_shebang "${ED%/}"/usr/bin/${PN}
}

pkg_postinst() {
	if ! has_version dev-python/pycrypto; then
		elog "For Chrome/-ium cookie decryption support, please install:"
		elog "  dev-python/pycrypto"
	fi
}
