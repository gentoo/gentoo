# Copyright 2003-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit multilib-minimal

if [[ "${PV}" == "9999" ]]; then
	inherit autotools git-r3

	EGIT_REPO_URI="https://github.com/kkos/oniguruma"
fi

DESCRIPTION="Regular expression library for different character encodings"
HOMEPAGE="https://github.com/kkos/oniguruma"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/kkos/${PN}/releases/download/v${PV}/onig-${PV}.tar.gz"
fi

LICENSE="BSD-2"
SLOT="0/5"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="crnl-as-line-terminator static-libs"

BDEPEND=""
DEPEND=""
RDEPEND=""

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/onig-${PV}"
fi

DOCS=(AUTHORS HISTORY README{,_japanese} doc/{API,CALLOUTS.API,CALLOUTS.BUILTIN,FAQ,RE}{,.ja} doc/{SYNTAX.md,UNICODE_PROPERTIES})

src_prepare() {
	default

	if [[ "${PV}" == "9999" ]]; then
		eautoreconf
	fi
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--enable-posix-api \
		$(use_enable crnl-as-line-terminator) \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name "*.la" -delete || die
}
