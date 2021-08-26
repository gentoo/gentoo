# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Half-precision floating-point library"
HOMEPAGE="http://half.sourceforge.net/"
SRC_URI="https://github.com/ROCmSoftwarePlatform/half/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1)"

src_install() {
	cd include || die
	doheader half.hpp
}
