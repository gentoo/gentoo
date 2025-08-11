# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs dot-a toolchain-funcs

DESCRIPTION="Purely functional programming language with first class types"
HOMEPAGE="https://idris-lang.org/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/idris-lang/${PN^}"
else
	SRC_URI="https://github.com/idris-lang/${PN^}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN^}-${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="+chez doc minimal racket test-full"
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

CHECKREQS_DISK_BUILD="1200M"

PATCHES=( "${FILESDIR}/${PN}-0.7.0-disable-allbackends-tests.patch" )

# Generated via "SCHEME", not CC
RESTRICT="strip"
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
	export IDRIS2_CG="$(usex chez chez racket)"
	export SCHEME="$(usex chez chezscheme racket)"

	# bug #958431
	lto-guarantee-fat
}

src_compile() {
	# > jobserver unavailable
	# We have to use -j1.
	# This is caused by Makefile using a script which in turn calls make
	# https://github.com/idris-lang/Idris2/issues/2152

	local bootstrap_target="$(usex chez bootstrap bootstrap-racket)"

	einfo "Bootstrapping stage 1 (from Scheme)"
	emake -j1 PREFIX="${S}/stage1" SCHEME="${SCHEME}" "${bootstrap_target}"
	emake -j1 PREFIX="${S}/stage1" SCHEME="${SCHEME}" install

	einfo "Bootstrapping stage 2 (self-hosted)"
	local -x PATH="${S}/stage1/bin:${PATH}"
	if use racket ; then
		emake -j1 IDRIS2_BOOT="idris2 --codegen racket" all
	else
		emake -j1 all
	fi

	if use doc ; then
		emake -C ./docs html
	fi
}

src_test() {
	emake SCHEME="${SCHEME}" test
}

src_install() {
	emake -j1 DESTDIR="${ED}" install
	dosym "../lib/${PN}/bin/${PN}" "/usr/bin/${PN}"

	local -x PATH="${S}/build/exec:${PATH}"

	if ! use minimal ; then
		emake -j1 IDRIS2_PREFIX="${ED}/usr/lib/idris2" install-with-src-api
		emake -j1 IDRIS2_PREFIX="${ED}/usr/lib/idris2" install-with-src-libs

		sed -e "s|${D}||g" \
			-i "${ED}/usr/lib/${PN}/${P}/${P}/IdrisPaths.idr" \
			|| die
	fi

	# bug #958431
	strip-lto-bytecode

	cat <<EOF > "${ED}/usr/lib/${PN}/gentoo-build-info.txt"
Package: ${P}
Installed: $(date +'%Y-%m-%d %H:%M %Z')
Bootstrapped from: $(usex chez Chez Racket)
Self-hosted: yes
Idris2 API installed: $(usex minimal no yes)
EOF

	if use doc ; then
		dodoc -r ./docs/build/html
	fi

	einstalldocs
}
