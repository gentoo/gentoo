# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-multilib

DESCRIPTION="A library implementing the EBU R128 loudness standard"
HOMEPAGE="https://github.com/jiixyj/libebur128"
SRC_URI="https://github.com/jiixyj/libebur128/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://tech.ebu.ch/files/live/sites/tech/files/shared/testmaterial/ebu-loudness-test-setv03.zip )"

LICENSE="MIT"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"
IUSE="+speex static-libs test"

RDEPEND="speex? ( media-libs/speex[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	test? ( media-libs/libsndfile[${MULTILIB_USEDEP}]
		app-arch/unzip )"

# Fix tests build. Merged upstream (#39).
PATCHES=( "${FILESDIR}/${P}_fix-tests.patch" )

multilib_src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_disable speex SPEEXDSP)
		$(cmake-utils_use_build static-libs STATIC_LIBS)
		$(cmake-utils_use_enable test TESTS)
	)
	cmake-utils_src_configure
}

multilib_src_test() {
	cd "${WORKDIR}"
	"${BUILD_DIR}"/r128-test-library | tee test-results
	grep -c "^FAILED" test-results > /dev/null \
		&& die "At least one test failed"
}
