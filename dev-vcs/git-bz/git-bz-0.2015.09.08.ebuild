# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 pypy )
PYTHON_REQ_USE='sqlite'

inherit python-single-r1

DESCRIPTION="Bugzilla subcommand for git"
HOMEPAGE="http://www.fishsoup.net/software/git-bz/"
SRC_URI="http://dev.gentoo.org/~mgorny/dist/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-vcs/git"

src_configure() {
	# custom script
	./configure --prefix="${EPREFIX}/usr" || die
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
