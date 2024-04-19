# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Fast C++ logging library"
HOMEPAGE="https://github.com/gabime/spdlog"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gabime/${PN}"
else
	SRC_URI="https://github.com/gabime/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

fi

LICENSE="MIT"
SLOT="0/1"
IUSE="test static-libs"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
"

DEPEND="
	>=dev-libs/libfmt-9.1.0-r2[${MULTILIB_USEDEP}]
"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-force_external_fmt.patch"
	"${FILESDIR}/${PN}-fmt-10.patch"
	"${FILESDIR}/${PN}-musl-1.2.4.patch"
)

multilib_src_prepare() {
	cmake_src_prepare
	rm -r include/spdlog/fmt/bundled || die "Failed to delete bundled libfmt"
}

multilib_src_configure() {
	local mycmakeargs=(
		-DSPDLOG_BUILD_BENCH=no
		-DSPDLOG_BUILD_EXAMPLE=no
		-DSPDLOG_FMT_EXTERNAL=yes
		-DSPDLOG_BUILD_SHARED=$(usex static-libs)
		-DSPDLOG_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
