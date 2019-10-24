# Copyright 2003-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit multilib-minimal

MY_P="onig-${PV}"

DESCRIPTION="Regular expression library for different character encodings"
HOMEPAGE="https://github.com/kkos/oniguruma"
SRC_URI="https://github.com/kkos/${PN}/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/5"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="crnl-as-line-terminator static-libs"

PATCHES=(
	"${FILESDIR}"/${PN}-6.9.3-fix-heap-buffer-overflow-php78559.patch
	"${FILESDIR}"/${PN}-6.9.3-fix-heap-buffer-overflow-php78633.patch
)

S="${WORKDIR}/${MY_P}"

DOCS=(AUTHORS HISTORY README{,_japanese} doc/{API,CALLOUTS.API,CALLOUTS.BUILTIN,FAQ,RE}{,.ja} doc/{SYNTAX.md,UNICODE_PROPERTIES})

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable crnl-as-line-terminator) \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name "*.la" -type f -delete || die
}
