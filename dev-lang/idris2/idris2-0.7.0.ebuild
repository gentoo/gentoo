# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs toolchain-funcs

DESCRIPTION="Purely functional programming language with first class types"
HOMEPAGE="https://idris-lang.org/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/idris-lang/${PN^}.git"
else
	SRC_URI="https://github.com/idris-lang/${PN^}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN^}-${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="+chez doc racket test-full"
REQUIRED_USE="^^ ( chez racket )"

RDEPEND="
	dev-libs/gmp:=
	chez? (
		dev-scheme/chez:=[threads]
	)
	racket? (
		dev-scheme/racket:=[threads]
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	doc? (
		dev-python/sphinx-rtd-theme
	)
	test-full? (
		dev-scheme/chez[threads]
		dev-scheme/racket[threads]
		net-libs/nodejs
	)
"

CHECKREQS_DISK_BUILD="800M"

PATCHES=( "${FILESDIR}/${PN}-0.7.0-disable-allbackends-tests.patch"  )

# Generated via "SCHEME", not CC
QA_FLAGS_IGNORED="
	usr/lib/idris2/bin/idris2_app/idris2
	usr/lib/idris2/bin/idris2_app/idris2-boot
"
QA_PRESTRIPPED="${QA_FLAGS_IGNORED}"

src_prepare() {
	# Clean up environment of Idris and Racket variables
	unset IDRIS2_DATA IDRIS2_INC_CGS IDRIS2_LIBS IDRIS2_PACKAGE_PATH
	unset IDRIS2_PATH IDRIS2_PREFIX
	unset PLTUSERHOME

	tc-export AR CC CXX LD RANLIB
	export CFLAGS
	sed -i '/^CFLAGS/d' ./support/*/Makefile || die

	# Fix "PREFIX"
	sed -i 's|$(HOME)/.idris2|/usr/lib/idris2|g' ./config.mk || die

	# Bad tests
	local -a bad_tests=(
		allschemes/channels006
		chez/futures001
		refc/args
		refc/buffer
		refc/clock
		refc/doubles
		refc/garbageCollect
		refc/integers
		refc/issue1778
		refc/issue2424
		refc/refc002
		refc/refc003
		refc/strings
	)
	local bad_test
	for bad_test in "${bad_tests[@]}" ; do
		rm -r "tests/${bad_test}" || die
	done

	default
}

src_configure() {
	export IDRIS2_VERSION="${PV}"
	export SCHEME="$(usex chez chezscheme racket)"

	if use chez ; then
		export IDRIS2_CG=chez
		export BOOTSTRAP_TARGET=bootstrap
	elif use racket ; then
		export IDRIS2_CG=racket
		export BOOTSTRAP_TARGET=bootstrap-racket
	else
		die 'Neither "chez" nor "racket" was chosen'
	fi
}

src_compile() {
	# > jobserver unavailable
	# This is caused by Makefile using a script which in turn calls make
	# https://github.com/idris-lang/Idris2/issues/2152
	emake SCHEME="${SCHEME}" "${BOOTSTRAP_TARGET}" -j1

	use doc && emake -C ./docs html
}

src_test() {
	emake SCHEME="${SCHEME}" bootstrap-test
}

src_install() {
	# "DESTDIR" variable is not respected, use "PREFIX" instead
	emake IDRIS2_PREFIX="${ED}/usr/lib/idris2" PREFIX="${ED}/usr/lib/idris2" install
	dosym "../lib/${PN}/bin/${PN}" "/usr/bin/${PN}"

	# Install documentation
	use doc && dodoc -r ./docs/build/html
	einstalldocs
}
