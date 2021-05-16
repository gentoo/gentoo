# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

MY_PN="dxsamples"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Samples for IBM Data Explorer"
HOMEPAGE="http://www.opendx.org/"
SRC_URI="http://opendx.sdsc.edu/source/${MY_P}.tar.gz
	mirror://gentoo/${P}-install.patch.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="IBM"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=">=sci-visualization/opendx-4.4.4-r2"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-nojava.patch"
	"${WORKDIR}/${P}-install.patch"
)

src_prepare() {
	# absolutely no javadx for now
	default
	eautoreconf
}
