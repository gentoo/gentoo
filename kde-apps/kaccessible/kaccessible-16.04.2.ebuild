# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde4-base

DESCRIPTION="Provides accessibility services like focus tracking"
KEYWORDS="~amd64 ~x86"
IUSE="debug +speechd"

DEPEND="speechd? ( app-accessibility/speech-dispatcher )"
RDEPEND=${DEPEND}

src_configure() {
	local mycmakeargs=(
		-DWITH_Speechd=$(usex speechd)
	)
	kde4-base_src_configure
}
