# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils toolchain-funcs

DESCRIPTION="A portable, high performance parallel ray tracing system"
HOMEPAGE="http://jedi.ks.uiuc.edu/~johns/raytracer/"
SRC_URI="http://jedi.ks.uiuc.edu/~johns/raytracer/files/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~x86 ~x64-macos ~x86-macos"
IUSE="doc examples jpeg mpi +opengl png threads"

CDEPEND="
	jpeg? ( virtual/jpeg:0 )
	mpi? ( virtual/mpi )
	opengl? (
		virtual/glu
		virtual/opengl )
	png? ( media-libs/libpng:0 )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}"

REQUIRED_USE="^^ ( opengl mpi )"

S="${WORKDIR}/${PN}/unix"

# TODO: Test on alpha, ia64, ppc
# TODO: add other architectures
# TODO: X, Motif, MBOX, Open Media Framework, Spaceball I/O, MGF ?

TACHYON_MAKE_TARGET=

pkg_setup() {
	local ostarget
	case ${CHOST} in
		powerpc*-darwin*)   ostarget=macosx      ;;
		*86*-darwin*)       ostarget=macosx-x86  ;;
		*)					ostarget=linux       ;;
	esac

	if use threads ; then
		if use opengl ; then
			TACHYON_MAKE_TARGET=${ostarget}-thr-ogl
		elif use mpi ; then
			TACHYON_MAKE_TARGET=${ostarget}-mpi-thr
		else
			TACHYON_MAKE_TARGET=${ostarget}-thr
		fi

		# TODO: Support for linux-athlon-thr ?
	else
		if use mpi ; then
			TACHYON_MAKE_TARGET=${ostarget}-mpi
		else
			TACHYON_MAKE_TARGET=${ostarget}
		fi
	fi

	if [[ -z "${TACHYON_MAKE_TARGET}" ]]; then
		die "No target found, check use flags"
	else
		einfo "Using target: ${TACHYON_MAKE_TARGET}"
	fi
}

src_prepare() {
	if use jpeg ; then
		sed -i \
			-e "s:USEJPEG=:USEJPEG=-DUSEJPEG:g" \
			-e "s:JPEGLIB=:JPEGLIB=-ljpeg:g" Make-config \
			|| die "sed failed"
	fi

	if use png ; then
		sed -i \
			-e "s:USEPNG=:USEPNG=-DUSEPNG:g" \
			-e "s:PNGINC=:PNGINC=$(pkg-config libpng --cflags):g" \
			-e "s:PNGLIB=:PNGLIB=$(pkg-config libpng --libs):g" Make-config \
			|| die "sed failed"
	fi

	if use mpi ; then
		sed -i "s:MPIDIR=:MPIDIR=/usr:g" Make-config || die "sed failed"
		sed -i "s:linux-lam:linux-mpi:g" Make-config || die "sed failed"
	fi
	sed -i \
		-e "s:-O3::g;s:-g::g;s:-pg::g" \
		-e "s:-m32:${CFLAGS}:g" \
		-e "s:-m64:${CFLAGS}:g" \
		-e "s:-ffast-math::g" \
		-e "s:STRIP = strip:STRIP = touch:g" \
		-e "s:CC = *cc:CC = $(tc-getCC):g" \
		-e "s:-fomit-frame-pointer::g" Make-arch || die "sed failed"

	epatch "${FILESDIR}"/${PV}-ldflags.patch
}

src_compile() {
	emake ${TACHYON_MAKE_TARGET}
}

src_install() {
	cd ..
	dodoc Changes README

	use doc && dohtml docs/tachyon/*

	cd compile/${TACHYON_MAKE_TARGET}

	dobin ${PN}

	if use examples; then
		cd "${S}/../scenes"
		insinto "/usr/share/${PN}/examples"
		doins *
	fi
}
