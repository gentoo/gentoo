# Copyright 2003-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

if [[ "${PV}" == "9999" ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/kkos/oniguruma"
else
	SRC_URI="https://github.com/kkos/${PN}/releases/download/v${PV}/onig-${PV}.tar.gz"
	S="${WORKDIR}/onig-${PV}"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
fi

DESCRIPTION="Regular expression library for different character encodings"
HOMEPAGE="https://github.com/kkos/oniguruma"

LICENSE="BSD-2"
SLOT="0/5"
IUSE="crnl-as-line-terminator static-libs"

DOCS=( AUTHORS HISTORY README{,_japanese} doc/{API,CALLOUTS.API,CALLOUTS.BUILTIN,FAQ,RE}{,.ja} doc/{SYNTAX.md,UNICODE_PROPERTIES} )

src_prepare() {
	default

	if [[ "${PV}" == "9999" ]]; then
		eautoreconf
	fi
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable crnl-as-line-terminator) \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name "*.la" -type f -delete || die
}
