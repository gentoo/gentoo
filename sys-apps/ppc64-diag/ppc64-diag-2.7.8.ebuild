# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Diagnostic tools for PowerLinux"
HOMEPAGE="https://github.com/power-ras/ppc64-diag"
SRC_URI="https://github.com/power-ras/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~ppc64"
IUSE="rtas"

DEPEND="virtual/libudev:=
	rtas? (
		sys-libs/ncurses:0=
		sys-libs/librtas
		sys-libs/libservicelog
		>=sys-libs/libvpd-2.2.9:=
	)
"

RDEPEND="${DEPEND}"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/fix-systemd-unit-path.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_with rtas librtas)
	# handle ncurses[tinfo]
	sed -e "s:-lncurses:$($(tc-getPKG_CONFIG) --libs ncurses):g" \
		-i Makefile || die
}

src_install() {
	default
	newinitd "${FILESDIR}/opal_errd.initd" opal_errd

	if use rtas; then
		newinitd "${FILESDIR}/rtas_errd.initd" rtas_errd
		keepdir /var/log/ppc64-diag/diag_disk
	else
		# makefile installs it unconditionally
		rm -rf "${ED}/lib/systemd/system/rtas_errd.service" || die
		rm -rf "${ED}/usr/lib/systemd/system/rtas_errd.service" || die
	fi

	keepdir /var/log/opal-elog
	keepdir /var/log/dump
}

src_test() {
	# it assumes MKTEMP created dir in /tmp, add /var to the string.
	# /varplatform.0x01 becomes platform.0x01, just as test expects
	# so we sed a sed expression, don't judge me
	sed -i 's%\/tmp/%\/var\/tmp\/%' opal_errd/tests/test-extract_opal_dump-000 || die
	emake check
}
