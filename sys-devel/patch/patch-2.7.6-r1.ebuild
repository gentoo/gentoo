# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic

DESCRIPTION="Utility to apply diffs to files"
HOMEPAGE="https://www.gnu.org/software/patch/patch.html"
SRC_URI="mirror://gnu/patch/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static test xattr"

RDEPEND="xattr? ( sys-apps/attr )"
DEPEND="${RDEPEND}
	test? ( sys-apps/ed )"

PATCHES=( "${FILESDIR}"/${P}-fix-test-suite.patch )

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
