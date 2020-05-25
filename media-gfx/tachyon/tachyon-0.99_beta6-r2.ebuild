# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs

MY_PV="${PV/_beta/b}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A portable, high performance parallel ray tracing system"
HOMEPAGE="http://jedi.ks.uiuc.edu/~johns/raytracer/"
SRC_URI="http://jedi.ks.uiuc.edu/~johns/raytracer/files/${MY_PV}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~x86 ~x64-macos ~x86-macos"
IUSE="doc examples jpeg mpi +opengl openmp png threads"

PATCHES=(	"${FILESDIR}/${PF}-ldflags.patch"
		"${FILESDIR}/${PF}-shared.patch"  )

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

S="${WORKDIR}/${PN}/unix"

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

	LIBSLINE='"'
	CFLAGSLINE='"'
	use mpi || CCLINE='"CC = $(tc-getCC)"'
	use mpi && CCLINE='"CC = mpicc"'
	LIBSLINE+="LIBS = -L. -ltachyon \$(MISCLIB) -lm"
	CFLAGSLINE+="CFLAGS = -DLinux \$(MISCFLAGS)"

	use threads && CFLAGSLINE+=" \$(THREADSFLAGS) -D_REENTRANT"
	use threads && LIBSLINE+=" -lpthread"
	use openmp && CFLAGSLINE+=" -fopenmp -D_REENTRANT"
	use opengl && CFLAGSLINE+=" -DUSEOPENGL \$(LINUX_GLX_INCS)"
	use opengl && LIBSLINE+=" \$(LINUX_GLX_LIBS)"
	use mpi && CFLAGSLINE+=" \$(MPIFLAGS)"

	CFLAGSLINE+=" ${CFLAGS}"
	CFLAGSLINE+='" \'
	LIBSLINE+=" ${LDFLAGS}"
	LIBSLINE+='" \'

	export TACHYON_MAKE_TARGET="gentoo"

	echo "gentoo:" >> Make-arch
	echo "	\$(MAKE) all \\" >> Make-arch
	echo '	"ARCH = gentoo" \' >> Make-arch
	echo '	"STRIP = touch" \' >> Make-arch
	echo "	${LIBSLINE}" >> Make-arch
	echo "	${CFLAGSLINE}" >> Make-arch
	echo "	${CCLINE}" >> Make-arch

	default
}

src_compile() {
	emake "${TACHYON_MAKE_TARGET}" "${emakeconf[@]}" VERSION="${PV}"
}

src_install() {
	cd .. || die
	dodoc Changes README

	insinto "/usr/include/${PN}"
	doins src/*.h

	use doc && docinto html && dodoc -r docs/tachyon/.

	cd "compile/${TACHYON_MAKE_TARGET}" || die

	dobin "${PN}"
	dolib.so lib${PN}.so*

	if use examples; then
		cd "${S}/../scenes" || die
		insinto "/usr/share/${PN}/examples"
		doins *
	fi
}
