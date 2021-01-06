# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for BSD-like make (to be used with get_bmake)"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~ppc-macos"

RDEPEND="kernel_linux? ( sys-devel/bmake )
	kernel_SunOS? ( sys-devel/bmake )
	kernel_Darwin? ( sys-devel/bsdmake )"
