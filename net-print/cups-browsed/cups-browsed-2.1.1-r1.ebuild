# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="helper daemon to browse for remote CUPS queues and IPP network printers"
HOMEPAGE="https://github.com/OpenPrinting/cups-browsed"
SRC_URI="https://github.com/OpenPrinting/cups-browsed/releases/download/${PV}/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv sparc x86"
IUSE="test zeroconf"

RDEPEND="
	dev-libs/glib:2
	>=net-print/cups-2
	>=net-print/cups-filters-2.0.0
	test? ( net-print/cups[zeroconf] )
	zeroconf? ( net-dns/avahi[dbus] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/gdbus-codegen
	>=sys-devel/gettext-0.18.3
	virtual/pkgconfig
"

# The tests are new since the split out of cups-filters. Actually running them
# seems to be challenging. You need:
# - cups tools that are USE-optional
# - running avahi-daemon (as root!)
# - disable portage's pid-sandbox, which interferes with avahi
# - ipptool still fails to connect to port 8xxx
#
# If anything fails, a `while true` loop fails to successfully launch and break
# out of the loop, leading to a hang. Until there's an obvious recipe for
# successfully running the tests, restrict it.
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${P}-no-model.patch
	"${FILESDIR}"/${P}-crash.patch
)

src_configure() {
	local myeconfargs=(
		--localstatedir="${EPREFIX}"/var
		--with-cups-rundir="${EPREFIX}"/run/cups
		--with-rcdir=no

		$(use_enable zeroconf avahi)
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	# Requires avahi running. Hangs forever if not available.
	avahi-daemon --check 2>/dev/null || die "no running avahi daemon found, cannot run tests"

	default
}

src_install() {
	default

	cp "${FILESDIR}"/cups-browsed.init.d "${T}"/cups-browsed || die

	if ! use zeroconf ; then
		sed -i -e 's:need cupsd avahi-daemon:need cupsd:g' "${T}"/cups-browsed || die
		sed -i -e 's:cups\.service avahi-daemon\.service:cups.service:g' "${S}"/daemon/cups-browsed.service || die
	fi

	doinitd "${T}"/cups-browsed
	systemd_dounit "${S}"/daemon/cups-browsed.service

}
