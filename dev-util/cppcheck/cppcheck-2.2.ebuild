# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{3_6,3_7,3_8,3_9} )
inherit distutils-r1 toolchain-funcs cmake-utils

DESCRIPTION="Static analyzer of C/C++ code"
HOMEPAGE="https://github.com/danmar/cppcheck"
SRC_URI="https://github.com/danmar/cppcheck/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc64 ~sparc ~x86"
IUSE="htmlreport pcre qt5 +z3"

RDEPEND="
	htmlreport? ( dev-python/pygments[${PYTHON_USEDEP}] )
	pcre? ( dev-libs/libpcre )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtprintsupport:5
	)
"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
	z3? ( sci-mathematics/z3 )
"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {

	local mycmakeargs=(
		-DHAVE_RULES="$(usex pcre)"
		-DBUILD_GUI="$(usex qt5)"
		-DUSE_Z3="$(usex z3)"
		-DFILESDIR="usr/share/${PN}/"
		-ENABLE_OSS_FUZZ=OFF
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use htmlreport ; then
		pushd htmlreport || die
		distutils-r1_src_compile
		popd || die
	fi
}

src_install() {
	# it's not autotools-based, so "${ED}" here, not "${D}", bug 531760
	emake install DESTDIR="${ED}" \
		FILESDIR="usr/share/${PN}/"

	insinto "/usr/share/${PN}/cfg"
	doins cfg/*.cfg
	if use qt5 ; then
		dobin "${WORKDIR}/${P}_build/bin/${PN}-gui"
		dodoc gui/{projectfile.txt,gui.${PN}}
	fi
	if use htmlreport ; then
		pushd htmlreport || die
		distutils-r1_src_install
		popd || die
		find "${D}" -name "*.egg-info" -delete
	else
		rm "${ED}/usr/bin/cppcheck-htmlreport" || die
	fi

	dodoc -r tools/triage
}
