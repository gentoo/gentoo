# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit fortran-2

DESCRIPTION="Protein X-ray crystallography toolkit -- meta package"
HOMEPAGE="http://www.ccp4.ac.uk/"
SRC_URI=""

LICENSE="ccp4"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="X arpwarp +balbes"

RDEPEND="
	~sci-chemistry/ccp4-apps-${PV}[X?]
	!<=sci-chemistry/ccp4-apps-${PV}-r2
	>=sci-chemistry/molrep-11.0.00-r1
	>=sci-chemistry/mosflm-7.0.6-r2
	sci-chemistry/mrbump[X?]
	>=sci-chemistry/oasis-4.0-r1
	>=sci-chemistry/pdb-extract-3.004-r2
	>=sci-chemistry/refmac-5.5.0110-r1
	>=sci-chemistry/scala-3.3.18-r1
	>=sci-chemistry/sfcheck-7.03.18-r1
	sci-chemistry/xia2
	arpwarp? ( sci-chemistry/arp-warp-bin )
	balbes? ( sci-chemistry/balbes )
	X? (
		~sci-chemistry/ccp4i-${PV}
		sci-chemistry/imosflm
		sci-chemistry/pymol
		sci-chemistry/rasmol
		)"
DEPEND=""
