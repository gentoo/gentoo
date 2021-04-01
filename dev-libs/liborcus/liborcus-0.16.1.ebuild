# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit python-single-r1

DESCRIPTION="Standalone file import filter library for spreadsheet documents"
HOMEPAGE="https://gitlab.com/orcus/orcus/blob/master/README.md"

if [[ ${PV} == *9999* ]]; then
	MDDS_SLOT="1/9999"
	EGIT_REPO_URI="https://gitlab.com/orcus/orcus.git"
	inherit git-r3 autotools
else
	MDDS_SLOT="1/1.5"
	SRC_URI="https://kohei.us/files/orcus/src/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64" # no ~x86 to avoid blocked update
fi

LICENSE="MIT"
SLOT="0/0.16" # based on SONAME of liborcus.so
IUSE="python +spreadsheet-model tools"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/boost:=[zlib(+)]
	sys-libs/zlib
	python? ( ${PYTHON_DEPS} )
	spreadsheet-model? ( dev-libs/libixion:${SLOT} )
"
DEPEND="${RDEPEND}
	dev-util/mdds:${MDDS_SLOT}
"

PATCHES=( "${FILESDIR}/${PN}-0.15.4-gcc11.patch" ) # bug 764035

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	[[ ${PV} == *9999 ]] && eautoreconf
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
