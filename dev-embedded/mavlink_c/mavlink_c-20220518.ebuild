# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MY_PN="c_library_v2"
MY_P="${MY_PN}-${PV}"

# sadly no upstream tags or releases from gh for ref snapshots
GIT_COMMIT="241907e288b43513b28f83595d0de3b2088bce0f"
SRC_URI="https://github.com/mavlink/${MY_PN}/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
S="${WORKDIR}"

DESCRIPTION="Official reference C library for the v2 protocol"
HOMEPAGE="https://github.com/mavlink/c_library_v2"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RESTRICT="test"

src_install() {
	einfo "Installing base headers required for v2 reference library"
	mkdir -p "${MY_PN}-${GIT_COMMIT}"/message_definitions/v1.0
	mv "${MY_PN}-${GIT_COMMIT}"/message_definitions/*.xml \
		 "${MY_PN}-${GIT_COMMIT}"/message_definitions/v1.0/
	mv "${MY_PN}-${GIT_COMMIT}" mavlink

	doheader -r mavlink
}
