# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop flag-o-matic

MY_DOWNLOAD_ID="8/0100007658/11"
MY_PV="${PV//\./}"

DESCRIPTION="Canon UFR II / LIPSLX Printer Driver for Linux "
HOMEPAGE="https://www.canon-europe.com/support/products/imagerunner/"
SRC_URI="http://gdlp01.c-wss.com/gds/${MY_DOWNLOAD_ID}/linux-UFRII-drv-v${MY_PV}-uken-06.tar.gz"

LICENSE="Canon-UFR-II GPL-2 MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libxml2:2
	gnome-base/libglade:2.0
	media-libs/jbigkit
	net-print/cups
	x11-libs/gtk+:2"
RDEPEND="${DEPEND}
	!net-print/cndrvcups-common-lb
	!net-print/cndrvcups-lb"

HTML_DOCS=(
	"${WORKDIR}"/linux-UFRII-drv-v${MY_PV}-uken/Documents/README-ufr2-5.0xUK.html
	"${WORKDIR}"/linux-UFRII-drv-v${MY_PV}-uken/Documents/UsersGuide-ufr2-UK.html
)

S="${WORKDIR}/linux-UFRII-drv-v${MY_PV}-uken/Sources"

pkg_setup() {
	QA_PREBUILT="/usr/bin/cnsetuputil2
		/usr/bin/cnrsdrvufr2
		/usr/bin/cnpkmoduleufr2r
		/usr/bin/cnpkbidir
		/usr/bin/cnpdfdrv
		/usr/$(get_libdir)/libufr2filterr.so.1.0.0
		/usr/$(get_libdir)/libColorGearCufr2.so.2.0.0
		/usr/$(get_libdir)/libcnlbcmr.so.1.0
		/usr/$(get_libdir)/libcanon_slimufr2.so.1.0.0
		/usr/$(get_libdir)/libcanonufr2r.so.1.0.0
		/usr/$(get_libdir)/libcaiowrapufr2.so.1.0.0
		/usr/$(get_libdir)/libcaiocnpkbidir.so.1.0.0
		/usr/$(get_libdir)/libcaepcmufr2.so.1.0"

	QA_SONAME="/usr/$(get_libdir)/libcaiocnpkbidir.so.1.0.0"
}

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}/linux-UFRII-drv-v${MY_PV}-uken/Sources/" || die
	unpack ./${P}-1.tar.gz
}

common_op() {
	local i
	for i in backend buftool cngplp cnjbig rasterfilter; do
		cd "${S}/cnrdrvcups-common-${PV}/${i}" ||
			die "failed to switch dir to ${i}"
		"${@}"
		cd "${S}" || die "failed to switch dir back from ${i} to ${S}"
	done
}

driver_op() {
	local i
	for i in cngplp cngplp/files cpca pdftocpca; do
		cd "${S}/cnrdrvcups-lb-${PV}/${i}" ||
			die "failed to switch dir to ${i}"
		"${@}"
		cd "${S}" || die "failed to switch dir back from ${i} to ${S}"
	done
}

src_prepare() {
	default

	common_op mv configure.in configure.ac || die "failed to move configure.in"
	driver_op mv configure.in configure.ac || die "failed to move configure.in"

	common_op sed -i -e 's/configure.in/configure.ac/' configure.ac || die
	driver_op sed -i -e 's/configure.in/configure.ac/' configure.ac || die

	# This should work with autoreconf
	export "LIBS=-lgtk-x11-2.0 -lgobject-2.0 -lglib-2.0 -lgmodule-2.0"

	# Other components already depend on compiled product
	append-ldflags -L"${S}/cnrdrvcups-common-${PV}/buftool"

	common_op eautoreconf
	driver_op eautoreconf

	# Fix a QA issue with .desktop file,
	sed -i 's/Application;Utility/Utility/g' "${S}"/cnrdrvcups-utility-${PV}/data/cnsetuputil2.desktop ||
		die "Failed to modify cnsetuputil2.desktop file."
}

src_configure() {
	common_op econf
	driver_op econf
}

src_compile() {
	common_op emake
	driver_op emake
}

src_install() {
	common_op emake DESTDIR="${D}" install COMMON_SUFFIX=2
	driver_op emake DESTDIR="${D}" install COMMON_SUFFIX=2

	insinto /usr/share/cups
	doins "${S}"/cnrdrvcups-common-${PV}/Rule/canon-laser-printer_ufr2.usb-quirks

	if use amd64; then
		cd "${S}"/lib/libs64 || die "failed to switch into libs64"
	elif use x86; then
		cd "${S}"/lib/libs32 || die "failed to switch into libs32"
	else
		die "I don't know what directory to switch into!"
	fi

	dolib.so libcaepcmufr2.so.1.0 libcaiocnpkbidir.so.1.0.0 \
		libcaiowrapufr2.so.1.0.0 libcanonufr2r.so.1.0.0 \
		libcanon_slimufr2.so.1.0.0 libcnlbcmr.so.1.0 \
		libColorGearCufr2.so.2.0.0 libufr2filterr.so.1.0.0

	dosym libcaepcmufr2.so.1.0 /usr/$(get_libdir)/libcaepcmufr2.so
	dosym libcaepcmufr2.so.1.0 /usr/$(get_libdir)/libcaepcmufr2.so.1

	dosym libcaiocnpkbidir.so.1.0.0 /usr/$(get_libdir)/libcaiocnpkbidir.so
	dosym libcaiocnpkbidir.so.1.0.0 /usr/$(get_libdir)/libcaiocnpkbidir.so.1

	dosym libcaiowrapufr2.so.1.0.0 /usr/$(get_libdir)/libcaiowrapufr2.so
	dosym libcaiowrapufr2.so.1.0.0 /usr/$(get_libdir)/libcaiowrapufr2.so.1

	dosym libcanonufr2r.so.1.0.0 /usr/$(get_libdir)/libcanonufr2r.so
	dosym libcanonufr2r.so.1.0.0 /usr/$(get_libdir)/libcanonufr2r.so.1

	dosym libcanon_slimufr2.so.1.0.0 /usr/$(get_libdir)/libcanon_slimufr2.so
	dosym libcanon_slimufr2.so.1.0.0 /usr/$(get_libdir)/libcanon_slimufr2.so.1

	dosym libcnlbcmr.so.1.0 /usr/$(get_libdir)/libcnlbcmr.so
	dosym libcnlbcmr.so.1.0 /usr/$(get_libdir)/libcnlbcmr.so.1

	dosym libColorGearCufr2.so.2.0.0 /usr/$(get_libdir)/libColorGearCufr2.so
	dosym libColorGearCufr2.so.2.0.0 /usr/$(get_libdir)/libColorGearCufr2.so.2

	dosym libufr2filterr.so.1.0.0 /usr/$(get_libdir)/libufr2filterr.so
	dosym libufr2filterr.so.1.0.0 /usr/$(get_libdir)/libufr2filterr.so.1

	dobin cnpdfdrv cnpkbidir cnpkmoduleufr2r cnrsdrvufr2 cnsetuputil2

	insinto /usr/share/caepcm/ufr2
	doins ./cnpkbidir_info*

	insinto /usr/share/ufr2filterr
	doins ./ThLB*

	cd "${S}" || die "Failed to switch back into ${S} during installation."

	dosym ../../../$(get_libdir)/cups/backend/cnusb /usr/libexec/cups/backend/cnusb
	dosym ../../../$(get_libdir)/cups/filter/pdftocpca /usr/libexec/cups/filter/pdftocpca
	dosym ../../../$(get_libdir)/cups/filter/rastertoufr2 /usr/libexec/cups/filter/rastertoufr2

	insinto /usr/share/caepcm/ufr2
	doins -r "${S}"/lib/data/ufr2/

	insinto /usr/share/cups/model
	doins ${P}/ppd/*.ppd

	domenu ./cnrdrvcups-utility-${PV}/data/cnsetuputil2.desktop
	doicon ./cnrdrvcups-utility-${PV}/data/cnsetuputil.png

	einstalldocs
	newdoc "${S}"/cnrdrvcups-common-${PV}/README README.common
	newdoc "${S}"/cnrdrvcups-common-${PV}/cngplp/README README.cngplp.common
	newdoc "${S}"/cnrdrvcups-lb-${PV}/README README.lb
	newdoc "${S}"/cnrdrvcups-lb-${PV}/cngplp/README README.cngplp.driver

	find "${D}" -name '*.la' -type f -delete || die
}
