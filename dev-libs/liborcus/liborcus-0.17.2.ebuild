# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9,10} )

inherit autotools python-single-r1

DESCRIPTION="Standalone file import filter library for spreadsheet documents"
HOMEPAGE="https://gitlab.com/orcus/orcus/blob/master/README.md"

if [[ ${PV} == *9999* ]]; then
	MDDS_SLOT="1/2.0"
	EGIT_REPO_URI="https://gitlab.com/orcus/orcus.git"
	inherit git-r3
else
	MDDS_SLOT="1/2.0"
	SRC_URI="https://kohei.us/files/orcus/src/${P}.tar.xz"
	KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ~ppc64 x86"
fi

LICENSE="MIT"
SLOT="0/0.17" # based on SONAME of liborcus.so
IUSE="python +spreadsheet-model test tools"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/boost:=[zlib(+)]
	sys-libs/zlib
	python? ( ${PYTHON_DEPS} )
	spreadsheet-model? ( dev-libs/libixion:${SLOT} )
"
DEPEND="${RDEPEND}
	dev-util/mdds:${MDDS_SLOT}
"

PATCHES=(
	"${FILESDIR}"/${P}-clang.patch
	"${FILESDIR}"/${P}-gcc-13.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# bug 713586
	use test && eapply "${FILESDIR}/${PN}-0.17.0-test-fix.patch"

	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
		--disable-werror
		$(use_enable python)
		$(use_enable spreadsheet-model)
		$(use_with tools)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
