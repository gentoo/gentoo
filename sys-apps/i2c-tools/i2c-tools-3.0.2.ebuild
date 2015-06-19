# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/i2c-tools/i2c-tools-3.0.2.ebuild,v 1.6 2014/03/12 03:15:18 patrick Exp $

EAPI="3"
PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit flag-o-matic toolchain-funcs distutils

DESCRIPTION="I2C tools for bus probing, chip dumping, register-level access helpers, EEPROM decoding, and more"
HOMEPAGE="http://www.lm-sensors.org/wiki/I2CTools"
SRC_URI="http://dl.lm-sensors.org/i2c-tools/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~sparc x86"
IUSE="python"

DEPEND="!<sys-apps/lm_sensors-3"
RDEPEND="${DEPEND}"

pkg_setup() {
	use python && python_pkg_setup
}

src_compile() {
	emake CC=$(tc-getCC) CFLAGS="${CFLAGS}" || die
	if use python ; then
		cd py-smbus
		append-cppflags -I../include
		distutils_src_compile
	fi
}

src_install() {
	emake install prefix="${D}"/usr || die
	rm -rf "${D}"/usr/include # part of linux-headers
	dodoc CHANGES README
	local d
	for d in eeprom eepromer ; do
		docinto ${d}
		dodoc ${d}/README*
	done

	if use python ; then
		cd py-smbus
		docinto py-smbus
		dodoc README*
		distutils_src_install
	fi
}

pkg_postinst() {
	use python && distutils_pkg_postinst
}

pkg_postrm() {
	use python && distutils_pkg_postrm
}
