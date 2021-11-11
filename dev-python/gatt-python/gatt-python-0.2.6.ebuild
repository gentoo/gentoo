# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_9 )

inherit distutils-r1

DESCRIPTION="Pythonic DBus library"
HOMEPAGE="https://github.com/LEW21/pydbus"
SRC_URI="https://github.com/getsenic/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
SLOT="0"

RDEPEND="
		net-wireless/bluez
"
