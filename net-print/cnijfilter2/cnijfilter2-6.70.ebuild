# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P="${PN}-source-${PV}-1"

DESCRIPTION="IJ Printer Driver"
HOMEPAGE="https://www.usa.canon.com/support/p/pixma-g4270#idReference%3Dsoftware-drivers"
SRC_URI="https://gdlp01.c-wss.com/gds/7/0100012137/01/${PN}-source-${PV}-1.tar.gz"

LICENSE="Canon-IJ"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/libusb:1
	dev-libs/libxml2
	net-print/cups"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PN}-6.50-gentoo.patch
	"${FILESDIR}"/${PN}-5.80-cflags.patch
	"${FILESDIR}"/${PN}-5.80-fno-common.patch
	"${FILESDIR}"/${PN}-6.60-c99.patch
)

pkg_setup()  {
	QA_PREBUILT="
		/usr/$(get_libdir)/libcnbpnet30.so.1.0.0
		/usr/$(get_libdir)/libcnbpcnclapicom2.so.5.0.0
		/usr/$(get_libdir)/libcnnet2.so.1.2.5
		/usr/$(get_libdir)/libcnbpnet20.so.1.0.0
		/usr/bin/cnijlgmon3
	"
}

src_prepare() {
	default
	DIRS="cmdtocanonij2 cmdtocanonij3 cnijbe2 lgmon3 rastertocanonij tocanonij tocnpwg"
	LIBDIR=com/libs_bin$(usex amd64 _x86_64 _i686)
	for d in ${DIRS}; do
		mv "${d}"/configure.{in,ac} || die
	done
	echo "AC_INIT([${PN}], [${PV}])" >> configure.ac
	echo "AM_INIT_AUTOMAKE" >> configure.ac
	echo "AC_CONFIG_SUBDIRS([${DIRS}])" >> configure.ac
	echo "AC_CONFIG_FILES([Makefile])" >> configure.ac
	echo "AC_OUTPUT()" >> configure.ac
	echo "SUBDIRS= ${DIRS}" >> Makefile.am
	sed -i \
		-e "/^CFLAGS/d" \
		*/configure.ac \
		cnijbe2/src/Makefile.am || die
	eautoreconf
	cd ${LIBDIR}
	rm libcn*.so || die
	ln -sf libcnbpcnclapicom2.so.5.0.0 libcnbpcnclapicom2.so || die
	ln -sf libcnbpnet20.so.1.0.0 libcnbpnet20.so || die
	ln -sf libcnbpnet30.so.1.0.0 libcnbpnet30.so || die
	ln -sf libcnnet2.so.1.2.5 libcnnet2.so || die

	cd -
}

src_configure() {
	econf --enable-progpath="${EPREFIX}/usr/bin" LDFLAGS="-L${S}/${LIBDIR} ${LDFLAGS}"
}

src_install() {
	default
	insinto /usr/share/ppd/cupsfilters
	doins ppd/*ppd
	dolib.so ${LIBDIR}/*
}
