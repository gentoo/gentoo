# Copyright 2003-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

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
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="crnl-as-line-terminator static-libs"

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/onig-${PV}"
fi

DOCS=(AUTHORS HISTORY README{,_japanese} doc/{API,CALLOUTS.API,CALLOUTS.BUILTIN,FAQ,RE}{,.ja} doc/{SYNTAX.md,UNICODE_PROPERTIES})

src_prepare() {
	# https://github.com/kkos/oniguruma/issues/167
	# https://github.com/kkos/oniguruma/commit/603f4db48efb49307b7515500496e9e7a92fb779
	sed -e "/^#define MATCH_AT_ERROR_RETURN(err_code)/s/best_len = err_code; goto match_at_end/do {&;} while(0)/" -i src/regexec.c || die

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
	find "${D}" -name "*.la" -type f -delete || die
}
