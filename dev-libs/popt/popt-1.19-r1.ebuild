# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multilib-minimal libtool

DESCRIPTION="Parse Options - Command line parser"
HOMEPAGE="https://github.com/rpm-software-management/popt"
SRC_URI="http://ftp.rpm.org/${PN}/releases/${PN}-1.x/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="nls static-libs"

RDEPEND="nls? ( >=virtual/libintl-0-r1[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( >=sys-devel/gettext-0.19.8 )"

src_prepare() {
	default

	# Unclear what the background to this is, perhaps
	# https://gitlab.exherbo.org/exherbo/arbor/-/commit/5545d22d3493279acf7a55246179f818ef22f5fa
	sed -i -e 's:lt-test1:test1:' tests/testit.sh || die

	elibtoolize
}

multilib_src_configure() {
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	local myeconfargs=(
		--disable-werror
		$(use_enable static-libs static)
		$(use_enable nls)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs

	find "${ED}" -type f -name "*.la" -delete || die
}
