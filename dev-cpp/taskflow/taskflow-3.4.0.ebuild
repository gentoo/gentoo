# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Modern C++ Parallel Task Programming"
HOMEPAGE="https://taskflow.github.io"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/taskflow/${PN}.git"
	inherit git-r3
	S="${WORKDIR}/taskflow-${PV}"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~mips ppc ppc64 ~riscv sparc ~x86"
	S="${WORKDIR}/taskflow-${PV}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="examples test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/doctest )"

HTML_DOCS=( docs/. )

PATCHES=(
	"${FILESDIR}"/taskflow-3.4.0-fix_doctest.patch
)

src_prepare() {
	rm -r "${S}/3rd-party" || die "rm failed"
	cmake_src_prepare
}

src_configure() {
	# TODO: enable CUDA via USE flag
	local mycmakeargs=(
		-DTF_BUILD_CUDA=OFF
		-DTF_BUILD_EXAMPLES=$(usex examples)
		-DTF_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}
