# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_PV=${PV//./_}
DEBIAN_PATCH_VERSION=1

DESCRIPTION="Computing automorphism groups of graphs and digraphs"
HOMEPAGE="https://pallini.di.uniroma1.it/"

SRC_URI="https://pallini.di.uniroma1.it/${PN}${MY_PV}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}+ds-${DEBIAN_PATCH_VERSION}.debian.tar.xz
	https://src.fedoraproject.org/rpms/nauty/raw/rawhide/f/nauty-includes.patch"

S="${WORKDIR}/${PN}${MY_PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~riscv ~x86"
IUSE="cpu_flags_x86_popcnt examples"

BDEPEND="sys-apps/help2man"
DEPEND="dev-libs/gmp:0
	sys-libs/zlib
	sci-mathematics/cliquer"
RDEPEND="${DEPEND}"

DOCS=( schreier.txt formats.txt changes24-28.txt )

PATCHES=(
	"${WORKDIR}/debian/patches/upstream-fix-gt_numorbits.patch"
	"${WORKDIR}/debian/patches/upstream-zlib-dimacs2g.patch"
	"${WORKDIR}/debian/patches/upstream-C2help2man.patch"
	"${WORKDIR}/debian/patches/upstream-autotoolization.patch"
	"${DISTDIR}/nauty-includes.patch"
	"${WORKDIR}/debian/patches/unbundle-cliquer.patch"
	"${WORKDIR}/debian/patches/format.patch"
	"${WORKDIR}/debian/patches/uninitialized.patch"
	"${WORKDIR}/debian/patches/fall-off.patch"
	"${WORKDIR}/debian/patches/noreturn.patch"
	"${FILESDIR}/${P}-autoconf-2.72.patch"
)

src_prepare() {
	default
	rm makefile || die

	# The debian patch looks for <cliquer.h>, but the autotools-form of
	# cliquer installs that header as <cliquer/cliquer.h>.
	sed -e 's~<cliquer\.h>~<cliquer/cliquer\.h>~' -i nautycliquer.h || die

	eautoreconf
}

src_configure() {
	econf --disable-static \
		  --enable-tls \
		  --enable-generic \
		  $(use_enable cpu_flags_x86_popcnt popcnt)
}

src_test() {
	# It arrives non-executable in v2.8.8.
	chmod +x runalltests || die
	default
}

src_install() {
	default

	if use examples; then
		docinto examples
		dodoc nautyex*.c
	fi

	find "${ED}" -name '*.la' -delete || die
}
