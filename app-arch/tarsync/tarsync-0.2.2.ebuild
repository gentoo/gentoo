# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Delta compression suite for using/generating binary patches"
HOMEPAGE="https://github.com/zmedico/tarsync"
SRC_URI="https://github.com/zmedico/tarsync/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86 ~amd64-linux"

DEPEND=">=dev-util/diffball-0.7"
RDEPEND="${DEPEND}"

src_configure() {
	tc-export CC
}

src_install() {
	dobin tarsync #make install doesn't support prefix
	einstalldocs
}
