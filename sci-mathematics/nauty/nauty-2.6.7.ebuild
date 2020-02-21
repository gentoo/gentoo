# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools versionator

MY_PV1=$(replace_version_separator 2 'r')
MY_PV=$(delete_version_separator 1 ${MY_PV1})

DESCRIPTION="Computing automorphism groups of graphs and digraphs"
HOMEPAGE="http://pallini.di.uniroma1.it/"
DEBIAN_PATCH_VERSION="1"
SRC_URI="http://cs.anu.edu.au/~bdm/${PN}/${PN}${MY_PV}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${MY_PV1}+ds-${DEBIAN_PATCH_VERSION}.debian.tar.xz
	http://pkgs.fedoraproject.org/cgit/rpms/nauty.git/plain/nauty-popcnt.patch"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-libs/gmp:0
	sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}${MY_PV}"
DOCS=( schreier.txt config.txt formats.txt changes24-26.txt )
PATCHES=(
	"${WORKDIR}"/debian/patches/upstream-lintian-spelling-error.patch
	"${WORKDIR}"/debian/patches/upstream-fix-gt_numorbits.patch
	"${WORKDIR}"/debian/patches/upstream-fix-include-extern.patch
	"${WORKDIR}"/debian/patches/upstream-zlib-blisstog_c.patch
	"${WORKDIR}"/debian/patches/upstream-C2help2man.patch
	"${WORKDIR}"/debian/patches/upstream-autotoolization.patch
	"${WORKDIR}"/debian/patches/system-preprocessing-examples.patch
	"${DISTDIR}"/nauty-popcnt.patch
)

src_prepare() {
	default
	rm -f makefile
	eautoreconf
}

src_configure() {
	econf --disable-static --enable-runtime-popcnt --enable-tls
}
