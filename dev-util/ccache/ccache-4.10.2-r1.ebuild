# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# XXX: We don't use CCACHE_* for these vars like we do in e.g. cmake/libabigail/qemu
# because Portage unsets them. Aaaah!
#
# Generate using https://github.com/thesamesam/sam-gentoo-scripts/blob/main/niche/generate-ccache-docs
# Set to 1 if prebuilt, 0 if not
# (the construct below is to allow overriding from env for script)
: ${MY_DOCS_PREBUILT:=1}

MY_DOCS_PREBUILT_DEV=sam
MY_DOCS_VERSION=$(ver_cut 1-2)
# Default to generating docs (inc. man pages) if no prebuilt; overridden later
# See bug #784815
MY_DOCS_USEFLAG="+doc"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/joelrosdahl.asc
inherit cmake toolchain-funcs flag-o-matic prefix verify-sig

DESCRIPTION="Fast compiler cache"
HOMEPAGE="https://ccache.dev/"
SRC_URI="https://github.com/ccache/ccache/releases/download/v${PV}/${P}.tar.xz"
SRC_URI+=" verify-sig? ( https://github.com/ccache/ccache/releases/download/v${PV}/${P}.tar.xz.asc )"
if [[ ${MY_DOCS_PREBUILT} == 1 ]] ; then
	SRC_URI+=" !doc? ( https://dev.gentoo.org/~${MY_DOCS_PREBUILT_DEV}/distfiles/${CATEGORY}/${PN}/${PN}-${MY_DOCS_VERSION}-docs.tar.xz )"
	MY_DOCS_USEFLAG="doc"
fi

# https://ccache.dev/license.html
# ccache, blake3, NonstdSpan, tl-expected
LICENSE="GPL-3+ || ( CC0-1.0 Apache-2.0 ) Boost-1.0 CC0-1.0"
LICENSE+=" elibc_mingw? ( LGPL-3 ISC PSF-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
# Enable 'static-c++' by default to make 'gcc' ebuild Just Work: bug #761220
IUSE="${MY_DOCS_USEFLAG} redis +static-c++ test"
RESTRICT="!test? ( test )"

# TODO: package NonstdSpan, TlExpected
DEPEND="
	>=app-arch/zstd-1.3.4:=
	!static-c++? (
		>=dev-cpp/cpp-httplib-0.10.6:=
		>=dev-libs/libfmt-8.0.0:=
	)
	>=dev-libs/blake3-1.4.0:=
	>=dev-libs/xxhash-0.8.0
	redis? ( >=dev-libs/hiredis-0.13.3:= )
"
RDEPEND="
	${DEPEND}
	dev-util/shadowman
	sys-apps/gentoo-functions
"
# Needed for eselect calls in pkg_*
IDEPEND="dev-util/shadowman"

# clang-specific tests use dev-libs/elfutils to compare objects for equality.
# Let's pull in the dependency unconditionally.
BDEPEND="
	doc? ( dev-ruby/asciidoctor )
	test? (
		>=dev-cpp/doctest-2.4.6
		dev-libs/elfutils
	)
	verify-sig? ( sec-keys/openpgp-keys-joelrosdahl )
"

DOCS=( doc/{AUTHORS,MANUAL,NEWS}.adoc CONTRIBUTING.md README.md )

PATCHES=(
	"${FILESDIR}"/${PN}-3.5-nvcc-test.patch
	"${FILESDIR}"/${PN}-4.0-objdump.patch
	"${FILESDIR}"/${PN}-4.10-avoid-run-user.patch
)

src_unpack() {
	# Avoid aborting on the doc tarball
	if use verify-sig ; then
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.xz{,.asc}
	fi

	default
}

src_prepare() {
	cmake_src_prepare

	cp "${FILESDIR}"/ccache-config-3 ccache-config || die
	eprefixify ccache-config
}

src_configure() {
	# Mainly used in tests
	tc-export CC OBJDUMP

	local mycmakeargs=(
		-DENABLE_DOCUMENTATION=$(usex doc)
		-DENABLE_TESTING=$(usex test)
		-DDEPS=LOCAL
		-DREDIS_STORAGE_BACKEND=$(usex redis)
	)

	# Avoid dependency on libstdc++.so. Useful for cases when
	# we would like to use ccache to build older gcc which injects
	# into ccache locally built (possibly outdated) libstdc++
	# See bug #761220 for examples.
	#
	# Ideally gcc should not use LD_PRELOAD to avoid this type of failure.
	if use static-c++ ; then
		append-ldflags -static-libstdc++
		mycmakeargs+=(
			-DDEP_CPPHTTPLIB=BUNDLED
			-DDEP_FMT=BUNDLED
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	dobin ccache-config
	insinto /usr/share/shadowman/tools
	newins - ccache <<<"${EPREFIX}/usr/lib/ccache/bin"

	# If USE=doc, there'll be newly generated docs which we install instead.
	if ! use doc && [[ ${MY_DOCS_PREBUILT} == 1 ]] ; then
		doman "${WORKDIR}"/${PN}-${MY_DOCS_VERSION}-docs/doc/*.[0-8]
	fi
}

pkg_prerm() {
	if [[ -z ${REPLACED_BY_VERSION} && -z ${ROOT} ]] ; then
		eselect compiler-shadow remove ccache
	fi
}

pkg_postinst() {
	if [[ -z ${ROOT} ]] ; then
		eselect compiler-shadow update ccache
	fi
}
