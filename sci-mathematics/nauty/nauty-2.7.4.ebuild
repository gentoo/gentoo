# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_PV1=$(ver_rs 2 'r')
MY_PV=$(ver_rs 1 '' $(ver_rs 2 'r'))
DEBIAN_PATCH_VERSION=1

DESCRIPTION="Computing automorphism groups of graphs and digraphs"
HOMEPAGE="https://pallini.di.uniroma1.it/"

SRC_URI="https://pallini.di.uniroma1.it/${PN}${MY_PV}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${MY_PV1}+ds-${DEBIAN_PATCH_VERSION}.debian.tar.xz
	https://src.fedoraproject.org/rpms/nauty/raw/f35/f/nauty-includes.patch"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~riscv x86"
IUSE="examples"

BDEPEND="sys-apps/help2man"
DEPEND="dev-libs/gmp:0
	sys-libs/zlib
	sci-mathematics/cliquer"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}${MY_PV}"

DOCS=( schreier.txt formats.txt changes24-27.txt )

PATCHES=(
	"${WORKDIR}"/debian/patches/upstream-fix-gt_numorbits.patch
	"${WORKDIR}"/debian/patches/upstream-C2help2man.patch
	"${WORKDIR}"/debian/patches/upstream-autotoolization.patch
	"${DISTDIR}"/nauty-includes.patch
	"${WORKDIR}"/debian/patches/unbundle-cliquer.patch
)

src_prepare() {
	default
	rm makefile || die

	# The debian patch looks for <cliquer.h>, but the autotools-form of
	# cliquer installs that header as <cliquer/cliquer.h>.
	sed -e 's~<cliquer\.h>~<cliquer/cliquer\.h>~' -i nautycliquer.h || die

	# The debian autotools patch has only a placeholder in LT_INIT for
	# the version that we must provide.
	sed -e "s/@INJECTVER@/${PV}/" -i configure.ac || die

	# This is not great, since consumers should expect to see the
	# upstream versioning scheme in e.g. PKG_CHECK_MODULES. However, the
	# upstream version is next to impossible to use for comparisons, so
	# at least this fixes the QA warning and makes the pkg-config
	# version useful on Gentoo?
	sed -e "s/^Version:.*/Version: ${PV}/" -i nauty.pc.in || die

	eautoreconf
}

src_configure() {
	# Fedora has a patch to enable popcnt at runtime on CPUs that support it,
	# but their patch isn't applying cleanly. What's worse, the patch doesn't
	# support clang (bug 732020).
	econf --disable-static \
		  --disable-popcnt \
		  --enable-tls \
		  --enable-generic
}

src_install() {
	default

	if use examples; then
		docinto examples
		dodoc nautyex*.c
	fi

	find "${ED}" -name '*.la' -delete || die
}
