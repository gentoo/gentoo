# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit bash-completion-r1 cmake-utils multilib

IUSE="doc examples extras +gromacs +system-boost"
PDEPEND="extras? ( =sci-chemistry/votca-csgapps-${PV} )"
if [ "${PV}" != "9999" ]; then
	SRC_URI="http://votca.googlecode.com/files/${PF}.tar.gz
		doc? ( http://votca.googlecode.com/files/${PN}-manual-${PV}.pdf )
		examples? (	http://votca.googlecode.com/files/${PN}-tutorials-${PV}.tar.gz )"
	RESTRICT="primaryuri"
else
	SRC_URI=""
	inherit mercurial
	EHG_REPO_URI="https://csg.votca.googlecode.com/hg"
	PDEPEND="${PDEPEND} doc? ( =app-doc/${PN}-manual-${PV} )
		examples? ( =sci-chemistry/${PN}-tutorials-${PV} )"
fi

DESCRIPTION="Votca coarse-graining engine"
HOMEPAGE="http://www.votca.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-macos"

RDEPEND="=sci-libs/votca-tools-${PV}[system-boost=]
	gromacs? ( sci-chemistry/gromacs )
	dev-lang/perl
	app-shells/bash"

DEPEND="${RDEPEND}
	doc? ( || ( <app-doc/doxygen-1.7.6.1[-nodot] >=app-doc/doxygen-1.7.6.1[dot] ) )
	>=app-text/txt2tags-2.5
	virtual/pkgconfig"

src_configure() {
	local extra="-DWITH_GMX_DEVEL=OFF"

	use gromacs && has_version =sci-chemistry/gromacs-9999 && \
		extra="-DWITH_GMX_DEVEL=ON"

	#to create man pages, build tree binaries are executed (bug #398437)
	[[ ${CHOST} = *-darwin* ]] && \
		extra+=" -DCMAKE_BUILD_WITH_INSTALL_RPATH=OFF"

	mycmakeargs=(
		$(cmake-utils_use system-boost EXTERNAL_BOOST)
		$(cmake-utils_use_with gromacs GMX)
		${extra}
		-DWITH_RC_FILES=OFF
		-DLIB=$(get_libdir)
	)
	cmake-utils_src_configure
}

src_install() {
	DOCS=(README NOTICE ${CMAKE_BUILD_DIR}/CHANGELOG)
	newbashcomp scripts/csg-completion.bash ${PN}
	cmake-utils_src_install
	if use doc; then
		if [ -n "${PV##*9999}" ]; then
			dodoc "${DISTDIR}/${PN}-manual-${PV}.pdf"
		fi
		cd "${CMAKE_BUILD_DIR}" || die
		cd share/doc || die
		doxygen || die
		dohtml -r html/*
	fi
	if use examples && [ -n "${PV##*9999}" ]; then
		insinto "/usr/share/doc/${PF}/tutorials"
		docompress -x "/usr/share/doc/${PF}/tutorials"
		doins -r "${WORKDIR}/${PN}-tutorials-${PV}"/*
	fi
}

pkg_postinst() {
	einfo
	einfo "Please read and cite:"
	einfo "VOTCA, J. Chem. Theory Comput. 5, 3211 (2009). "
	einfo "http://dx.doi.org/10.1021/ct900369w"
	einfo
}
