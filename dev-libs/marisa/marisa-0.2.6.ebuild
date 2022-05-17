# Copyright 2014-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_OPTIONAL="1"

inherit autotools distutils-r1 toolchain-funcs

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/s-yata/marisa-trie"
fi

DESCRIPTION="Matching Algorithm with Recursively Implemented StorAge"
HOMEPAGE="https://github.com/s-yata/marisa-trie https://code.google.com/archive/p/marisa-trie/"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/s-yata/marisa-trie/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="|| ( BSD-2 LGPL-2.1+ )"
SLOT="0"
KEYWORDS="amd64 arm64 ~hppa ppc ppc64 ~riscv sparc x86"
IUSE="python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND="python? (
		${PYTHON_DEPS}
		dev-lang/swig
	)"
DEPEND="python? ( ${PYTHON_DEPS} )"
RDEPEND="${DEPEND}"

if [[ "${PV}" != "9999" ]]; then
	S="${WORKDIR}/marisa-trie-${PV}"
fi

PATCHES=(
	"${FILESDIR}/${PN}-0.2.6-riscv_word_size.patch"
)

src_prepare() {
	default
	eautoreconf

	sed -e "s:^\([[:space:]]*\)libraries=:\1include_dirs=[\"../../include\"],\n\1library_dirs=[\"../../lib/marisa/.libs\"],\n&:" -i bindings/python/setup.py || die

	if use python; then
		pushd bindings/python > /dev/null || die
		distutils-r1_src_prepare
		popd > /dev/null || die
	fi
}

src_configure() {
	local -x CPPFLAGS="${CPPFLAGS} ${CXXFLAGS}"

	cpu_instructions_option() {
		local option="${1}"
		local macros="${2}"
		local result="--enable-${option}"
		local macro
		for macro in ${macros}; do
			if ! $(tc-getCC) ${CPPFLAGS} ${CFLAGS} -E -P -dM - < /dev/null 2> /dev/null | grep -Eq "^#define ${macro}([[:space:]]|$)"; then
				result="--disable-${option}"
			fi
		done
		echo "${result}"
	}

	local options=(
		$(cpu_instructions_option sse2 __SSE2__)
		$(cpu_instructions_option sse3 __SSE3__)
		$(cpu_instructions_option ssse3 __SSSE3__)
		$(cpu_instructions_option sse4.1 __SSE4_1__)
		$(cpu_instructions_option sse4.2 __SSE4_2__)
		$(cpu_instructions_option sse4 __POPCNT__ __SSE4_2__)
		$(cpu_instructions_option sse4a __SSE4A__)
		$(cpu_instructions_option popcnt __POPCNT__)
		$(cpu_instructions_option bmi __BMI__)
		$(cpu_instructions_option bmi2 __BMI2__)
		$(use_enable static-libs static)
	)

	econf "${options[@]}"

	if use python; then
		pushd bindings/python > /dev/null || die
		distutils-r1_src_configure
		popd > /dev/null || die
	fi
}

src_compile() {
	default

	if use python; then
		emake -C bindings swig-python
		pushd bindings/python > /dev/null || die
		distutils-r1_src_compile
		popd > /dev/null || die
	fi
}

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die

	(
		docinto html
		dodoc docs/*
	)

	if use python; then
		pushd bindings/python > /dev/null || die
		distutils-r1_src_install
		popd > /dev/null || die
	fi
}
