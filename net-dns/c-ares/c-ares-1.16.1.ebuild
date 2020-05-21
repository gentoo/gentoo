# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools eutils multilib-minimal

DESCRIPTION="C library that resolves names asynchronously"
HOMEPAGE="https://c-ares.haxx.se/"
SRC_URI="https://${PN}.haxx.se/download/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc64-solaris"
IUSE="static-libs"

# Subslot = SONAME of libcares.so.2
SLOT="0/2"

DOCS=( AUTHORS CHANGES NEWS README.md RELEASE-NOTES TODO )

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/ares_build.h
)

src_prepare() {
	eapply "${FILESDIR}"/${PN}-1.12.0-remove-tests.patch
	eapply_user
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		--enable-nonblocking \
		--enable-symbol-hiding \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name "*.la" -delete || die
}
