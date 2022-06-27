# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=${PV/_/-}

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{9..10} )
inherit cmake distutils-r1

DESCRIPTION="A lightweight multi-platform, multi-architecture CPU emulator framework"
HOMEPAGE="https://www.unicorn-engine.org"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/unicorn-engine/unicorn"
else
	SRC_URI="https://github.com/unicorn-engine/unicorn/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="BSD-2 GPL-2 LGPL-2.1"
SLOT="0/2"
IUSE="python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="${PYTHON_DEPS}
	dev-libs/glib:2"
RDEPEND="python? ( ${PYTHON_DEPS} )"
BDEPEND="virtual/pkgconfig
	python? ( ${DISTUTILS_DEPS} )"

UNICORN_TARGETS="x86 arm aarch64 riscv mips sparc m68k ppc s390x"

wrap_python() {
	if use python; then
		# src_prepare
		# do not compile C extensions
		export LIBUNICORN_PATH=1

		pushd bindings/python >/dev/null || die
		distutils-r1_${1} "$@"
		popd >/dev/null || die
	fi
}

src_prepare() {
	# Build from sources
	rm -r bindings/python/prebuilt || die "failed to remove prebuilt files"

	cmake_src_prepare
	wrap_python ${FUNCNAME}
}

src_configure(){
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex !static-libs)
		-DUNICORN_ARCH="${UNICORN_TARGETS// /;}"
	)

	cmake_src_configure

	wrap_python ${FUNCNAME}
}

src_compile() {
	cmake_src_compile

	wrap_python ${FUNCNAME}
}

src_install() {
	cmake_src_install

	wrap_python ${FUNCNAME}
}
