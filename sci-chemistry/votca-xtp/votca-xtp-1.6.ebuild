# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit bash-completion-r1 cmake-utils multilib

IUSE=""
if [ "${PV}" != "9999" ]; then
	SRC_URI="https://github.com/${PN/-//}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-macos"
	S="${WORKDIR}/${P#votca-}"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN/-//}.git"
	KEYWORDS="amd64"
fi

DESCRIPTION="Votca excitation and charge properties module"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	~sci-libs/votca-tools-${PV}
	>=dev-cpp/eigen-3.3
	sci-libs/hdf5[cxx]
	~sci-chemistry/votca-csg-${PV}
	sci-libs/libxc"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( README.md NOTICE CHANGELOG.md )

pkg_postinst() {
	einfo
	einfo "Please read and cite:"
	einfo "VOTCA-XTP, J. Chem. Theo. Comp. 14, 6353 (2018)"
	einfo "https://doi.org/10.1021/acs.jctc.8b00617"
	einfo
}
