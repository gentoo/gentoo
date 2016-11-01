# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 pypy )

inherit distutils-r1

DESCRIPTION="Management command that generates views, forms, urls, admin, and templates for models"
HOMEPAGE="https://pypi.python.org/pypi/django-baker https://github.com/krisfields/django-baker"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${P}-py3-backport.patch
	"${FILESDIR}"/${P}-py3-iter.patch
)
