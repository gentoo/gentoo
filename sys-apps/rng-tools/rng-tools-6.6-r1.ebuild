# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools systemd toolchain-funcs

DESCRIPTION="Daemon to use hardware random number generators"
HOMEPAGE="https://github.com/nhorman/rng-tools"
SRC_URI="https://github.com/nhorman/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~x86"
IUSE="jitterentropy nistbeacon selinux"

DEPEND="dev-libs/libgcrypt:0
	dev-libs/libgpg-error
	sys-fs/sysfsutils
	jitterentropy? (
		app-crypt/jitterentropy:=
	)
	nistbeacon? (
		net-misc/curl[ssl]
		dev-libs/libxml2:2=
		dev-libs/openssl:0=
	)
	elibc_musl? ( sys-libs/argp-standalone )
"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-rngd )"
DEPEND="${DEPEND}
	nistbeacon? (
		virtual/pkgconfig
	)
"

PATCHES=(
	"${FILESDIR}"/test-for-argp.patch
	"${FILESDIR}"/${PN}-5-fix-textrels-on-PIC-x86.patch #469962
)

src_prepare() {
	echo 'bin_PROGRAMS = randstat' >> contrib/Makefile.am || die
	default

	mv README.md README || die

	eautoreconf

	sed -i '/^AR /d' Makefile.in || die
	tc-export AR
}

src_configure() {
	local myeconfargs=(
		$(use_with nistbeacon)
		$(use_enable jitterentropy)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	newinitd "${FILESDIR}"/rngd-initd-6-r1 rngd
	newconfd "${FILESDIR}"/rngd-confd-6 rngd
	systemd_dounit "${FILESDIR}"/rngd.service
}
