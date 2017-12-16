# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit pam toolchain-funcs user

DESCRIPTION="A console screen locker"
HOMEPAGE="https://github.com/WorMzy/vlock"
SRC_URI="https://github.com/WorMzy/vlock/archive/master.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ia64 ~mips ~ppc ~ppc64 ~sparc x86"
IUSE="pam test"

RDEPEND="
	pam? ( sys-libs/pam )"

DEPEND="
	${RDEPEND}
	test? ( dev-util/cunit )"

DOCS=( ChangeLog PLUGINS README README.X11 SECURITY STYLE TODO )

S="${WORKDIR}/${PN}-master"

RESTRICT="test"

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
