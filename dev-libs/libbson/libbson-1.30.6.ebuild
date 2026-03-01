# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Generate using https://github.com/thesamesam/sam-gentoo-scripts/blob/main/niche/generate-cmake-docs as a template
# Set to 1 if prebuilt, 0 if not
# (the construct below is to allow overriding from env for script)
: ${LIBBSON_DOCS_PREBUILT:=1}

# Default to generating docs (inc. man pages) if no prebuilt; overridden later
LIBBSON_DOCS_USEFLAG="+man"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/mongo-c-driver.asc

inherit cmake dot-a verify-sig

DESCRIPTION="Library routines related to building,parsing and iterating BSON documents"
HOMEPAGE="https://github.com/mongodb/mongo-c-driver/tree/master/src/libbson"
SRC_URI="
	https://github.com/mongodb/mongo-c-driver/releases/download/${PV}/mongo-c-driver-${PV}.tar.gz
	verify-sig? (
		https://github.com/mongodb/mongo-c-driver/releases/download/${PV}/mongo-c-driver-${PV}.tar.gz.asc
	)
"
if [[ ${LIBBSON_DOCS_PREBUILT} == 1 ]] ; then
	SRC_URI+=" !man? ( https://people.znc.in/~dessa/gentoo/distfiles/${CATEGORY}/${PN}/${PN}-${PV}-docs.tar.xz )"
	LIBBSON_DOCS_USEFLAG="man"
fi

S="${WORKDIR}/mongo-c-driver-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~loong ~ppc ~riscv ~sparc ~x86"
IUSE="examples ${LIBBSON_DOCS_USEFLAG} static-libs"

# tests are covered in mongo-c-driver and are not easily runnable in here
RESTRICT="test"

BDEPEND="
	man? (
		dev-python/docutils
		dev-python/sphinx
	)
	verify-sig? ( sec-keys/openpgp-keys-mongo-c-driver )
"

PATCHES=(
	"${FILESDIR}"/libbson-1.30.6-cmake4.patch
	"${FILESDIR}"/libbson-1.30.6-docutils-0.22.patch
)

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/mongo-c-driver-${PV}.tar.gz{,.asc}
	fi
	default
}

src_prepare() {
	cmake_src_prepare

	# remove doc files
	sed -i '/^\s*install\s*(FILES COPYING NEWS/,/^\s*)/ {d}' CMakeLists.txt || die
}

src_configure() {
	use static-libs && lto-guarantee-fat
	local mycmakeargs=(
		-DENABLE_EXAMPLES=OFF
		-DENABLE_MAN_PAGES="$(usex man ON OFF)"
		-DENABLE_MONGOC=OFF
		-DENABLE_TESTS=OFF
		-DENABLE_STATIC="$(usex static-libs ON OFF)"
		-DENABLE_UNINSTALL=OFF
	)

	cmake_src_configure
}

src_install() {
	if use examples; then
		docinto examples
		dodoc src/libbson/examples/*.c
	fi

	cmake_src_install
	strip-lto-bytecode

	# If USE=man, there'll be newly generated docs which we install instead.
	if ! use man && [[ ${LIBBSON_DOCS_PREBUILT} == 1 ]] ; then
		doman "${WORKDIR}"/${PN}-${PV}-docs/man*/*.[0-8]
	fi
}
