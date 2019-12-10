# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit flag-o-matic

DESCRIPTION="Utility to apply diffs to files"
HOMEPAGE="https://www.gnu.org/software/patch/patch.html"
SRC_URI="mirror://gnu/patch/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static test xattr"
RESTRICT="!test? ( test )"

RDEPEND="xattr? ( sys-apps/attr )"
DEPEND="${RDEPEND}
	test? ( sys-apps/ed )"

PATCHES=(
	"${FILESDIR}"/${P}-fix-test-suite.patch
	"${FILESDIR}"/${PN}-2.7.6-fix-error-handling-with-git-style-patches.patch
	"${FILESDIR}"/${PN}-2.7.6-CVE-2018-6951.patch
	"${FILESDIR}"/${PN}-2.7.6-allow-input-files-to-be-missing-for-ed-style-patches.patch
	"${FILESDIR}"/${PN}-2.7.6-CVE-2018-1000156.patch
	"${FILESDIR}"/${PN}-2.7.6-CVE-2018-6952.patch
	"${FILESDIR}"/${PN}-2.7.6-Do-not-crash-when-RLIMIT_NOFILE-is-set-to-RLIM_INFINITY.patch
	"${FILESDIR}"/${PN}-2.7.6-CVE-2018-1000156-fix1.patch
	"${FILESDIR}"/${PN}-2.7.6-CVE-2018-1000156-fix2.patch
	"${FILESDIR}"/${PN}-2.7.6-CVE-2019-13636.patch
	"${FILESDIR}"/${PN}-2.7.6-CVE-2019-13638.patch
	"${FILESDIR}"/${PN}-2.7.6-Avoid-invalid-memory-access-in-context-format-diffs.patch
)

src_configure() {
	use static && append-ldflags -static

	local myeconfargs=(
		$(use_enable xattr)
		--program-prefix="$(use userland_BSD && echo g)"
	)
	# Do not let $ED mess up the search for `ed` 470210.
	ac_cv_path_ED=$(type -P ed) \
		econf "${myeconfargs[@]}"
}
