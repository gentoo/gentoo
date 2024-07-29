# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Half-precision floating-point library"
HOMEPAGE="https://github.com/ROCm/half"
SRC_URI="https://github.com/ROCm/half/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64"

src_install() {
	insinto /usr/include/half
	doins include/half.hpp
}
