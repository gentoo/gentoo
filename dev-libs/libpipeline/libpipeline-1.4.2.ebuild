# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit autotools-utils

DESCRIPTION="a pipeline manipulation library"
HOMEPAGE="http://libpipeline.nongnu.org/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="static-libs test"

DEPEND="virtual/pkgconfig
	test? ( dev-libs/check )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.1-gnulib-cygwin-sys_select.patch
	"${FILESDIR}"/${PN}-1.4.1-gnulib-darwin-program_name.patch
)
