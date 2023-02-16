# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit cmake desktop optfeature python-single-r1

DESCRIPTION="Shane's Chess Information Database"
HOMEPAGE="http://scid.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/scid/${PN}-code-${PV}.zip
	mirror://sourceforge/scid/${P}_x64_linux.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="photos scripts test"
REQUIRED_USE="scripts? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-lang/tcl:=
	dev-lang/tk"
RDEPEND="
	${COMMON_DEPEND}
	dev-tcltk/tkimg
	scripts? ( ${PYTHON_DEPS} )"
DEPEND="
	${COMMON_DEPEND}
	test? ( dev-cpp/gtest )"
BDEPEND="
	app-arch/unzip
	scripts? ( ${PYTHON_DEPS} )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.6.2-pgnfix-python3.patch
	"${FILESDIR}"/${P}-system-gtest.patch
	"${FILESDIR}"/${P}-tcl-start-path.patch
)

HTML_DOCS=( help/. )

pkg_setup() {
	use scripts && python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare

	if use scripts; then
		python_fix_shebang scripts/pgnfix.py

		# cmake build doesn't use "tkscid" anymore but scripts still do
		sed -i s/tkscid/scid/ scripts/*.tcl || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=off
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr/share
		-DGTEST=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	"${BUILD_DIR}"/gtest/scid_tests || die
}

src_install() {
	cmake_src_install

	dobin "${BUILD_DIR}"/{phalanx-scid,scid,scidlet}

	if use scripts; then
		local script
		# install same set of scripts as pre-cmake
		for script in pgnfix.py {sc_{epgn,spell,eco,import},scidpgn,spliteco,spf2spi}.tcl sc_remote.tk; do
			newbin scripts/${script} ${script%.*}
		done
	fi

	insinto /usr/share/scid
	doins scid{,_es,_fr}.eco "${WORKDIR}"/${P}/spelling.ssp
	use photos && doins -r "${WORKDIR}"/${P}/photos

	newicon resources/svg/scid_app.svg scid.svg
	make_desktop_entry scid Scid

	# delete re-located files
	rm -r "${ED}"/usr/share/{bin,scid/{scid,scripts}} || die
}

pkg_postinst() {
	optfeature "speech support" dev-tcltk/snack

	if [[ ${REPLACING_VERSIONS} ]] && ver_test ${REPLACING_VERSIONS} -lt 4.7; then
		elog
		elog "Warning: this version uses ~/.scid4.7 and is incompatible with older ~/.scid"
		elog
	fi
}
