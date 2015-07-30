# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/workerpool/workerpool-0.9.4.ebuild,v 1.1 2015/07/30 07:01:30 patrick Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="Module for distributing jobs to a pool of worker threads"
HOMEPAGE="http://github.com/shazow/workerpool"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test examples"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	nosetests -v test || die
}

python_install_all() {
	if use examples; then
		docompress -x usr/share/doc/${P}/samples
		insinto usr/share/doc/${P}/
		doins -r samples
	fi
}
