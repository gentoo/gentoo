# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic

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

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/vasi/${PN}.git"
	inherit git-r3 autotools
	KEYWORDS=""
else
	SRC_URI="https://github.com/vasi/pixz/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

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
