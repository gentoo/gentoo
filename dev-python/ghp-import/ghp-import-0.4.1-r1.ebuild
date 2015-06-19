# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ghp-import/ghp-import-0.4.1-r1.ebuild,v 1.2 2015/05/22 03:10:24 patrick Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="Copy your docs directly to the gh-pages branch"
HOMEPAGE="http://github.com/davisp/ghp-import"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="tumbolia"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

python_prepare_all() {
	ebegin 'patching setup.py'
	sed \
		-e '4ifrom codecs import open\n' \
		-e '/LONG_DESC/s/))/), encoding = "utf-8")/' \
		-i setup.py
	STATUS=${?}
	eend ${STATUS}
	[[ ${STATUS} -gt 0 ]] && die

	distutils-r1_python_prepare_all
}
