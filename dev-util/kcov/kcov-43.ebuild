# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit cmake edo python-any-r1

DESCRIPTION="Kcov is a code coverage tester for compiled languages, Python and Bash"
HOMEPAGE="https://github.com/SimonKagstrom/kcov/"

if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SimonKagstrom/kcov.git"
else
	SRC_URI="https://github.com/SimonKagstrom/kcov/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2 MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/elfutils
	dev-libs/libunistring:=
	dev-libs/openssl:=
	net-dns/c-ares:=
	net-dns/libidn2:=
	net-libs/libpsl
	net-misc/curl
	net-libs/nghttp2:=
	sys-libs/binutils-libs:=
	sys-libs/zlib
"

BDEPEND="test? ( ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}"

DOCS=(
	doc/
	CONTRIBUTING.md
	INSTALL.md
	README.md
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	if use test; then
		sed -Ei "/skip_python2/ s/= .+/= True/" tests/tools/test_python.py \
			|| die

		echo "add_subdirectory (tests)" >> CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=( -DKCOV_INSTALL_DOCDIR:PATH="share/doc/${PF}" )

	cmake_src_configure
}

src_test() {
	PYTHONPATH="${S}/tests/tools" edo python3 -m libkcov \
		-v \
		"${BUILD_DIR}/src/kcov" \
		"${T}" \
		"${BUILD_DIR}/tests" \
		"${S}"
}

src_install() {
	cmake_src_install

	rm "${ED}/usr/share/doc/${PF}/doc"/{CMakeLists.txt,kcov.1} || die
	rm "${ED}/usr/share/doc/${PF}"/COPYING* || die
}
