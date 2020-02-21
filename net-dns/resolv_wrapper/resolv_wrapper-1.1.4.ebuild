# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="A wrapper for DNS name resolving or DNS faking"
HOMEPAGE="https://cwrap.org/resolv_wrapper.html"
SRC_URI="https://ftp.samba.org/pub/cwrap/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND=""
RDEPEND="${DEPEND}"

# Work around a problem with >=dev-util/cmake-3.3.0 (bug #558340)
# Because of this we cannot use cmake-multilib_src_configure() here.
multilib_src_configure() {
	local mycmakeargs=( -DCMAKE_LIBRARY_PATH=/usr/$(get_libdir) )
	cmake-utils_src_configure
}
