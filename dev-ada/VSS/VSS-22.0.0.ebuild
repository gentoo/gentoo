# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ADA_COMPAT=( gnat_2021 gcc_12_2_0 )
inherit ada multiprocessing

DESCRIPTION="A high level string and text processing library"
HOMEPAGE="https://github.com/AdaCore/VSS"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3 gcc-runtime-library-exception-3.1"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${ADA_REQUIRED_USE}"

RDEPEND="${ADA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="dev-ada/gprbuild[${ADA_USEDEP}]
	test? ( app-i18n/unicode-data )"

src_prepare() {
	mkdir data
	ln -sf /usr/share/unicode-data data/ucd || die
	default
}

src_compile() {
	emake GPRBUILD_FLAGS="-p -j$(makeopts_jobs) -v"
}

src_test() {
	emake -j1 GPRBUILD_FLAGS="-p -j$(makeopts_jobs) -v" build_tests
	emake check_text check_json
}
