# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyoembed/pyoembed-9999.ebuild,v 1.2 2014/08/10 21:17:17 slyfox Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python library for oEmbed with auto-discovered and manually added providers"
HOMEPAGE="https://github.com/rafaelmartins/pyoembed"

SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
if [[ ${PV} = *9999* ]]; then
	SRC_URI=
	KEYWORDS=
	EGIT_REPO_URI="git://github.com/rafaelmartins/pyoembed.git
		https://github.com/rafaelmartins/pyoembed.git"
	inherit git-r3
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}] )"

python_test() {
	esetup.py test
}
