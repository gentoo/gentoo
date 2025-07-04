# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
inherit autotools distutils-r1

GPGMEPY_COMMIT="1c2c1c0b41af5e34e4f6897639fa41ef3932ec7d"
DESCRIPTION="GnuPG Made Easy is a library for making GnuPG easier to use (Python bindings)"
HOMEPAGE="https://www.gnupg.org/related_software/gpgme"
SRC_URI="https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gpgmepy.git;a=snapshot;h=${GPGMEPY_COMMIT};sf=tgz -> ${P}.tar.gz"
#SRC_URI="
#	mirror://gnupg/${PN}/${P}.tar.xz
#	verify-sig? ( mirror://gnupg/${PN}/${P}.tar.xz.sig )
#"
S="${WORKDIR}"/${PN}-${GPGMEPY_COMMIT:0:7}

LICENSE="LGPL-2.1+ test? ( GPL-2+ )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
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
	distutils-r1_src_prepare
	eautoreconf
}

python_configure() {
	local myeconfargs=(
		$(use_enable test gpg-test)

		PYTHON=${EPYTHON}
		PYTHONS=${EPYTHON}
		GPGRT_CONFIG="${ESYSROOT}/usr/bin/${CHOST}-gpgrt-config"
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
	emake -Onone prepare
}

python_test() {
	emake -C tests -Onone check \
		PYTHON=${EPYTHON} \
		PYTHONS=${EPYTHON} \
		TESTFLAGS="--python-libdir=${BUILD_DIR}/lib"
}
