# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="A interpreted language mainly used for games"
HOMEPAGE="http://squirrel-lang.org/"
SRC_URI="https://github.com/albertodemichelis/squirrel/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples static-libs"

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIB_DIR="$(get_libdir)" \
		-DINSTALL_INC_DIR=include
		$(usex static-libs '' -DDISABLE_STATIC=YES)
		# /usr/bin/sq is used by app-text/ispell
		# /usr/lib/libsquirrel.so is used by app-shells/squirrelsh
		-DLONG_OUTPUT_NAMES=YES
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dodoc HISTORY

	if use examples; then
		docompress -x /usr/share/doc/${PF}/samples
		dodoc -r samples
	fi
}
