# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/theano/theano-0.6.0.ebuild,v 1.2 2015/04/08 08:05:13 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 versionator

MYPN=Theano
MYP=${MYPN}-$(replace_version_separator 3 '')

DESCRIPTION="Python library to define and optimize multi-dimensional arrays mathematical expressions"
HOMEPAGE="https://github.com/Theano/Theano"
LICENSE="BSD"

SRC_URI="mirror://pypi/${MYPN:0:1}/${MYPN}/${MYP}.tar.gz"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

SLOT="0"
IUSE="test"

RDEPEND="sci-libs/scipy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${MYP}"

python_test() {
	nosetests || die
}
