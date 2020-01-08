# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit pam toolchain-funcs user

COMMIT="f2afd55704bfe0a2d66e6b270d247e9b8a7b1664"

DESCRIPTION="A console screen locker"
HOMEPAGE="https://github.com/WorMzy/vlock"
SRC_URI="https://github.com/WorMzy/vlock/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE="pam test"
RESTRICT="!test? ( test )"

RDEPEND="
	!>=sys-apps/kbd-2.0.4-r1[pam]
	pam? ( sys-libs/pam )"

DEPEND="
	${RDEPEND}
	test? ( dev-util/cunit )"

DOCS=( ChangeLog PLUGINS README README.X11 SECURITY STYLE TODO )

PATCHES=(
	"${FILESDIR}/${PN}-2.2.2-asneeded.patch"
	"${FILESDIR}/${PN}-2.2.2-test_process.patch"
)

pkg_setup() {
	enewgroup "${PN}"
}

src_configure() {
	local myconf="--enable-shadow"
	use pam && myconf="--enable-pam"

	# this package has handmade configure system which fails with econf...
	./configure \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--libdir=/usr/$(get_libdir) \
		${myconf} \
		CC="$(tc-getCC)" \
		LD="$(tc-getLD)" \
		CFLAGS="${CFLAGS} -pedantic -std=gnu99" \
		LDFLAGS="${LDFLAGS}" || die "configure failed"
}

src_install() {
	default
	use pam && pamd_mimic_system vlock auth
}
