# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2 toolchain-funcs

DESCRIPTION="A language with a focus on simplicity, safety and correctness"
HOMEPAGE="https://fuzion-lang.dev/
	https://github.com/tokiwa-software/fuzion/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/tokiwa-software/${PN}"
else
	SRC_URI="https://github.com/tokiwa-software/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/jre-21:*
	dev-libs/boehm-gc
"
DEPEND="
	virtual/jdk:21
"
BDEPEND="
	test? (
		llvm-core/clang:*
	)
"

PATCHES=( "${FILESDIR}/fuzion-0.092-Makefile.patch" )
DOCS=( README.md release_notes.md )

src_prepare() {
	default #780585
	java-pkg-2_src_prepare

	# Remove bad tests.
	local -a bad_tests=(
		catch_postcondition
		nom
		onesCount
		process
	)
	local bad_test=""
	for bad_test in "${bad_tests[@]}" ; do
		rm -r "${S}/tests/${bad_test}" \
			|| die "failed to remove test ${bad_tests}"
	done

	rm -rf "${S}/tests/"{compile_,reg_issue,mod_,sockets}* || die
}

src_compile() {
	emake -j1 CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_test() {
	emake -j1 run_tests_jvm
}

src_install() {
	# Remove unnecessary files from build directory. bug #893450
	local toremove=""
	local toremove_path=""
	for toremove in tests run_tests.{failures,results} ; do
		toremove_path="${S}/build/${toremove}"

		if [[ -e "${toremove_path}" ]] ; then
			rm -r "${toremove_path}" \
				|| die "failed to remove ${toremove_path}"
		fi
	done

	insinto "/usr/share/${PN}"
	doins -r build/.
	insopts -m755
	doins -r build/bin

	local exe=""
	for exe in fz fzjava ; do
		dosym -r "/usr/share/${PN}/bin/${exe}" "/usr/bin/${exe}"
	done

	einstalldocs
}
