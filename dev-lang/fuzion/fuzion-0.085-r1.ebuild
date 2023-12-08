# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="A language with a focus on simplicity, safety and correctness"
HOMEPAGE="https://flang.dev/
	https://github.com/tokiwa-software/fuzion/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/tokiwa-software/${PN}.git"
else
	SRC_URI="https://github.com/tokiwa-software/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=virtual/jre-17:*
	dev-libs/boehm-gc
"
# jdk:17 for https://bugs.gentoo.org/916689
DEPEND="
	virtual/jdk:17
"
BDEPEND="
	test? ( sys-devel/clang:* )
"

DOCS=( README.md release_notes.md )

src_compile() {
	emake -j1
}

src_test() {
	emake -j1 run_tests_parallel
}

src_install() {
	# Remove unnecessary files from build directory. bug #893450
	local torm
	local torm_path
	for torm in tests run_tests.{failures,results} ; do
		torm_path="${S}/build/${torm}"

		if [[ -e "${torm_path}" ]] ; then
			rm -r "${torm_path}" || die "failed to remove ${torm_path}"
		fi
	done

	insinto "/usr/share/${PN}"
	doins -r build/.
	insopts -m755
	doins -r build/bin

	local bin
	for bin in fz fzjava ; do
		dosym -r "/usr/share/${PN}/bin/${bin}" "/usr/bin/${bin}"
	done

	einstalldocs
}
