# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="A library implementing the EBU R128 loudness standard."
HOMEPAGE="https://github.com/jiixyj/libebur128"
SRC_URI="https://github.com/jiixyj/libebur128/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://tech.ebu.ch/files/live/sites/tech/files/shared/testmaterial/ebu-loudness-test-setv03.zip )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+speex test"

RDEPEND="speex? ( media-libs/speex )"
DEPEND="${RDEPEND}
	test? ( media-libs/libsndfile
		app-arch/unzip )"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_disable speex SPEEXDSP)
		$(cmake-utils_use_enable test TESTS)
	)
	cmake-utils_src_configure
}

src_test() {
	cd "${WORKDIR}"
	"${P}_build"/r128-test-library | tee test-results
	grep -c "^FAILED" test-results > /dev/null \
		&& die "At least one test failed"
}
