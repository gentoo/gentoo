# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/blohg-tumblelog/blohg-tumblelog-0.2.ebuild,v 1.1 2014/06/12 03:07:40 rafaelmartins Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A blohg extension with reStructuredText directives to run a tumblelog"
HOMEPAGE="https://github.com/rafaelmartins/blohg-tumblelog"

SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
if [[ ${PV} = *9999* ]]; then
	SRC_URI=
	KEYWORDS=
	EGIT_REPO_URI="git://github.com/rafaelmartins/blohg-tumblelog.git
		https://github.com/rafaelmartins/blohg-tumblelog.git"
	inherit git-r3
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="
	>=www-apps/blohg-0.12
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/pyoembed[${PYTHON_USEDEP}]
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
