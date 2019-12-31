# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake

DESCRIPTION="Cross platform unit testing framework for C and C++"
HOMEPAGE="https://github.com/Snaipe/Criterion"
SRC_URI="https://github.com/Snaipe/Criterion/releases/download/v${PV}/${PN}-v${PV}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/nanomsg:="
DEPEND="${RDEPEND}
	test? ( dev-util/cram )"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}-v${PV}"

QA_EXECSTACK="usr/lib*/libcriterion.so*"

src_configure() {
	local mycmakeargs=(
		-DCTESTS="$(usex test ON OFF)"
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use test; then
		cmake_build criterion_tests
	fi
}

src_install() {
	cmake_src_install

	if [[ "/usr/lib" != "/usr/$(get_libdir)" ]]; then
		mkdir -p "${D}/usr/$(get_libdir)" || die
		mv "${D}"/usr/lib/libcriterion.so* "${D}/usr/$(get_libdir)/" || die
	fi

	sed -i "s@${prefix}/lib@${prefix}/$(get_libdir)@g" \
		"${D}/usr/share/pkgconfig/criterion.pc" || die
}
