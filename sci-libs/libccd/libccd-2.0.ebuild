# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libccd/libccd-2.0.ebuild,v 1.2 2014/10/24 08:01:04 aballier Exp $

EAPI=5

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="http://github.com/danfis/libccd"
fi

inherit ${SCM} cmake-utils toolchain-funcs

if [ "${PV#9999}" != "${PV}" ] ; then
	KEYWORDS=""
	SRC_URI=""
else
	KEYWORDS="~amd64 ~arm"
	SRC_URI="http://libccd.danfis.cz/files/${P}.tar.gz"
fi

DESCRIPTION="Library for collision detection between two convex shapes"
HOMEPAGE="http://libccd.danfis.cz/"
LICENSE="BSD"
SLOT="0"
IUSE="double doc"

RDEPEND=""
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx )"
DOCS=( README )

src_configure() {
	local mycmakeargs=(
		"-DCCD_DOUBLE=$(usex double TRUE FALSE)"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc ; then
		cd "${S}/doc"
		emake SPHINXBUILD=sphinx-build html
	fi
}

src_test() {
	cd src/testsuites
	tc-export CC
	LDFLAGS="-L${BUILD_DIR} ${LDFLAGS}" \
	LD_LIBRARY_PATH="${BUILD_DIR}:${LD_LIBRARY_PATH}" \
		emake check
}

src_install() {
	cmake-utils_src_install
	use doc && dohtml -r "${S}/doc/_build/html/"*
}
