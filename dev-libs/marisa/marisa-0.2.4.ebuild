# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
DISTUTILS_OPTIONAL=1

inherit distutils-r1 eutils

DESCRIPTION="Matching Algorithm with Recursively Implemented StorAge"
HOMEPAGE="https://code.google.com/p/marisa-trie/"
SRC_URI="https://marisa-trie.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc ppc64 ~x86"
IUSE="python doc static-libs cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_ssse3 cpu_flags_x86_sse4_1 cpu_flags_x86_sse4_2 cpu_flags_x86_sse4a cpu_flags_x86_popcnt"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	python? ( dev-lang/swig )"

# implied by --enable switches
REQUIRED_USE="
	cpu_flags_x86_popcnt? ( cpu_flags_x86_sse3 )
	cpu_flags_x86_sse4a? ( cpu_flags_x86_popcnt cpu_flags_x86_sse3 )
	cpu_flags_x86_sse4_2? ( cpu_flags_x86_popcnt cpu_flags_x86_sse4_1 )
	cpu_flags_x86_sse4_1? ( cpu_flags_x86_ssse3 )
	cpu_flags_x86_ssse3? ( cpu_flags_x86_sse3 )
	cpu_flags_x86_sse3? ( cpu_flags_x86_sse2 )
	python? ( ${PYTHON_REQUIRED_USE} )
"

src_prepare() {
	epatch "${FILESDIR}/${P}-python.patch"
	if use python; then
		pushd bindings/python || die
		ln -sf ../marisa-swig.i marisa-swig.i || die
		ln -sf ../marisa-swig.h marisa-swig.h || die
		ln -sf ../marisa-swig.cxx marisa-swig.cxx || die
		distutils-r1_src_prepare
		popd || die
	fi
}

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_enable cpu_flags_x86_sse3 sse3)
		$(use_enable cpu_flags_x86_ssse3 ssse3)
		$(use_enable cpu_flags_x86_sse4_1 sse4.1)
		$(use_enable cpu_flags_x86_sse4_2 sse4.2)
		# sse4 is just an alias to sse4.2
		$(use_enable cpu_flags_x86_sse4a sse4a)
		$(use_enable cpu_flags_x86_popcnt popcnt)
	)
	econf "${myeconfargs[@]}"

	if use python; then
		pushd bindings/python || die
		distutils-r1_src_configure
		popd || die
	fi
}

src_compile() {
	default
	if use python; then
		pushd bindings/python || die
		distutils-r1_src_compile
		popd || die
	fi
}

src_install() {
	default
	if use python; then
		pushd bindings/python || die
		distutils-r1_src_install
		popd || die
	fi
	use doc && dohtml docs/readme.en.html
	prune_libtool_files
}
