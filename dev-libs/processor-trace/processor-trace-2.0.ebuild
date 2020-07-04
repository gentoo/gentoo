# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Intel(R) Processor Trace decoder library"
HOMEPAGE="https://github.com/01org/processor-trace"
SRC_URI="https://github.com/01org/processor-trace/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/2"
KEYWORDS="-* ~amd64"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="doc? ( app-text/pandoc )"

src_configure() {
	local mycmakeargs=(
		-DMAN=$(usex doc)
		-DPTUNIT=$(usex test)
	)

	cmake-utils_src_configure
}
