# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Tools to ease the validation of DNSSEC related technologies"
HOMEPAGE="https://www.dnssec-tools.org/"
SRC_URI="https://github.com/DNSSEC-Tools/DNSSEC-Tools/archive/dnssec-tools-${PV}.tar.gz"
S="${WORKDIR}/DNSSEC-Tools-dnssec-tools-${PV}/dnssec-tools/validator"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86"
IUSE="dlv +nsec3 static-libs +threads"

RDEPEND=">=dev-libs/openssl-1.1.0:0="
DEPEND="${RDEPEND}"

# Tests fail due "Cannot create context: -7"
RESTRICT="test"

PATCHES=(
	# Users LDFLAGS are not respected
	# See https://github.com/DNSSEC-Tools/DNSSEC-Tools/pull/9
	"${FILESDIR}/${P}-ldflags.patch"
)

src_prepare() {
	default

	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with dlv)
		$(use_with nsec3)
		$(use_enable static-libs static)
		$(use_with threads)
		--with-dnsval-conf="${EPREFIX}/etc/dnssec-tools/dnsval.conf"
		--with-ipv6
		--with-resolv-conf="${EPREFIX}/etc/dnssec-tools/resolv.conf"
		--with-root-hints="${EPREFIX}/etc/dnssec-tools/root.hints"
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	# Install fails with MAKEOPTS > -j1
	# See https://github.com/DNSSEC-Tools/DNSSEC-Tools/issues/8
	emake -j1 DESTDIR="${D}" install

	einstalldocs

	find "${D}" -name '*.la' -delete || die
}
