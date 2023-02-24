# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/patch.asc
inherit flag-o-matic verify-sig

DESCRIPTION="Utility to apply diffs to files"
HOMEPAGE="https://www.gnu.org/software/patch/patch.html"
SRC_URI="mirror://gnu/patch/${P}.tar.xz"
SRC_URI+=" verify-sig? ( mirror://gnu/patch/${P}.tar.xz.sig )"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static test xattr"
RESTRICT="!test? ( test )"

RDEPEND="xattr? ( sys-apps/attr )"
DEPEND="${RDEPEND}"
BDEPEND="test? ( sys-apps/ed )
	verify-sig? ( sec-keys/openpgp-keys-patch )"

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
		# rename to gpatch for better BSD compatibility
		--program-prefix=g
	)
	# Do not let $ED mess up the search for `ed` 470210.
	ac_cv_path_ED=$(type -P ed) \
		econf "${myeconfargs[@]}"
}

src_install() {
	default

	# symlink to the standard name
	dosym gpatch /usr/bin/patch
	dosym gpatch.1 /usr/share/man/man1/patch.1
}
