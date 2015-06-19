# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/vimball/vimball-0.5.1.ebuild,v 1.1 2015/03/29 09:12:46 radhermit Exp $

EAPI=5
PYTHON_COMPAT=( python{3_3,3_4} )
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/radhermit/vimball.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
fi

DESCRIPTION="a command-line vimball archive extractor"
HOMEPAGE="https://github.com/radhermit/vimball"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	esetup.py test
}
