# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} pypy )

inherit distutils-r1

MY_PN="Tempita"
MY_P="${MY_PN}-${PV}dev"

DESCRIPTION="A very small text templating language"
HOMEPAGE="https://pypi.org/project/Tempita/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${MY_PN}-${PV}dev"
# Source for tests incomplete
