# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6,3_7} )
DISTUTILS_OPTIONAL="1"

inherit distutils-r1 flag-o-matic toolchain-funcs

DESCRIPTION="I2C tools for bus probing, chip dumping, EEPROM decoding, and more"
HOMEPAGE="https://www.kernel.org/pub/software/utils/i2c-tools"
SRC_URI="${HOMEPAGE}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="!<sys-apps/lm_sensors-3
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
	emake  AR=$(tc-getAR) CC=$(tc-getCC) all-lib # parallel make
	emake CC=$(tc-getCC)
	emake -C eepromer CC=$(tc-getCC) CFLAGS="${CFLAGS}"

	if use python ; then
		cd py-smbus || die
		append-cppflags -I../include
		distutils-r1_src_compile
	fi
}

src_install() {
	emake DESTDIR="${D}" libdir="/usr/$(get_libdir)" PREFIX="/usr" install-lib install
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

	if ! use static-libs; then
		rm -rf "${D}"/usr/$(get_libdir)/libi2c.a || die
	fi
}
