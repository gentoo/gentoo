# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="API for implementing ICAP content analysis and adaptation"
HOMEPAGE="https://www.e-cap.org/"
SRC_URI="https://www.e-cap.org/archive/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="1"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc x86"

RDEPEND="!net-libs/libecap:0
	!net-libs/libecap:0.2"

DOCS=( CREDITS NOTICE README change.log )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Horrific autotools failure in generated config.h w/o Bash
	ac_cv_path_AR="$(tc-getAR)" CONFIG_SHELL="${EPREFIX}/bin/bash" econf --disable-static
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
