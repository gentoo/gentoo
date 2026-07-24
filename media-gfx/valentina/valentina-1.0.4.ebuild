# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo flag-o-matic multiprocessing optfeature qmake-utils toolchain-funcs xdg

DESCRIPTION="Cloth patternmaking software"
HOMEPAGE="https://smart-pattern.com.ua/"
SRC_URI="https://gitlab.com/smart-pattern/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/xerces-c:=
	dev-qt/qtbase:6[concurrent,gui,network,opengl,ssl,widgets,xml]
	dev-qt/qtsvg:6
	!sci-biology/tree-puzzle
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-build/meson-format-array
	dev-qt/qttools:6[linguist]
	dev-util/qbs
"

qbs_format_flags() {
	meson-format-array "${@}" || die
}

qbs_config() {
	debug-print-function ${FUNCNAME} "${@}"

	(( $# == 2 )) || \
		die "${FUNCNAME} takes exactly two arguments"

	local key=${1}
	local value=${2}

	edo qbs config "profiles.gentoo.${key}" "${value}"
}

src_configure() {
	# setup the toolchain in a profile 'mytoolchain'
	edo qbs setup-toolchains "$(tc-getCC)" mytoolchain

	# create a profile 'gentoo' with 'mytoolchain' inherited
	edo qbs setup-qt "$(qt6_get_bindir)"/qmake gentoo
	qbs_config baseProfile mytoolchain

	# define paths for toolchain
	qbs_config archiverPath "$(tc-getAR)"
	qbs_config assemblerPath "$(tc-getAS)"
	qbs_config linkerPath "$(tc-getCC)"
	qbs_config nmPath "$(tc-getNM)"
	qbs_config objcopyPath "$(tc-getOBJCOPY)"
	qbs_config stripPath "$(tc-getSTRIP)"

	# define global options
	qbs_config qbs.installPrefix "${EPREFIX}/usr"
	qbs_config qbs.sysroot "${ESYSROOT}"

	# define system flags
	qbs_config cpp.cppFlags "$(qbs_format_flags ${CPPFLAGS})"
	qbs_config cpp.cxxFlags "$(qbs_format_flags ${CXXFLAGS})"
	qbs_config cpp.linkerFlags "$(qbs_format_flags $(raw-ldflags))"
	qbs_config qbs.optimization ""

	# define package options
	local my_opts=(
		enableCcache:false
		enablePCH:false
		enableUnitTests:$(usex test true false)
		enableRPath:false
		installLibraryPath:"$(get_libdir)"
		libDirName:"$(get_libdir)"
		treatWarningsAsErrors:false
	)

	# used by all phases
	qbsargs=(
		--file ${PN}.qbs
		config:release
		profile:gentoo
		${my_opts[@]/#/modules.buildconfig.}
	)

	# export now for src_test
	local -x LD_LIBRARY_PATH+=":${S}/release/install-root${EPREFIX}/usr/$(get_libdir)/"
	local -x QT_QPA_PLATFORM=offscreen

	edo qbs resolve "${qbsargs[@]}" --force-probe-execution

	# verbose build/install phase
	qbsargs+=(
		--command-echo-mode command-line
	)
}

src_compile() {
	edo qbs build "${qbsargs[@]}" --jobs $(get_makeopts_jobs) --no-install
}

src_test() {
	edo qbs -p autotest-runner profile:gentoo config:release
}

src_install() {
	edo qbs install "${qbsargs[@]}" --no-build --install-root "${D}"

	if use test; then
		rm "${ED}"/usr/bin/*Test.debug || die
	fi

	insinto /usr/share/${PN}
	doins -r "${S}"/src/app/share/{collection,tables}

	dodoc AUTHORS.txt ChangeLog.txt README.md

	doman dist/debian/${PN}.1
	doman dist/debian/puzzle.1
	doman dist/debian/tape.1
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "PDF to PS conversion" app-text/poppler[utils]
}
