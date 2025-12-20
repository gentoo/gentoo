# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

MY_PV="${PV/_/}"
MY_P="${PN}-${MY_PV}"
DESCRIPTION="A lightweight and flexible command-line JSON processor"
HOMEPAGE="https://stedolan.github.io/jq/"
SRC_URI="https://github.com/jqlang/jq/archive/refs/tags/${MY_P}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-${MY_P}"

LICENSE="MIT icu CC-BY-3.0"
SLOT="0/1"
KEYWORDS="~alpha amd64 ~arm arm64 ~loong ~ppc ppc64 ~riscv ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="+oniguruma static-libs test"

ONIGURUMA_MINPV='>=dev-libs/oniguruma-6.9.10' # Keep this in sync with bundled vendor/oniguruma/
DEPEND="
	>=sys-devel/bison-3.0
	app-alternatives/lex
	oniguruma? ( ${ONIGURUMA_MINPV}:=[static-libs?] )
"
RDEPEND="
	!static-libs? (
		oniguruma? ( ${ONIGURUMA_MINPV}[static-libs?] )
	)
"
PATCHES=(
	"${FILESDIR}"/jq-1.6-r3-never-bundle-oniguruma.patch
)

RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( oniguruma )"

src_prepare() {
	sed -e '/^dist_doc_DATA/d; s:-Wextra ::' -i Makefile.am || die
	printf "#!/bin/sh\\nprintf '%s'\\n\n" "${MY_PV}" > scripts/version || die

	# jq-1.6-r3-never-bundle-oniguruma makes sure we build with the system oniguruma,
	# but the bundled copy of oniguruma still gets eautoreconf'd since it
	# exists; save the cycles by nuking it.
	sed -e '/vendor\/oniguruma/d' -i Makefile.am || die
	rm -rf "${S}"/vendor/oniguruma || die

	default

	sed -i "s/\[jq_version\]/[${MY_PV}]/" configure.ac || die

	eautoreconf
}

src_configure() {
	# TODO: Drop on next release > 1.7.1
	# bug #944014
	append-cflags -std=gnu17

	local econfargs=(
		# don't try to rebuild docs
		--disable-docs
		--enable-valgrind=no
		--disable-maintainer-mode
		$(use_enable static-libs static)
		$(use_with oniguruma oniguruma yes)
	)
	econf "${econfargs[@]}"
}

src_test() {
	if ! LD_LIBRARY_PATH="${S}/.libs" nonfatal emake check; then
		if [[ -r "${S}/test-suite.log" ]]; then
			eerror "Tests failed, outputting testsuite log"
			cat "${S}/test-suite.log"
		fi
		die "Tests failed"
	fi
}

src_install() {
	local DOCS=( AUTHORS NEWS.md README.md SECURITY.md )
	default

	use static-libs || { find "${D}" -name '*.la' -delete || die; }
}
