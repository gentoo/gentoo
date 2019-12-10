# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="de es fr it pl pt_BR ro_RO ru sk zh_CN"

inherit desktop l10n qmake-utils xdg

DESCRIPTION="Powerful cross-platform SQLite database manager"
HOMEPAGE="https://sqlitestudio.pl"
SRC_URI="https://sqlitestudio.pl/files/sqlitestudio3/complete/tar/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"
SLOT="0"
IUSE="cli cups tcl test"
RESTRICT="!test? ( test )"

REQUIRED_USE="test? ( cli )"

RDEPEND="
	dev-db/sqlite:3
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtscript:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	cli? ( sys-libs/readline:0= )
	cups? ( dev-qt/qtprintsupport:5 )
	tcl? ( dev-lang/tcl:0= )
"
DEPEND="${RDEPEND}
	dev-qt/designer:5
	dev-qt/qtconcurrent:5
	test? ( dev-qt/qttest:5 )
"
PATCHES=( "${FILESDIR}"/${P}-libressl.patch )

S="${WORKDIR}"
core_build_dir="${S}/output/build"
plugins_build_dir="${core_build_dir}/Plugins"

src_prepare() {
	xdg_src_prepare

	sed -i -e 's/linux|portable/portable/' \
		SQLiteStudio3/sqlitestudio/sqlitestudio.pro || die

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
	use cups || mod_lst+=( Printing )
	use tcl || mod_lst+=( ScriptingTcl )
	disable_modules Plugins/Plugins.pro ${mod_lst[@]}

	local mylrelease="$(qt5_get_bindir)"/lrelease
	local ts_dir_lst=$(find * -type f -name "*.qm" -printf '%h\n' | sort -u)
	local ts_pro_lst=$(find * -type f -name "*.pro" -exec grep -l 'TRANSLATIONS' {} \;)
	local ts_qrc_lst=$(find * -type f -name "*.qrc" -exec grep -l '\.qm' {} \;)

	# delete all "*.qm"
	for ts_dir in ${ts_dir_lst[@]}; do
		rm "${ts_dir}"/*.qm || die
	done

	prepare_locale() {
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
	l10n_find_plocales_changes ${ts_dir_main} "sqlitestudio_" '.ts'
	l10n_for_each_locale_do prepare_locale
	l10n_for_each_disabled_locale_do rm_locale

	# prevent "multilib-strict check failed" with USE test
	sed -i -e 's/\(target.*usr\/\)lib/\1'$(get_libdir)'/' \
		SQLiteStudio3/Tests/TestUtils/TestUtils.pro || die
}

src_configure() {
	# NOTE: QMAKE_CFLAGS_ISYSTEM option prevents
	# build error with tcl use enabled (stdlib.h is missing)
	local myqmakeargs=(
		"BINDIR=${EPREFIX}/usr/bin"
		"LIBDIR=${EPREFIX}/usr/$(get_libdir)"
		"QMAKE_CFLAGS_ISYSTEM=\"\""
		$(usex test 'DEFINES+=tests' '')
	)

	## Core
	mkdir -p "${core_build_dir}" && cd "${core_build_dir}" || die
	eqmake5 "${myqmakeargs[@]}" "${S}/SQLiteStudio3"

	## Plugins
	mkdir -p "${plugins_build_dir}" && cd "${plugins_build_dir}" || die
	eqmake5 "${myqmakeargs[@]}" "${S}/Plugins"
}

src_compile() {
	emake -C "${core_build_dir}"
	emake -C "${plugins_build_dir}"
}

src_install() {
	emake -C "${core_build_dir}" INSTALL_ROOT="${D}" install
	emake -C "${plugins_build_dir}" INSTALL_ROOT="${D}" install

	doicon -s scalable "SQLiteStudio3/guiSQLiteStudio/img/${PN}.svg"

	local make_desktop_entry_args=(
		"${PN} -- %F"
		'SQLiteStudio3'
		"${PN}"
		'Development;Database;Utility'
	)
	make_desktop_entry "${make_desktop_entry_args[@]}" \
		"$( printf '%s\n' "MimeType=application/x-sqlite3;" )"
}
