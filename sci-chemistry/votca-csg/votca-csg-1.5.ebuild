# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MAKEFILE_GENERATOR="ninja"

inherit bash-completion-r1 cmake-utils multilib

IUSE="doc examples extras +gromacs hdf5"
PDEPEND="extras? ( ~sci-chemistry/${PN}apps-${PV} )"
if [ "${PV}" != "9999" ]; then
	SRC_URI="https://github.com/${PN/-//}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		doc? ( https://github.com/${PN/-//}-manual/releases/download/v${PV}/${PN}-manual-${PV}.pdf )
		examples? (	https://github.com/${PN/-//}-tutorials/archive/v${PV}.tar.gz -> ${PN}-tutorials-${PV}.tar.gz )"
	KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-macos"
	S="${WORKDIR}/${P#votca-}"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN/-//}.git"
	KEYWORDS="amd64"
	PDEPEND="${PDEPEND} doc? ( ~app-doc/${PN}-manual-${PV} )"
fi

DESCRIPTION="Votca coarse-graining engine"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	~sci-libs/votca-tools-${PV}
	>=dev-cpp/eigen-3.3
	gromacs? ( sci-chemistry/gromacs:= )
	hdf5? ( sci-libs/hdf5 )
	dev-lang/perl
	app-shells/bash:*"

DEPEND="${RDEPEND}
	doc? (
		app-doc/doxygen[dot]
		dev-texlive/texlive-latexextra
		virtual/latex-base
		dev-tex/pgf
	)
	>=app-text/txt2tags-2.5
	virtual/pkgconfig"

DOCS=( README.md NOTICE CHANGELOG.md )

src_unpack() {
	if [[ ${PV} != *9999 ]]; then
		default
	else
		git-r3_src_unpack
		if use examples; then
			EGIT_REPO_URI="https://github.com/${PN/-//}-tutorials.git"
			EGIT_BRANCH="master"
			EGIT_CHECKOUT_DIR="${WORKDIR}/${PN#votca-}-tutorials"\
				git-r3_src_unpack
		fi
	fi
}

src_configure() {
	mycmakeargs=(
		-DWITH_GMX=$(usex gromacs)
		-DCMAKE_DISABLE_FIND_PACKAGE_HDF5=$(usex '!hdf5')
		-DWITH_RC_FILES=OFF
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	newbashcomp scripts/csg-completion.bash csg_call
	for i in "${ED}"/usr/bin/csg_*; do
		[[ ${i} = *csg_call ]] && continue
		bashcomp_alias csg_call "${i##*/}"
	done
	if use doc; then
		[[ ${PV} != *9999* ]] && dodoc "${DISTDIR}/${PN}-manual-${PV}.pdf"
		cmake-utils_src_make -C "${CMAKE_BUILD_DIR}" html
		dodoc -r "${CMAKE_BUILD_DIR}"/share/doc/html
	fi
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
