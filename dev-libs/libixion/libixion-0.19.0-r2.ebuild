# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit autotools python-single-r1

DESCRIPTION="General purpose formula parser & interpreter"
HOMEPAGE="https://gitlab.com/ixion/ixion"

if [[ ${PV} == *9999* ]]; then
	MDDS_SLOT="1/3.0"
	EGIT_REPO_URI="https://gitlab.com/ixion/ixion.git"
	inherit git-r3
else
	MDDS_SLOT="1/2.1"
	SRC_URI="https://kohei.us/files/ixion/src/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~x86"
fi

LICENSE="MIT"
SLOT="0/0.18" # based on SONAME of libixion.so
IUSE="debug python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/boost:=
	dev-util/mdds:${MDDS_SLOT}
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.19.0-gcc15-cstdint.patch # bug 937388
	"${FILESDIR}"/${PN}-0.19.0-fix-win32-ifdef.patch # bug 939807
	"${FILESDIR}"/${PN}-0.19.0-boost-m4.patch # bug 961528
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable debug debug-utils)
		$(use_enable debug log-debug)
		$(use_enable python)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
