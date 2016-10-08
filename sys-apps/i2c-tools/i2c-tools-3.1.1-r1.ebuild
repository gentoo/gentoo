# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )
DISTUTILS_OPTIONAL="1"

inherit flag-o-matic toolchain-funcs distutils-r1

DESCRIPTION="I2C tools for bus probing, chip dumping, register-level access helpers, EEPROM decoding, and more"
HOMEPAGE="http://www.lm-sensors.org/wiki/I2CTools"
SRC_URI="http://dl.lm-sensors.org/i2c-tools/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="python"

RDEPEND="!<sys-apps/lm_sensors-3
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.1.1-python-3.patch #492632
	use python && distutils-r1_src_prepare
}

src_configure() {
	use python && distutils-r1_src_configure
}

src_compile() {
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS}"
	emake -C eepromer CC=$(tc-getCC) CFLAGS="${CFLAGS} -I../include"
	if use python ; then
		cd py-smbus || die
		append-cppflags -I../include
		distutils-r1_src_compile
	fi
}

src_install() {
	emake install prefix="${D}"/usr
	dosbin eepromer/eepro{g,m{,er}}
	rm -rf "${D}"/usr/include # part of linux-headers
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
