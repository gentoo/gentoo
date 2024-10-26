# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )
inherit guile autotools

MY_COMMIT=538ffea25ca69d9f3ee17033534ba03cc27ba468

DESCRIPTION="Implementation of CommonMark for Guile"
HOMEPAGE="https://github.com/OrangeShark/guile-commonmark"
SRC_URI="https://github.com/OrangeShark/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
REQUIRED_USE="${GUILE_REQUIRED_USE}"

RDEPEND="${GUILE_DEPS}"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	guile_src_prepare
	eautoreconf
}
