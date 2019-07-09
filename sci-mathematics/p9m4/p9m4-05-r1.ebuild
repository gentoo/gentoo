# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="p9m4-v"
MY_P="${MY_PN}${PV}"

DESCRIPTION="This is a Graphical User Interface for Prover9 and Mace4"
HOMEPAGE="https://www.cs.unm.edu/~mccune/mace4/"
SRC_URI="
	https://www.cs.unm.edu/~mccune/prover9/gui/${MY_P}.tar.gz
	https://dev.gentoo.org/~gienah/2big4tree/sci-mathematics/p9m4/p9m4-v05-64bit.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="
	dev-python/wxpython[${PYTHON_USEDEP}]
	sci-mathematics/prover9"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=(
	"${WORKDIR}"/${MY_PN}05-64bit.patch
	"${FILESDIR}"/${MY_PN}05-use-inst-paths.patch
	"${FILESDIR}"/${MY_PN}05-package.patch
	"${FILESDIR}"/${MY_PN}05-python2.6.patch
)

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	distutils-r1_python_prepare_all

	rm -f \
		p9m4-v05/bin/prover9 \
		p9m4-v05/bin/mace4 \
		p9m4-v05/bin/interpformat \
		p9m4-v05/bin/prooftrans \
		p9m4-v05/bin/isofilter \
		p9m4-v05/bin/isofilter2 || die "Could not rm old executables"

	mkdir p9m4 || die "Could not create directory p9m4"
	mv Mac-setup.py \
		Win32-setup.py \
		control.py \
		files.py \
		my_setup.py \
		options.py \
		partition_input.py \
		platforms.py \
		utilities.py \
		wx_utilities.py \
		p9m4 \
		|| die "Could not move package p9m4 python files to p9m4 directory"
	touch p9m4/__init__.py \
		|| die "Could not create empty p9m4/__init__.py file"
}

python_install_all() {
	distutils-r1_python_install_all

	dosym prover9-mace4.py /usr/bin/prover9-mace4

	insinto /usr/share/${PN}/Images
	doins Images/*.{gif,ico}

	if use examples; then
		insinto /usr/share/${PN}/Samples
		doins Samples/*.in

		insinto /usr/share/${PN}/Samples/Equality/Mace4
		doins Samples/Equality/Mace4/*.in

		insinto /usr/share/${PN}/Samples/Equality/Prover9
		doins Samples/Equality/Prover9/*.in

		insinto /usr/share/${PN}/Samples/Non-Equality/Mace4
		doins Samples/Non-Equality/Mace4/*.in

		insinto /usr/share/${PN}/Samples/Non-Equality/Prover9
		doins Samples/Non-Equality/Prover9/*.in
	fi
}
