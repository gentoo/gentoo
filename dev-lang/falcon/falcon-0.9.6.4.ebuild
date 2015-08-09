# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit cmake-utils multilib

MY_P=${P/f/F}

DESCRIPTION="An open source general purpose untyped language written in C++"
HOMEPAGE="http://falconpl.org/"
SRC_URI="http://falconpl.org/project_dl/_official_rel/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug readline"

DEPEND="
	dev-libs/libpcre
	sys-libs/zlib
	readline? ( sys-libs/readline )
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS ChangeLog README RELNOTES"

src_configure() {
	mycmakeargs=(
		-DFALCON_DISABLE_RPATH=ON
		-DFALCON_LIB_DIR=$(get_libdir)
		-DFALCON_SKIP_BISON=ON
		-DFALCON_WITH_MANPAGES=ON
		-DFALCON_WITH_INTERNAL_PCRE=OFF
		-DFALCON_WITH_INTERNAL_ZLIB=OFF
		-DFALCON_WITH_GPL_READLINE=ON
		$(cmake-utils_use readline FALCON_WITH_EDITLINE)
	)
	cmake-utils_src_configure
}

src_test() {
	FALCON_LOAD_PATH=".;${CMAKE_BUILD_DIR}/core/clt"
	for testsuite in "${S}/core/tests/testsuite" "${S}/modules/feathers/tests/testsuite"; do
		"${CMAKE_BUILD_DIR}/core/clt/faltest/faltest" \
			-d "${testsuite}" || die "faltest in ${testsuite} failed"
	done
}
