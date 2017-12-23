# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils multibuild

DESCRIPTION="A programmer's API and an end-user's toolkit for handling BAM files"
HOMEPAGE="https://github.com/pezmaster31/bamtools"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pezmaster31/bamtools.git"
else
	SRC_URI="https://github.com/pezmaster31/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0/${PV}" # no stable ABI yet
IUSE="static-libs"

RDEPEND="
	>=dev-libs/jsoncpp-1.8.0:=
	sys-libs/zlib:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] &&
		MULTIBUILD_VARIANTS=(
			$(usev static-libs)
			shared
		)
}

src_prepare() {
	# delete bundled libs, just to be safe
	rm -r src/third_party/{gtest-1.6.0,jsoncpp} || die

	cmake-utils_src_prepare
}

src_configure() {
	my_configure() {
		case "${MULTIBUILD_ID}" in
			static*)
				local mycmakeargs=( -DBUILD_SHARED_LIBS=OFF )
				;;
			shared)
				local mycmakeargs=( -DBUILD_SHARED_LIBS=ON )
				;;
			*)
				die "${MULTIBUILD_ID} is not recognized"
				;;
		esac

		cmake-utils_src_configure
	}
	multibuild_foreach_variant my_configure
}

src_compile() {
	multibuild_foreach_variant cmake-utils_src_compile
}

src_install() {
	multibuild_foreach_variant cmake-utils_src_install
}
