# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/patch.asc
inherit flag-o-matic verify-sig

DESCRIPTION="Utility to apply diffs to files"
HOMEPAGE="https://www.gnu.org/software/patch/patch.html"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/patch.git"
	inherit git-r3
elif [[ ${PV} = *_p* ]] ; then
	# Note: could put this in devspace, but if it's gone, we don't want
	# it in tree anyway. It's just for testing.
	MY_SNAPSHOT="$(ver_cut 1-3).200-be8b"
	SRC_URI="https://meyering.net/patch/patch-${MY_SNAPSHOT}.tar.xz -> ${P}.tar.xz"
	SRC_URI+=" verify-sig? ( https://meyering.net/patch/patch-${MY_SNAPSHOT}.tar.xz.sig -> ${P}.tar.xz.sig )"
	S="${WORKDIR}"/${PN}-${MY_SNAPSHOT}
else
	SRC_URI="mirror://gnu/patch/${P}.tar.xz"
	SRC_URI+=" verify-sig? ( mirror://gnu/patch/${P}.tar.xz.sig )"

	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="static test xattr"
RESTRICT="!test? ( test )"

RDEPEND="xattr? ( sys-apps/attr )"
DEPEND="${RDEPEND}"
BDEPEND="
	test? ( sys-apps/ed )
	verify-sig? ( sec-keys/openpgp-keys-patch )
"

src_unpack() {
	if [[ ${PV} == 9999 ]] ; then
		git-r3_src_unpack

		cd "${S}" || die
		./bootstrap || die
	elif use verify-sig ; then
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.xz{,.sig}
	fi

	default
}

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

src_test() {
	emake check gl_public_submodule_commit=
}

src_install() {
	default

	# symlink to the standard name
	dosym gpatch /usr/bin/patch
	dosym gpatch.1 /usr/share/man/man1/patch.1
}
