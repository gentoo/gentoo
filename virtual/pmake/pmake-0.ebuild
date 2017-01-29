# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Virtual for BSD-like make"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"

RDEPEND="kernel_linux? ( sys-devel/pmake )
	kernel_SunOS? ( sys-devel/pmake )
	kernel_Darwin? ( sys-devel/bsdmake )"
