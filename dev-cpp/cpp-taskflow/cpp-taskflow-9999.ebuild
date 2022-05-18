# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Modern C++ Parallel Task Programming"
HOMEPAGE="https://cpp-taskflow.github.io"
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/cpp-taskflow/${PN}.git"
	inherit git-r3
	S="${WORKDIR}/cpp-taskflow-${PV}"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/taskflow-${PV}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="examples test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-cpp/doctest )"

HTML_DOCS=( docs/. )

PATCHES=(
	"${FILESDIR}"/cpp-taskflow-9999-fix_doctest.patch
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
