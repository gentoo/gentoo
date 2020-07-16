# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for BSD-like make (to be used with get_bmake)"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~ppc-macos ~x86-macos"

RDEPEND="kernel_linux? ( sys-devel/bmake )
	kernel_SunOS? ( sys-devel/bmake )
	kernel_Darwin? ( sys-devel/bsdmake )"
