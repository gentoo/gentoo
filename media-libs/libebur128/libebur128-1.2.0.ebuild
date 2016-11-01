# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-multilib

DESCRIPTION="A library implementing the EBU R128 loudness standard"
HOMEPAGE="https://github.com/jiixyj/libebur128"
SRC_URI="https://github.com/jiixyj/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://tech.ebu.ch/files/live/sites/tech/files/shared/testmaterial/ebu-loudness-test-setv05.zip )"

LICENSE="MIT"
SLOT="0/2"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs test"

DEPEND="test? ( app-arch/unzip
		media-libs/libsndfile[${MULTILIB_USEDEP}] )"

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_STATIC_LIBS=$(usex static-libs)
		-DENABLE_TESTS=$(usex test)
	)
	cmake-utils_src_configure
}

multilib_src_test() {
	cd "${WORKDIR}"
	"${BUILD_DIR}"/r128-test-library | tee test-results
	grep -c "^FAILED" test-results > /dev/null \
		&& die "At least one test failed"
}
