# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pam toolchain-funcs

EGIT_COMMIT="3542ef58a2b838cc8294fe82c341fb671c38611b"

DESCRIPTION="Allows to lock one or all of the sessions of your console display"
HOMEPAGE="https://github.com/WorMzy/vlock"
SRC_URI="https://github.com/WorMzy/vlock/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE="pam test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	!sys-apps/kbd[pam]
	pam? ( sys-libs/pam )
"

DEPEND="
	${COMMON_DEPEND}
	test? ( dev-util/cunit )
"

RDEPEND="
	${COMMON_DEPEND}
	acct-group/vlock
"

DOCS=( ChangeLog PLUGINS README README.X11 SECURITY STYLE TODO )

PATCHES=(
	"${FILESDIR}/${PN}-2.2.2-asneeded.patch"
	"${FILESDIR}/${PN}-2.2.2-test_process.patch"
)

src_configure() {
	local myeconfargs=(
		CC="$(tc-getCC)"
		CFLAGS="${CFLAGS} -pedantic -std=gnu99"
		LD="$(tc-getLD)"
		LDFLAGS="${LDFLAGS}"
		$(usex pam '--enable-pam' '--enable-shadow')
		--prefix="${EPREFIX}"/usr
		--mandir="${EPREFIX}"/usr/share/man
		--libdir="${EPREFIX}"/usr/$(get_libdir)
	)

	# This package has handmade configure system which fails with econf
	./configure "${myeconfargs[@]}" || die
}

src_install() {
	default

	# Bug #637598
	eapply "${FILESDIR}/${P}-echo-printf.patch"

	use pam && pamd_mimic_system vlock auth
}
