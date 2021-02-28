# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 cmake

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN/-//}.git"
else
	SRC_URI="https://github.com/${PN/-//}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		examples? (	https://github.com/${PN/-//}-tutorials/archive/v${PV}.tar.gz -> ${PN}-tutorials-${PV}.tar.gz )"
	KEYWORDS="~amd64 ~x86 ~amd64-linux"
	S="${WORKDIR}/${P#votca-}"
fi

DESCRIPTION="Votca coarse-graining engine"
HOMEPAGE="https://www.votca.org/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="doc examples extras +gromacs hdf5"

RDEPEND="
	app-shells/bash:*
	>=dev-cpp/eigen-3.3
	dev-lang/perl
	~sci-libs/votca-tools-${PV}
	gromacs? ( sci-chemistry/gromacs:= )
	hdf5? ( sci-libs/hdf5 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=app-text/txt2tags-2.5
	virtual/pkgconfig
"

DOCS=( README.rst NOTICE.rst CHANGELOG.rst )

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
		if use examples; then
			EGIT_REPO_URI="https://github.com/${PN/-//}-tutorials.git"
			EGIT_BRANCH="master"
			EGIT_CHECKOUT_DIR="${WORKDIR}/${PN#votca-}-tutorials" \
				git-r3_src_unpack
		fi
	else
		default
	fi
}

src_configure() {
	local mycmakeargs=(
		-DWITH_GMX=$(usex gromacs)
		-DCMAKE_DISABLE_FIND_PACKAGE_HDF5=$(usex !hdf5)
		-DWITH_RC_FILES=OFF
		-DBUILD_CSGAPPS=ON
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	newbashcomp "${ED}"/usr/share/votca/rc/csg-completion.bash csg_call
	for i in "${ED}"/usr/bin/csg_*; do
		[[ ${i} = *csg_call ]] && continue
		bashcomp_alias csg_call "${i##*/}"
	done
	if use examples; then
		insinto "/usr/share/doc/${PF}/tutorials"
		docompress -x "/usr/share/doc/${PF}/tutorials"
		rm -rf "${WORKDIR}/${PN#votca-}"-tutorials*/CMake*
		doins -r "${WORKDIR}/${PN#votca-}"-tutorials*/*
	fi
}

pkg_postinst() {
	einfo
	einfo "Please read and cite:"
	einfo "VOTCA, J. Chem. Theory Comput. 5, 3211 (2009). "
	einfo "https://dx.doi.org/10.1021/ct900369w"
	einfo
}
