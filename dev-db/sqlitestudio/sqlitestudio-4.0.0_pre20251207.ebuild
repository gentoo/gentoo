# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=bac238ccb0000419a66f3b2134b08d1f7a2bd076

PLOCALES="af_ZA ar_SA be_BY ca_ES cs_CZ da_DK de_DE el_GR en_US es_ES fa_IR fi_FI fr_FR he_IL hu_HU it_IT ja_JP kaa ko_KR nl_NL no_NO pl_PL pt_BR pt_PT ro_RO ru_RU sk_SK sr_SP sv_SE tr_TR uk_UA vi_VN zh_CN zh_TW"

# ScriptingPython says exactly 3.9
PYTHON_COMPAT=( python3_{11..13} )
inherit desktop plocale python-single-r1 qmake-utils xdg

DESCRIPTION="Powerful cross-platform SQLite database manager"
HOMEPAGE="https://sqlitestudio.pl"
SRC_URI="https://github.com/pawelsalawa/sqlitestudio/archive/${COMMIT}.tar.gz -> ${P}-${COMMIT:0:8}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cli python tcl test"

REQUIRED_USE="
	test? ( cli )
	python? ( ${PYTHON_REQUIRED_USE} )
"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/openssl:=
	dev-db/sqlite:3
	dev-qt/qtbase:6[gui,network,widgets,xml]
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
	cli? (
		sys-libs/readline:=
		sys-libs/ncurses:=
	)
	python? ( ${PYTHON_DEPS} )
	tcl? ( dev-lang/tcl:0= )
"
DEPEND="${RDEPEND}
	dev-qt/qttools:6[designer]
	dev-qt/qtbase:6[concurrent]
"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${P}-fix-python.patch
	"${FILESDIR}"/${P}-missing-headers.patch
)

core_build_dir="${S}/output/build"
plugins_build_dir="${core_build_dir}/Plugins"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default

	disable_modules() {
		[[ $# -lt 2 ]] && die "not enough arguments"

		local pro="$1"; shift
		local modules="${@}"

		sed -r -i \
			-e 's/('${modules// /|}')[[:space:]]*(\\?)/\2/' \
			${pro} || die
	}

	use cli || disable_modules SQLiteStudio3/SQLiteStudio3.pro cli

	local mod_lst=( DbSqlite2 )
	use tcl || mod_lst+=( ScriptingTcl )
	use python || mod_lst+=( ScriptingPython )
	disable_modules Plugins/Plugins.pro ${mod_lst[@]}

	local mylrelease="$(qt6_get_bindir)"/lrelease
	local ts_dir_lst=$(find * -type f -name "*.qm" -printf '%h\n' | sort -u)
	local ts_pro_lst=$(find * -type f -name "*.pro" -exec grep -l 'TRANSLATIONS' {} \;)
	local ts_qrc_lst=$(find * -type f -name "*.qrc" -exec grep -l '\.qm' {} \;)

	# delete all "*.qm"
	for ts_dir in ${ts_dir_lst[@]}; do
		rm "${ts_dir}"/*.qm || die
	done

	lrelease_locale() {
		for ts_dir in ${ts_dir_lst[@]}; do
			local ts=$(find "${ts_dir}" -type f -name "*${1}.ts" || continue)
			"${mylrelease}" "${ts}" || die "preparing ${1} locale failed"
		done
	}

	rm_locale() {
		for ts_pro in ${ts_pro_lst[@]}; do
			sed -i -r -e 's/[^[:space:]]*'${1}'\.ts//' \
				${ts_pro} || die
		done

		for ts_qrc in ${ts_qrc_lst[@]}; do
			sed -i -e '/'${1}'\.qm/d' \
				${ts_qrc} || die
		done
	}

	local ts_dir_main="SQLiteStudio3/sqlitestudio/translations"
	plocale_find_changes ${ts_dir_main} "sqlitestudio_" '.ts'
	plocale_for_each_locale lrelease_locale
	plocale_for_each_disabled_locale rm_locale

	# prevent "multilib-strict check failed" with USE test by
	# replacing target paths with dynamic lib dir
	#
	sed -i -e 's/\(target\.path = .*\/\)lib/\1'$(get_libdir)'/' \
		SQLiteStudio3/Tests/TestUtils/TestUtils.pro || die
}

src_configure() {
	# NOTE: QMAKE_CFLAGS_ISYSTEM option prevents
	# build error with tcl use enabled (stdlib.h is missing)
	# "QMAKE_CFLAGS_ISYSTEM=\"\""
	# CONFIG+ borrowed from compile.sh of tarball
	local myqmakeargs=(
		"BINDIR=${EPREFIX}/usr/bin"
		"LIBDIR=${EPREFIX}/usr/$(get_libdir)"
		"CONFIG+=portable"
		$(usex test 'DEFINES+=tests' '')
	)

	# Combination of kvirc ebuild and qtcompress
	if use python; then
		myqmakeargs+=(
			INCLUDEPATH+=" $(python_get_includedir)"
			LIBS+=" $(python_get_LIBS)"
		)
	fi

	## Core
	mkdir -p "${core_build_dir}" && cd "${core_build_dir}" || die
	eqmake6 "${myqmakeargs[@]}" "${S}/SQLiteStudio3"

	## Plugins
	mkdir -p "${plugins_build_dir}" && cd "${plugins_build_dir}" || die
	eqmake6 "${myqmakeargs[@]}" "${S}/Plugins"
}

src_compile() {
	# -j1 for bug #902991; it clobbers object files in parallel
	emake -j1 -C "${core_build_dir}"
	emake -j1 -C "${plugins_build_dir}"
}

src_install() {
	emake -j1 -C "${core_build_dir}" INSTALL_ROOT="${D}" install
	emake -j1 -C "${plugins_build_dir}" INSTALL_ROOT="${D}" install

	if use test; then
		# remove test artifacts that must not be installed
		rm -r "${ED}"/lib64 || die
		rm -r "${ED}"/usr/share/qt6/tests || die
	fi

	doicon -s scalable "SQLiteStudio3/guiSQLiteStudio/img/${PN}.svg"

	make_desktop_entry --eapi9 ${PN} -a "-- %F" -n SQLiteStudio3 -i ${PN} \
		-c "Development;Database;Utility" -e "MimeType=application/x-sqlite3;"
}
