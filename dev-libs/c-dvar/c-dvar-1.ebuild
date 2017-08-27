# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson

DESCRIPTION="D-Bus Variant Type-System"
HOMEPAGE="https://github.com/c-util/c-dvar"
SRC_URI="https://github.com/c-util/c-dvar/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

src_install() {
	meson_src_install
	doheader src/c-dvar-type.h
}
