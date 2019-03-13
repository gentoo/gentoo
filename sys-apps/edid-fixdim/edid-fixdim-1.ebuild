# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_5 python3_6 python3_7 )
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
