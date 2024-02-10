# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{9..11} )

inherit bash-completion-r1 cmake python-single-r1

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/votca/votca.git"
else
	if [[ ${PV} = *_rc[1-9] ]]; then
		MY_PV="${PV%%_rc*}-rc.${PV##*_rc}"
	else
		MY_PV="${PV}"
	fi
	SRC_URI="https://github.com/votca/votca/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~x86 ~amd64-linux"
	S="${WORKDIR}/votca-${MY_PV}"
fi

DESCRIPTION="Versatile Object-oriented Toolkit for Coarse-graining Applications"
HOMEPAGE="https://www.votca.org/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+gromacs test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	!sci-libs/votca-tools
	!sci-chemistry/votca-csg
	!sci-chemistry/votca-xtp
	${PYTHON_DEPS}
	app-shells/bash:*
	>=dev-cpp/eigen-3.3
	dev-libs/boost:=
	dev-libs/expat
	sci-libs/fftw:3.0=
	dev-lang/perl
	gromacs? ( sci-chemistry/gromacs:=[gmxapi-legacy(+)] )
	sci-libs/hdf5[cxx]
	sci-libs/libxc
	sci-libs/libint:2
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( README.rst NOTICE.rst CHANGELOG.rst )

src_prepare() {
	# espressopp was removed from gentoo
	rm -r ./csg-tutorials/spce/ibi_espressopp || die
	python_fix_shebang .
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_TESTING=$(usex test)
		-DCMAKE_DISABLE_FIND_PACKAGE_GROMACS=$(usex !gromacs)
		-DBUILD_CSGAPPS=ON
		-DINSTALL_RC_FILES=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_MKL=ON
	)
	cmake_src_configure
}

pkg_postinst() {
	einfo
	einfo "Please read and cite:"
	einfo "VOTCA-XTP, J. Chem. Theo. Comp. 14, 6353 (2018)"
	einfo "https://doi.org/10.1021/acs.jctc.8b00617"
	einfo
	einfo "VOTCA, J. Chem. Theory Comput. 5, 3211 (2009). "
	einfo "https://dx.doi.org/10.1021/ct900369w"
	einfo
}
