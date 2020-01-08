# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )
DISTUTILS_OPTIONAL="1"

inherit distutils-r1 flag-o-matic toolchain-funcs

DESCRIPTION="I2C tools for bus probing, chip dumping, EEPROM decoding, and more"
HOMEPAGE="https://www.kernel.org/pub/software/utils/i2c-tools"
SRC_URI="https://www.kernel.org/pub/software/utils/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~mips ~ppc ~ppc64 ~sparc x86"
IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	use python && distutils-r1_src_prepare
}

src_configure() {
	use python && distutils-r1_src_configure
}

src_compile() {
	emake all-lib AR=$(tc-getAR) CC=$(tc-getCC) # parallel make
	emake CC=$(tc-getCC)
	emake -C eepromer CC=$(tc-getCC) CFLAGS="${CFLAGS}"
	if use python ; then
		cd py-smbus || die
		append-cppflags -I../include
		distutils-r1_src_compile
	fi
}

src_install() {
	emake install-lib install libdir="${D}"/usr/$(get_libdir) prefix="${D}"/usr
	dosbin eepromer/eeprom{,er}
	rm -rf "${D}"/usr/include || die # part of linux-headers
	dodoc CHANGES README
	local d
	for d in eeprom eepromer ; do
		docinto ${d}
		dodoc ${d}/README*
	done

	if use python ; then
		cd py-smbus || die
		docinto py-smbus
		dodoc README*
		distutils-r1_src_install
	fi
}
