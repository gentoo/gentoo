# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit python-single-r1

DESCRIPTION="Tool to fix screen dimensions in EDID data dumps"
HOMEPAGE="https://github.com/mgorny/edid-fixdim"
SRC_URI="https://github.com/mgorny/edid-fixdim/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}"

src_install() {
	python_doscript edid-fixdim
}
