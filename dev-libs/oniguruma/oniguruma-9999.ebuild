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
KEYWORDS=""
IUSE="crnl-as-line-terminator static-libs"

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
		$(use_enable crnl-as-line-terminator) \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name "*.la" -type f -delete || die
}
