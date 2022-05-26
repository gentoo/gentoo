# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Daemon for communication with Viessmann Vito heatings"
HOMEPAGE="https://github.com/openv/vcontrold/"
SRC_URI="https://github.com/openv/vcontrold/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+man +vclient vsim"

RDEPEND="dev-libs/libxml2:2"
DEPEND="${RDEPEND}
	man? ( dev-python/docutils )"

src_prepare() {
	sed "s/@VERSION@/${PV}/" "src/version.h.in" \
		> "src/version.h" || die "Setting version failed"

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DMANPAGES="$(usex man)"
		-DVCLIENT="$(usex vclient)"
		-DVSIM="$(usex vsim)"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	doinitd "${FILESDIR}/vcontrold"
	insinto /etc/vcontrold/
	doins -r xml
}
