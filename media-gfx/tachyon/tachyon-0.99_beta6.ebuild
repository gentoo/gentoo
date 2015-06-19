# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/tachyon/tachyon-0.99_beta6.ebuild,v 1.2 2015/03/16 15:55:03 jlec Exp $

EAPI=5

inherit eutils toolchain-funcs

MY_PV=${PV/_beta/b}
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A portable, high performance parallel ray tracing system"
HOMEPAGE="http://jedi.ks.uiuc.edu/~johns/raytracer/"
SRC_URI="http://jedi.ks.uiuc.edu/~johns/raytracer/files/${MY_PV}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~x86 ~x64-macos ~x86-macos"
IUSE="doc examples jpeg mpi +opengl png threads"

CDEPEND="
	jpeg? ( virtual/jpeg:0= )
	mpi? ( virtual/mpi )
	opengl? (
		virtual/glu
		virtual/opengl
		)
	png? ( media-libs/libpng:0= )"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}"

REQUIRED_USE="^^ ( opengl mpi )"

S="${WORKDIR}/${PN}/unix"

pkg_setup() {
	local ostarget

	# TODO: Test on alpha, ia64
	# TODO: add other architectures
	# TODO: X, Motif, MBOX, Open Media Framework, Spaceball I/O, MGF ?
	TACHYON_MAKE_TARGET=

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
	emakeconf=()
	use jpeg && \
		emakeconf+=(
			USEJPEG=-DUSEJPEG
			JPEGLIB=-ljpeg
		)

	use png && \
		emakeconf+=(
			USEPNG=-DUSEPNG
			PNGINC="$($(tc-getPKG_CONFIG) --cflags libpng)"
			PNGLIB="$($(tc-getPKG_CONFIG) --libs libpng)"
			)

	if use mpi ; then
		sed \
			-e "s:MPIDIR=:MPIDIR=/usr:g" \
			-e "s:linux-lam:linux-mpi:g" \
			-i Make-config || die "sed failed"
	fi
	sed -i \
		-e "s:-O3::g;s:-g::g;s:-pg::g" \
		-e "s:-m32:${CFLAGS}:g" \
		-e "s:-m64:${CFLAGS}:g" \
		-e "s:-ffast-math::g" \
		-e "s:STRIP = strip:STRIP = touch:g" \
		-e "s:CC = *cc:CC = $(tc-getCC):g" \
		-e "s:-fomit-frame-pointer::g" Make-arch || die "sed failed"

	epatch \
		"${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${P}-shared.patch
}

src_compile() {
	emake ${TACHYON_MAKE_TARGET} "${emakeconf[@]}" VERSION=${PV}
}

src_install() {
	cd .. || die
	dodoc Changes README

	insinto /usr/include/${PN}
	doheader src/*.h

	use doc && dohtml docs/tachyon/*

	cd compile/${TACHYON_MAKE_TARGET} || die

	dobin ${PN}
	dolib.so lib${PN}.so*

	if use examples; then
		cd "${S}/../scenes" || die
		insinto "/usr/share/${PN}/examples"
		doins *
	fi
}
