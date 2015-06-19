# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/raspberrypi-mkimage/raspberrypi-mkimage-0_p20120201.ebuild,v 1.4 2015/04/08 18:23:44 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit eutils distutils-r1

DESCRIPTION="Raspberry Pi kernel mangling tool mkimage/imagetool-uncompressed.py"
HOMEPAGE="https://github.com/raspberrypi/tools/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
RDEPEND="${PYTHON_DEPS}"

src_unpack() {
	mkdir "${S}" || die
	cp {"${FILESDIR}"/${P}-,"${S}"/}imagetool-uncompressed.py || die
}

python_prepare_all() {
	epatch "${FILESDIR}"/${P}-imagetool-uncompressed.patch
	sed -e '/^load_to_mem("/s:(":("'${EPREFIX}'/usr/share/'${PN}'/:' \
		-e '1s:python2:python:' \
		-i imagetool-uncompressed.py || die
	python_copy_sources
}

python_prepare() {
	cd "${BUILD_DIR}" || die
	case ${EPYTHON} in
		python3.1|python3.2|python3.3)
			epatch "${FILESDIR}"/${P}-imagetool-uncompressed-python3.patch
			;;
	esac
}

python_compile() { :; }

python_install() {
	cd "${BUILD_DIR}" || die
	python_doscript imagetool-uncompressed.py
}

python_install_all() {
	insinto /usr/share/${PN}
	newins {"${FILESDIR}"/${P}-,}args-uncompressed.txt
	newins {"${FILESDIR}"/${P}-,}boot-uncompressed.txt
}
