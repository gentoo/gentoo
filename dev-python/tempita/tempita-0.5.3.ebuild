# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} pypy )

inherit distutils-r1

MY_PN="Tempita"
MY_P="${MY_PN}-${PV}dev"

DESCRIPTION="A very small text templating language"
HOMEPAGE="http://pythonpaste.org/tempita https://pypi.python.org/pypi/Tempita"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND=""

S="${WORKDIR}/${MY_PN}-${PV}dev"
# Source for tests incomplete
