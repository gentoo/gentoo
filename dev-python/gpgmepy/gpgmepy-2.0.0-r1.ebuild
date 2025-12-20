# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
inherit autotools distutils-r1

DESCRIPTION="GnuPG Made Easy is a library for making GnuPG easier to use (Python bindings)"
HOMEPAGE="https://www.gnupg.org/related_software/gpgme"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1+ test? ( GPL-2+ )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	!<app-crypt/gpgme-2[python(-)]

	>=app-crypt/gpgme-2:=
	>=dev-libs/libgpg-error-1.47:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	${DISTUTILS_DEPS}
	dev-lang/swig
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.0_pre20250603-python.patch
)

src_prepare() {
	# autoreconf adds '-unknown' suffix and may even blast the version away
	# entirely to 0.0.0.
	sed -i -e "s:mym4_version:${PV}:" configure.ac || die
	# The dynamic version machinery doesn't work with proper PEP517
	# builds, as it relies on a hack in setup.py.
	sed -i -e "s:dynamic = \[\"version\"\]:version = \"${PV}\":" pyproject.toml || die

	distutils-r1_src_prepare
	eautoreconf
}

python_configure() {
	mkdir "${BUILD_DIR}" || die
	cd "${BUILD_DIR}" || die

	local myeconfargs=(
		$(use_enable test gpg-test)

		PYTHON=${EPYTHON}
		PYTHONS=${EPYTHON}
		GPGRT_CONFIG="${ESYSROOT}/usr/bin/${CHOST}-gpgrt-config"
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
	emake -Onone prepare
}

python_compile() {
	# otherwise distutils will try to build out of S
	cd "${BUILD_DIR}" || die
	distutils-r1_python_compile
}

python_test() {
	emake -C "${BUILD_DIR}"/tests -Onone check \
		PYTHON=${EPYTHON} \
		PYTHONS=${EPYTHON} \
		TESTFLAGS="--python-libdir=${BUILD_DIR}/lib"
}
