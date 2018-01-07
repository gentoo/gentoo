# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="RF Signal Propagation, Loss, And Terrain analysis tool"
HOMEPAGE="http://www.qsl.net/kd2bd/splat.html"
SRC_URI="http://www.qsl.net/kd2bd/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc hires l10n_es"

DEPEND="sys-libs/zlib
	app-arch/bzip2"

RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.2.2-gcc43.patch"
}

src_configure() {
	# fake resulting file from interactive configuration script
	# using default resolution
	cat <<- EOF > "${S}/splat.h"
		/* Parameters for 3 arc-second standard resolution mode of operation */
		#define MAXPAGES 9
		#define HD_MODE 0
	EOF
	if use hires; then
		# fake resulting file from interactive configuration script
		# using default resolution
		cat <<- EOF > "${S}/hires.h"
			/* Parameters for 3 arc-second hires resolution mode of operation */
			#define MAXPAGES 9
			#define HD_MODE 1
	EOF
	fi
}

src_compile() {

	local CC=$(tc-getCC) CXX=$(tc-getCXX)

	${CXX} -Wall ${CXXFLAGS} ${LDFLAGS} itwom3.0.cpp splat.cpp -o rfsplat -lm -lbz2 || die
	if use hires; then
		cp "${S}/hires.h" "${S}/splat.h"
		${CXX} -Wall ${CXXFLAGS} ${LDFLAGS} itwom3.0.cpp splat.cpp -o rfsplat-hd -lm -lbz2 || die
	fi

	cd utils
	${CC} -Wall ${CFLAGS} ${LDFLAGS} citydecoder.c -o citydecoder
	${CC} -Wall ${CFLAGS} ${LDFLAGS} usgs2sdf.c    -o usgs2sdf
	${CC} -Wall ${CFLAGS} ${LDFLAGS} srtm2sdf.c    -o srtm2sdf   -lbz2
	#${CC} -Wall ${CFLAGS} ${LDFLAGS} fontdata.c    -o fontdata   -lz
	${CC} -Wall ${CFLAGS} ${LDFLAGS} bearing.c     -o bearing    -lm
}

src_install() {
	local SPLAT_LANG="english"
	use l10n_es && SPLAT_LANG="spanish"
	# splat binary
	dobin rfsplat
	if use hires; then
		dobin rfsplat-hd
	fi

	# utilities
	dobin utils/{citydecoder,usgs2sdf,srtm2sdf,postdownload,bearing}
	newman docs/${SPLAT_LANG}/man/splat.man rfsplat.1

	dodoc CHANGES README utils/fips.txt
	newdoc utils/README README.UTILS

	if use doc; then
		dodoc docs/${SPLAT_LANG}/{pdf/splat.pdf,postscript/splat.ps}
	fi
	#sample data
	docinto sample_data
	dodoc sample_data/*
}

pkg_postinst() {
	elog "The original SPLAT! command got renamed to 'rfsplat' to avoid"
	elog "filename collission with app-portage/splat."
	elog ""
	elog "Be aware that it is still referenced as 'splat' in the documentation."
}
