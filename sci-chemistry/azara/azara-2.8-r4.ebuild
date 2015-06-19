# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/azara/azara-2.8-r4.ebuild,v 1.5 2014/07/06 11:24:53 jlec Exp $

EAPI=3

PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-*"

inherit eutils python toolchain-funcs

DESCRIPTION="A suite of programmes to process and view NMR data"
HOMEPAGE="http://www.bio.cam.ac.uk/azara/"
SRC_URI="http://www.bio.cam.ac.uk/ccpn/download/${PN}/${P}-src.tgz"

LICENSE="AZARA"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="python xpm X"

RDEPEND="
	x11-libs/libX11
	x11-libs/motif:0
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

	emake ${mymake} || die

	compilation() {
		emake DataRows_clean || die
		emake \
			PYTHON_INCLUDE_DIR="-I${EPREFIX}/$(python_get_includedir)" \
			PYTHON_LIB="$(python_get_library -l)" \
			DataRows || die
	}
	use python && python_execute_function compilation
}

src_install() {
	rm bin/pythonAzara || die
	if ! use X; then
		rm bin/plot* || die
	fi

	dodoc CHANGES* README* || die
	dohtml -r html/* || die

	installation() {
		insinto $(python_get_sitedir)
		doins lib/DataRows.so || die
	}
	use python && python_execute_function installation

	cd bin
	dobin ${PN}|| die
	rm ${PN}
	for bin in *; do
		newbin ${bin} ${bin}-${PN} || die "failed to install ${bin}"
	done
}

pkg_postinst() {
	einfo "Due to collision we moved all binary to *-${PN}"
}
