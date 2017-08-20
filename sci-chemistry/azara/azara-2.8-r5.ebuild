# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1 toolchain-funcs

DESCRIPTION="A suite of programmes to process and view NMR data"
HOMEPAGE="http://www.bio.cam.ac.uk/azara/"
SRC_URI="http://www.bio.cam.ac.uk/ccpn/download/${PN}/${P}-src.tgz"

LICENSE="AZARA"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="xpm X"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	x11-libs/libX11
	x11-libs/motif:0
	${PYTHON_DEPS}
	xpm? ( x11-libs/libXpm )"
DEPEND="${RDEPEND}"

src_prepare() {
	cat > ENVIRONMENT <<- EOF
	CC=$(tc-getCC)
	CFLAGS = ${CFLAGS}
	LFLAGS = ${LDFLAGS}
	MATH_LIB = -lm
	X11_INCLUDE_DIR = -I"${EPREFIX}/usr/X11R6/include"
	MOTIF_INCLUDE_DIR = -I"${EPREFIX}/usr/include" -I../global
	X11_LIB_DIR = -L"${EPREFIX}/usr/$(get_libdir)"
	MOTIF_LIB_DIR = -L"${EPREFIX}/usr/$(get_libdir)"
	X11_LIB = -lX11
	MOTIF_LIB = -lXm -lXt
	SHARED_FLAGS = -shared
	ENDIAN_FLAG = -DBIG_ENDIAN_DATA -DWRITE_ENDIAN_PAR
	PIC = -fPIC
	EOF

	use xpm && echo "XPMUSE=\"XPM_FLAG=-DUSE_XPM XPM_LIB=-lXpm\"" >> ENVIRONMENT

	epatch \
		"${FILESDIR}"/${PV}-prll.patch \
		"${FILESDIR}"/${PV}-impl-dec.patch \
		"${FILESDIR}"/${PV}-python.patch \
		"${FILESDIR}"/${PV}-64bit.patch
}

src_compile() {
	local mymake
	local makeflags

	mymake="${mymake} help nongui"
	use X && mymake="${mymake} gui"

	emake ${mymake}

	compilation() {
		python_export PYTHON_CFLAGS PYTHON_LIBS
		cd "${BUILD_DIR}" || die
		emake DataRows_clean
		emake \
			PYTHON_INCLUDE_DIR="${PYTHON_CFLAGS}" \
			PYTHON_LIB="${PYTHON_LIBS}" \
			DataRows
	}
	python_copy_sources
	python_foreach_impl compilation
}

src_install() {
	rm bin/pythonAzara || die
	if ! use X; then
		rm bin/plot* || die
	fi

	dodoc CHANGES* README*
	dohtml -r html/*

	cd bin || die
	dobin ${PN}
	rm ${PN} || die
	for bin in *; do
		newbin ${bin} ${bin}-${PN}
	done

	installation() {
		cd "${BUILD_DIR}" || die
		python_domodule lib/DataRows.so
	}
	python_foreach_impl installation
}

pkg_postinst() {
	einfo "Due to collision we moved all binary to *-${PN}"
}
