# Copyright 2014-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=(python{3_6,3_7})
DISTUTILS_OPTIONAL="1"

inherit autotools distutils-r1

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
KEYWORDS="amd64 ~arm64 ppc ~ppc64 ~sparc x86"
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
	"${FILESDIR}/${P}-cpu_features_check.patch"
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

	local options=(
		# Preprocessor macros dependent on CPPFLAGS are checked.
		--enable-sse2
		--enable-sse3
		--enable-ssse3
		--enable-sse4.1
		--enable-sse4.2
		--enable-sse4
		--enable-sse4a
		--enable-popcnt
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
	find "${D}" -name "*.la" -type f -delete || die

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
