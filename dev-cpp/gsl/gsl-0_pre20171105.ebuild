# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

COMMIT="d10ebc6555b627c9d1196076a78467e7be505987"

DESCRIPTION="Guideline Support Library implementation by Microsoft."
HOMEPAGE="https://github.com/Microsoft/GSL"
SRC_URI="https://github.com/Microsoft/${PN}/tarball/${COMMIT} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND=" test? ( >=dev-cpp/catch-1.11.0 )"

# header only library
RDEPEND=""

S="${WORKDIR}/Microsoft-GSL-${COMMIT:0:7}"

src_configure() {
	local mycmakeargs=(
		-DGSL_TEST="$(usex test)"
		)

	cmake-utils_src_configure
}
