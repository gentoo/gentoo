# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit python-single-r1

DESCRIPTION="General purpose formula parser & interpreter"
HOMEPAGE="https://gitlab.com/ixion/ixion"

if [[ ${PV} == *9999 ]]; then
	MDDS_SLOT="1/9999"
	EGIT_REPO_URI="https://gitlab.com/ixion/ixion.git"
	inherit git-r3 autotools
else
	MDDS_SLOT="1/1.5"
	SRC_URI="https://kohei.us/files/ixion/src/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="MIT"
SLOT="0/0.16" # based on SONAME of libixion.so
IUSE="debug python +threads"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/boost:=
	dev-util/mdds:${MDDS_SLOT}
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	dev-libs/spdlog
"

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
		$(use_enable debug)
		$(use_enable python)
		$(use_enable threads)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
