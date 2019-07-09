# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{5,6,7} )
inherit python-single-r1

DESCRIPTION="General purpose formula parser & interpreter"
HOMEPAGE="https://gitlab.com/ixion/ixion"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/ixion/ixion.git"
	inherit git-r3 autotools
else
	SRC_URI="https://kohei.us/files/ixion/src/${P}.tar.xz"
	KEYWORDS="amd64 ~arm ~arm64 ~ppc ~ppc64 x86"
fi

LICENSE="MIT"
SLOT="0/0.14" # based on SONAME of libixion.so
IUSE="debug python static-libs +threads"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	dev-libs/boost:=
	>=dev-util/mdds-1.4.1:1=
	python? ( ${PYTHON_DEPS} )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable python) \
		$(use_enable static-libs static) \
		$(use_enable threads)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
