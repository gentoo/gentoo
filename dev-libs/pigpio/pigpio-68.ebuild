# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7}} )

inherit distutils-r1 systemd toolchain-funcs

DESCRIPTION="A library for the Raspberry which allows control of the GPIOs"
HOMEPAGE="http://abyz.me.uk/rpi/pigpio/index.html"
SRC_URI="https://github.com/joan2937/pigpio/archive/V${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~arm"
IUSE="python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

src_prepare() {
	eapply "${FILESDIR}/${PN}-67-makefile.patch"
	eapply_user
}

src_compile() {
	emake CC="$(tc-getCC)" STRIP=: STRIPLIB=: SIZE=:
	use python && distutils-r1_src_compile
}

src_install() {
	emake DESTDIR="${D}" LDCONFIG=: PYTHON2=: PYTHON3=: \
		libdir="${EPREFIX}/usr/$(get_libdir)" prefix="${EPREFIX}/usr" \
		mandir="${EPREFIX}/usr/share/man" install
	einstalldocs
	newinitd "${FILESDIR}"/pigpiod.initd pigpiod
	newconfd "${FILESDIR}"/pigpiod.confd pigpiod
	systemd_newunit "${FILESDIR}"/pigpiod.systemd pigpiod.service
	use python && distutils-r1_src_install
}
