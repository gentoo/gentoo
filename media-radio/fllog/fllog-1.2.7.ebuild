# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Logbook application for amateur radio use"
HOMEPAGE="http://w1hkj.com"
SRC_URI="http://www.w1hkj.com/files/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=x11-libs/fltk-1.1.7"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local -x CONFIG_SHELL=${BASH}

	default
}
