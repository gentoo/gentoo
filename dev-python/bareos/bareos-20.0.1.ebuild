# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

DESCRIPTION="python bindings for bareos network backup suite"
HOMEPAGE="https://www.bareos.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/Release/${PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${PN}-Release-${PV}/python-bareos
RESTRICT="mirror"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
