# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit flag-o-matic

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/vasi/${PN}.git"
	inherit git-r3 autotools
else
	SRC_URI="https://github.com/vasi/pixz/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86"
fi

DESCRIPTION="Parallel Indexed XZ compressor"
HOMEPAGE="https://github.com/vasi/pixz"

LICENSE="BSD-2"
SLOT="0"
IUSE="static"

LIB_DEPEND=">=app-arch/libarchive-2.8:=[static-libs(+)]
	>=app-arch/xz-utils-5[static-libs(+)]"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"
[[ ${PV} == "9999" ]] && DEPEND+=" app-text/asciidoc"

src_prepare() {
	default
	[[ ${PV} == "9999" ]] && eautoreconf
}

src_configure() {
	use static && append-ldflags -static
	append-flags -std=gnu99
	# Workaround silly logic that breaks cross-compiles.
	# https://github.com/vasi/pixz/issues/67
	export ac_cv_file_src_pixz_1=$([[ -f src/pixz.1 ]] && echo yes || echo no)
	econf
}
