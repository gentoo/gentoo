# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="C/C++ version of the zxcvbn password strength estimator"
HOMEPAGE="https://github.com/tsyrogit/zxcvbn-c"
SRC_URI="https://github.com/tsyrogit/zxcvbn-c/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64"

PATCHES=(
	"${FILESDIR}"/${P}-gcc15.patch
	"${FILESDIR}"/${PN}-2.5-makefile-install.patch
)

src_install() {
	emake DESTDIR="${ED}" LIBDIR="/usr/$(get_libdir)" install
	rm "${ED}/usr/$(get_libdir)/libzxcvbn.a" || die
}
