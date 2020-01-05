# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )
DISTUTILS_IN_SOURCE_BUILD=1

inherit distutils-r1

DESCRIPTION="Raspberry Pi kernel mangling tool mkimage/imagetool-uncompressed.py"
HOMEPAGE="https://github.com/raspberrypi/tools/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

PATCHES=( "${FILESDIR}"/${P}-imagetool-uncompressed.patch )

src_unpack() {
	mkdir "${S}" || die
	cp {"${FILESDIR}"/${P}-,"${S}"/}imagetool-uncompressed.py || die
}

python_prepare_all() {
	sed -e '/^load_to_mem("/s:(":("'${EPREFIX}'/usr/share/'${PN}'/:' \
		-e '1s:python2:python:' \
		-i imagetool-uncompressed.py || die

	distutils-r1_python_prepare_all
}

python_prepare() {
	if python_is_python3; then
		eapply "${FILESDIR}"/${P}-imagetool-uncompressed-python3.patch
	fi
}

python_compile() { :; }

python_install() {
	python_doscript imagetool-uncompressed.py
}

python_install_all() {
	insinto /usr/share/${PN}
	newins {"${FILESDIR}"/${P}-,}args-uncompressed.txt
	newins {"${FILESDIR}"/${P}-,}boot-uncompressed.txt

	distutils-r1_python_install_all
}
