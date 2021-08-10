# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 cmake

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN/-//}.git"
else
	SRC_URI="https://github.com/${PN/-//}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86 ~amd64-linux"
	S="${WORKDIR}/${P#votca-}"
fi

DESCRIPTION="Votca excitation and charge properties module"
HOMEPAGE="https://www.votca.org/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-cpp/eigen-3.3
	~sci-chemistry/votca-csg-${PV}
	sci-libs/hdf5[cxx]
	sci-libs/libxc
	~sci-libs/votca-tools-${PV}
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( README.md NOTICE CHANGELOG.md )

pkg_postinst() {
	einfo
	einfo "Please read and cite:"
	einfo "VOTCA-XTP, J. Chem. Theo. Comp. 14, 6353 (2018)"
	einfo "https://doi.org/10.1021/acs.jctc.8b00617"
	einfo
}
