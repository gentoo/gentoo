# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P="${PN}-source-${PV}-1"

DESCRIPTION="IJ Printer Driver"
HOMEPAGE="https://www.canon.it/"
SRC_URI="http://gdlp01.c-wss.com/gds/3/0100010273/01/${MY_P}.tar.gz"

LICENSE="Canon-IJ"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/libusb:1
	dev-libs/libxml2
	net-print/cups"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED=(
	/usr/lib64/libcnbpnet30.so.1.0.0
	/usr/lib64/libcnbpcnclapicom2.so.5.0.0
	/usr/lib64/libcnnet2.so.1.2.4
	/usr/lib64/libcnbpnet20.so.1.0.0
	/usr/bin/cnijlgmon3
)

S="${WORKDIR}"/${MY_P}

PATCHES=(
	"${FILESDIR}"/${PN}-5.70-gentoo.patch
	"${FILESDIR}"/${P}-cflags.patch
)

src_prepare() {
	default
	DIRS="cmdtocanonij2 cmdtocanonij3 cnijbe2 lgmon3 rastertocanonij tocanonij tocnpwg"
	LIBDIR=com/libs_bin$(usex amd64 64 32)
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
	ln -sf libcnnet2.so.1.2.4 libcnnet2.so || die

	cd -
}

src_configure() {
	LDFLAGS="-L"${S}"/${LIBDIR}" econf --enable-progpath="${EPREFIX}/usr/bin"
}

src_install() {
	default
	insinto /usr/share/ppd/cupsfilters
	doins ppd/*ppd
	dolib.so ${LIBDIR}/*
}
