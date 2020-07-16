# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils autotools

DESCRIPTION="Dymo SDK for LabelWriter/LabelManager printers"
HOMEPAGE="https://newellrubbermaid.secure.force.com/dymopkb"
SRC_URI="http://download.dymo.com/Download%20Drivers/Linux/Download/${P}.tar.gz"

S="${WORKDIR}/${P}.5"

LICENSE="GPL-2"
SLOT="0"
IUSE="test usb_modeswitch"
RESTRICT="!test? ( test )"

KEYWORDS="~amd64 ~x86"

RDEPEND="net-print/cups"
DEPEND="${RDEPEND}
	test? ( dev-util/cppunit )
	usb_modeswitch? ( sys-apps/usb_modeswitch )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.0-cxxflags.patch
	"${FILESDIR}"/port_to_newer_cups_headers.patch
	"${FILESDIR}"/dymo-cups-drivers-1.4.0.5-flexible-tests.patch
)

DOCS=( AUTHORS README ChangeLog docs/SAMPLES )

src_prepare() {
	default
	eapply_user
	eautoreconf
}

src_install() {
	default

	insinto /usr/share/doc/${PF}
	doins docs/*.{txt,rtf,ps,png}
}

src_test() {
	# upstream tests are designed to be run AFTER make install, because they depend on final paths.
	testroot="${T}/testroot"
	mkdir -p "${testroot}"
	emake install DESTDIR="${testroot}"
	# -W filters is because CUPS tries really hard for secure filters: they must be root/root for the filter tests to pass
	#chown root:root "${testroot}"/usr/libexec/cups/filter/{raster2dymolm,raster2dymolw} || die "failed to set ownership for tests"
	# This will trigger the following warning repeatedly
	#Bad permissions on cupsFilter file "..${testroot}/usr/libexec/cups/filter/raster2dymolm"
	emake check CUPSTESTPPD_OPTS="-R ${testroot} -W filters"
}
