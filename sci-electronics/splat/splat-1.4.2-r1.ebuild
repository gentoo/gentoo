# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="RF Signal Propagation, Loss, And Terrain analysis tool"
HOMEPAGE="https://www.qsl.net/kd2bd/splat.html"
SRC_URI="https://www.qsl.net/kd2bd/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc hires l10n_es"

DEPEND="
	app-arch/bzip2
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.2-gcc43.patch
	"${FILESDIR}"/${PN}-1.4.2-drop-register-keyword.patch
)

src_configure() {
	# fake resulting file from interactive configuration script
	# using default resolution
	cat <<- EOF > "${S}/splat.h" || die
		/* Parameters for 3 arc-second standard resolution mode of operation */
		#define MAXPAGES 9
		#define HD_MODE 0
	EOF
	if use hires; then
		# fake resulting file from interactive configuration script
		# using default resolution
		cat <<- EOF > "${S}/hires.h" || die
			/* Parameters for 3 arc-second hires resolution mode of operation */
			#define MAXPAGES 9
			#define HD_MODE 1
	EOF
	fi
}

src_compile() {
	tc-export CC CXX

	cp {splat,rfsplat}.cpp || die
	emake LDLIBS="-lm -lbz2" -E "rfsplat: itwom3.0.o"
	if use hires; then
		cp {hires,splat}.h || die
		cp {splat,rfsplat-hd}.cpp || die
		emake LDLIBS="-lm -lbz2" -E "rfsplat-hd: itwom3.0.o"
	fi

	cd utils || die

	emake citydecoder usgs2sdf
	emake LDLIBS=-lbz2 srtm2sdf
	emake LDLIBS=-lm bearing
}

src_install() {
	local SPLAT_LANG="english"
	use l10n_es && SPLAT_LANG="spanish"
	# splat binary
	dobin rfsplat

	use hires && dobin rfsplat-hd

	# utilities
	dobin utils/{citydecoder,usgs2sdf,srtm2sdf,postdownload,bearing}
	newman docs/${SPLAT_LANG}/man/splat.man rfsplat.1

	dodoc CHANGES README utils/fips.txt
	newdoc utils/README README.UTILS

	use doc && dodoc docs/${SPLAT_LANG}/{pdf/splat.pdf,postscript/splat.ps}

	#sample data
	docinto sample_data
	dodoc -r sample_data/.
}

pkg_postinst() {
	elog "The original SPLAT! command got renamed to 'rfsplat' to avoid"
	elog "filename collision with app-portage/splat."
	elog ""
	elog "Be aware that it is still referenced as 'splat' in the documentation."
}
