# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools eutils

DESCRIPTION="Meschach is a C-language library of routines for performing matrix computations."
HOMEPAGE="http://homepage.divms.uiowa.edu/~dstewart/meschach"
SRC_URI="http://cdn-fastly.deb.debian.org/debian/pool/main/m/meschach/${PN}_${PV}.orig.tar.gz \
http://cdn-fastly.deb.debian.org/debian/pool/main/m/meschach/${PN}_${PV}-14.debian.tar.xz"

LICENSE="meschach"
SLOT="0"
KEYWORDS="~amd64"
IUSE="complex +double float munroll old segmem sparse test unroll"
RESTRICT="!test? ( test )"
REQUIRED_USE="
		^^ ( double float )
"

PATCHES=(
	"${WORKDIR}/debian/patches/${PN}_${PV}-13.diff"
	"${WORKDIR}/debian/patches/${PN}_${PV}-13.configure.diff"
)

src_prepare() {
	default
	sed -i -- 's/CFLAGS = -O3 -fPIC/CFLAGS = @CFLAGS@ -fPIC/g' makefile.in
	use old && sed -i -- 's/all: shared static/all: oldpart shared static/g' makefile.in
	mv configure.in configure.ac
	eautoreconf
}

src_configure() {
	myconf=(
		$(use_with complex)
		$(use_with double)
		$(use_with float)
		$(use_with munroll)
		$(use_with segmem)
		$(use_with sparse)
		$(use_with unroll)
	)

	econf "${myconf[@]}"
}

src_compile() {
	emake DESTDIR="${D}" all
	use test && emake alltorture
}

src_install() {
	dolib.so libmeschach.so
	insinto /usr/include/meschach
	doins *.h
	use test && dodir /usr/libexec/meschach
	use test && exeinto /usr/libexec/meschach
	use test && doexe iotort
	use test && doexe itertort
	use test && doexe macheps
	use test && doexe maxint
	use test && doexe memtort
	use test && doexe mfuntort
	use test && doexe sptort
	use test && doexe torture
	use test && doexe ztorture
	use test && insinto /usr/libexec/meschach
	use test && doins *.dat
	dodoc -r DOC/.
	dodoc README
}
