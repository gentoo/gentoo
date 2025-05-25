# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=${PV/_/-}

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{10..13} )

inherit cmake distutils-r1 toolchain-funcs

DESCRIPTION="A lightweight multi-platform, multi-architecture CPU emulator framework"
HOMEPAGE="https://www.unicorn-engine.org"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/unicorn-engine/unicorn"
else
	SRC_URI="https://github.com/unicorn-engine/unicorn/archive/${MY_PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86"
fi

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="BSD-2 GPL-2 LGPL-2.1"
SLOT="0/2"
IUSE="logging python static-libs test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="${PYTHON_DEPS}
	dev-libs/glib:2"
RDEPEND="python? ( ${PYTHON_DEPS} )"
BDEPEND="virtual/pkgconfig
	python? (
		${DISTUTILS_DEPS}
		>=dev-python/setuptools-scm-8[${PYTHON_USEDEP}]
	)"

RESTRICT="!test? ( test )"

UNICORN_TARGETS="x86 arm aarch64 riscv mips sparc m68k ppc s390x tricore"

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.3-strings.patch
)

wrap_python() {
	if use python; then
		# src_prepare
		# Do not compile C extensions
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

	if use elibc_musl ; then
		QA_CONFIG_IMPL_DECL_SKIP=( malloc_trim )
	fi
}

src_configure(){
	tc-export STRINGS

	local mycmakeargs=(
		-DUNICORN_ARCH="${UNICORN_TARGETS// /;}"
		-DUNICORN_LOGGING=$(usex logging)
		-DUNICORN_LEGACY_STATIC_ARCHIVE=$(usex static-libs)
		-DZIG_BUILD=OFF
	)

	cmake_src_configure

	wrap_python ${FUNCNAME}
}

src_compile() {
	cmake_src_compile

	wrap_python ${FUNCNAME}
}

src_test() {
	cmake_src_install

	wrap_python ${FUNCNAME}
}

python_test() {
#	export LD_LIBRARY_PATH="${ED}/usr/$(get_libdir):${LD_LIBRARY_PATH}"
	for f in tests/test_*.py; do
		if test -x ${f}; then
			LD_LIBRARY_PATH="${ED}/usr/$(get_libdir)" ${EPYHTON} ${f} || die
		fi
	done
}

src_install() {
	cmake_src_install

	wrap_python ${FUNCNAME}
}
