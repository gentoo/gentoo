# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P="ccp4-${PV}"

SRC="ftp://ftp.ccp4.ac.uk/ccp4"
VERSION="10-11-08"

DESCRIPTION="The database for the BALBES automated crystallographic molecular replacement pipeline"
HOMEPAGE="http://www.ysbl.york.ac.uk/~fei/balbes/"
SRC_URI="${SRC}/${PV}/${MY_P}-${PN/-/}-${VERSION}.tar.gz"

LICENSE="ccp4"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

RDEPEND="
	>=dev-python/pyxml-0.8.4
	sci-libs/monomer-db"
DEPEND="${RDEPEND}"
RESTRICT="binchecks strip"

S="${WORKDIR}/${MY_P}"

src_install() {
	dodir /usr/share/balbes/BALBES_0.0.1
	rm -rf share/balbes/BALBES_0.0.1/dic || die
	# We don't want to wait around to copy all this, or suck up double
	# the disk space
	einfo "Installing files, which can take some time ..."
	mv "${S}"/share/balbes/BALBES_0.0.1/* "${ED}"/usr/share/balbes/BALBES_0.0.1/ || die
	# db files shouldn't be executable
	find "${ED}"/usr/share/balbes/BALBES_0.0.1/ \
		-type f \
		-exec chmod 664 '{}' \; || die
	dosym ../../ccp4/data/monomers /usr/share/balbes/BALBES_0.0.1/dic

	cat >> "${T}"/20balbes <<- EOF
	BALBES_ROOT="${EPREFIX}/usr/share/balbes/BALBES_0.0.1/"
	EOF

	doenvd "${T}"/20balbes
}
