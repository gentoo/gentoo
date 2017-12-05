# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils

MYP=${P/-20/-snapshot-}

DESCRIPTION="GNU Triangulated Surface Library"
HOMEPAGE="http://gts.sourceforge.net/"
SRC_URI="http://gts.sourceforge.net/tarballs/${MYP}.tar.gz"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="amd64 ~arm64 hppa ppc ppc64 x86 ~amd64-fbsd ~amd64-linux ~x86-linux"
IUSE="doc examples static-libs test"

RDEPEND="dev-libs/glib:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
	test? ( media-libs/netpbm )"

# buggy
RESTRICT=test

S="${WORKDIR}/${MYP}"

AUTOTOOLS_IN_SOURCE_BUILD=1

PATCHES=( "${FILESDIR}"/${PN}-20111025-autotools.patch )

src_compile() {
	autotools-utils_src_compile
	use doc && autotools-utils_src_compile -C doc html
	chmod +x test/*/*.sh || die
}

src_install() {
	use doc && HTML_DOCS=("${AUTOTOOLS_BUILD_DIR}"/doc/html/)
	autotools-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.c
	fi
}
