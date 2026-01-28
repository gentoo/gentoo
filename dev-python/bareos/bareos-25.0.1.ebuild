# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="python bindings for bareos network backup suite"
HOMEPAGE="https://www.bareos.com/"
SRC_URI="https://github.com/${PN}/${PN}/archive/Release/${PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${PN}-Release-${PV}/python-bareos

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror test"
