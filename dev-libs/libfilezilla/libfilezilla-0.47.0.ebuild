# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="C++ library offering some basic functionality for platform-independent programs"
HOMEPAGE="https://lib.filezilla-project.org/"
SRC_URI="https://download.filezilla-project.org/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0/43" # libfilezilla.so version
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ppc ppc64 ~riscv x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/nettle:0=
	>=net-libs/gnutls-3.5.7:=
	virtual/libcrypt:=
"
DEPEND="${RDEPEND}
	test? ( dev-util/cppunit )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.37.1-pthread.patch
	"${FILESDIR}"/${PN}-0.41.0-gcc13.patch
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if ! test-flag-CXX -std=c++14; then
			eerror "${P} requires C++14-capable C++ compiler. Your current compiler"
			eerror "does not seem to support -std=c++14 option. Please upgrade your compiler"
			eerror "to gcc-4.9 or an equivalent version supporting C++14."
			die "Currently active compiler does not support -std=c++14"
		fi
	fi
}

src_configure() {
	if use ppc || use arm || use hppa; then
		# bug 727652
		append-libs -latomic
	fi

	econf --disable-static
}

src_install() {
	default
	find "${ED}" -type f -name "*.la" -delete || die
}
