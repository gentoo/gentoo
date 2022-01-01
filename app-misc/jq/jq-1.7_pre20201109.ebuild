# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

COMMIT_HASH="a17dd3248a666d01be75f6b16be37e80e20b0954"

DESCRIPTION="A lightweight and flexible command-line JSON processor"
HOMEPAGE="https://stedolan.github.io/jq/"
#SRC_URI="https://github.com/stedolan/jq/releases/download/${P}/${P}.tar.gz"
SRC_URI="https://github.com/stedolan/jq/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="MIT CC-BY-3.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ppc64 x86 ~amd64-linux ~x64-macos"
IUSE="+oniguruma static-libs test"

ONIGURUMA_MINPV='>=dev-libs/oniguruma-6.1.3' # Keep this in sync with bundled modules/oniguruma/
DEPEND="
	>=sys-devel/bison-3.0
	sys-devel/flex
	oniguruma? ( ${ONIGURUMA_MINPV}:=[static-libs?] )
"
RDEPEND="
	!static-libs? (
		oniguruma? ( ${ONIGURUMA_MINPV}[static-libs?] )
	)
"
PATCHES=(
	"${FILESDIR}"/jq-1.6-r3-never-bundle-oniguruma.patch
	"${FILESDIR}"/jq-1.7-runpath.patch
	"${FILESDIR}"/jq-1.7-warnings.patch
	"${FILESDIR}"/jq-1.7-visible-null.patch
	# https://bugs.gentoo.org/776385
	"${FILESDIR}"/jq-1.7_pre20201109-no-git-bdep.patch
)

RESTRICT="!test? ( test )"
REQUIRED_USE="test? ( oniguruma )"

src_prepare() {
	sed -e '/^dist_doc_DATA/d; s:-Wextra ::' -i Makefile.am || die
	sed -r -e "s:(m4_define\(\[jq_version\],) .+\):\1 \[${PV}\]):" \
		-i configure.ac || die

	# jq-1.6-r3-never-bundle-oniguruma makes sure we build with the system oniguruma,
	# but the bundled copy of oniguruma still gets eautoreconf'd since it
	# exists; save the cycles by nuking it.
	sed -e '/modules\/oniguruma/d' -i Makefile.am || die
	rm -rf "${S}"/modules/oniguruma || die

	default
	eautoreconf
}

src_configure() {
	local econfargs=(
		# don't try to rebuild docs
		--disable-docs
		--disable-valgrind
		--disable-maintainer-mode
		--enable-rpathhack
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
	local DOCS=( AUTHORS NEWS README.md )
	default

	use static-libs || { find "${D}" -name '*.la' -delete || die; }
}
