# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools systemd toolchain-funcs

DESCRIPTION="Daemon to use hardware random number generators"
HOMEPAGE="https://github.com/nhorman/rng-tools"
SRC_URI="https://github.com/nhorman/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~x86"
IUSE="selinux"

DEPEND="dev-libs/libgcrypt:0
	dev-libs/libgpg-error"
RDEPEND="${DEPEND}
	sys-fs/sysfsutils
	selinux? ( sec-policy/selinux-rngd )"

S="${WORKDIR}/${PN}-${P}"

PATCHES=(
	"${FILESDIR}"/test-for-argp.patch
	"${FILESDIR}"/${PN}-5-fix-textrels-on-PIC-x86.patch #469962
	"${FILESDIR}"/${PN}-5-man-fill-watermark.patch #555094
	"${FILESDIR}"/${PN}-6-fix-noctty.patch #556456
)

src_prepare() {
	echo 'bin_PROGRAMS = randstat' >> contrib/Makefile.am || die
	default
	eautoreconf

	sed -i '/^AR /d' Makefile.in || die
	tc-export AR
}

src_install() {
	default
	newinitd "${FILESDIR}"/rngd-initd-6 rngd
	newconfd "${FILESDIR}"/rngd-confd-4.1 rngd
	systemd_dounit "${FILESDIR}"/rngd.service
}
