# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4} )
PYTHON_REQ_USE="tk?,xml(+)"

inherit distutils-r1

DESCRIPTION="Natural Language Toolkit"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
HOMEPAGE="http://nltk.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="numpy tk"

RDEPEND="${RDEPEND}
	numpy? ( dev-python/numpy[${PYTHON_USEDEP}] )
	dev-python/pyyaml[${PYTHON_USEDEP}]"
