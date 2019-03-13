# Copyright 1999-2018 Gentoo Authors
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
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-macos"
	S="${WORKDIR}/${P#votca-}"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN/-//}.git"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Votca coarse-graining engine"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	~sci-libs/votca-tools-${PV}
	gromacs? ( <sci-chemistry/gromacs-2019_beta1:= )
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
		if use doc; then
			EGIT_REPO_URI="https://github.com/${PN/-//}-manual.git"
			EGIT_BRANCH="master"
			EGIT_CHECKOUT_DIR="${WORKDIR}/${PN}-manual"\
				git-r3_src_unpack
		fi
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
		-DWITH_H5MD=$(usex hdf5)
		-DWITH_RC_FILES=OFF
		-DLIB=$(get_libdir)
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
		if [[ ${PV} = *9999* ]]; then
			#we need to do that here, because we need an installed version of csg to build the manual
			[[ ${CHOST} = *-darwin* ]] && \
				emake -C "${WORKDIR}/${PN}"-manual PATH="${PATH}${PATH:+:}${ED}/usr/bin" DYLD_LIBRARY_PATH="${DYLD_LIBRARY_PATH}${DYLD_LIBRARY_PATH:+:}${ED}/usr/$(get_libdir)" \
				|| emake -C "${WORKDIR}/${PN}"-manual PATH="${PATH}${PATH:+:}${ED}/usr/bin" LD_LIBRARY_PATH="${LD_LIBRARY_PATH}${LD_LIBRARY_PATH:+:}${ED}/usr/$(get_libdir)"
			newdoc "${WORKDIR}/${PN}"-manual/manual.pdf "${PN}-manual-${PV}.pdf"
		else
			dodoc "${DISTDIR}/${PN}-manual-${PV}.pdf"
		fi
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
