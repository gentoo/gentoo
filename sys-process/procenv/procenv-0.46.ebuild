# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="command-line utility to show process environment"
HOMEPAGE="https://github.com/jamesodhunt/procenv"
SRC_URI="https://github.com/jamesodhunt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc64 ~x86"
IUSE="test"

DEPEND="
	virtual/pkgconfig
	test? ( dev-libs/check )
"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-0.45-sysmacros.patch
		"${FILESDIR}"/${PN}-0.45-flags.patch
	)

	default
	eautoreconf
}
