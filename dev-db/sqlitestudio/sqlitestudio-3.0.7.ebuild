# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Upstream guide: http://wiki.sqlitestudio.pl/index.php/Compiling_application_from_sources

EAPI=6

inherit qmake-utils fdo-mime kde5-functions

DESCRIPTION="SQLiteStudio3 is a powerful cross-platform SQLite database manager"
HOMEPAGE="http://sqlitestudio.pl"
LICENSE="GPL-3"
SRC_URI="${HOMEPAGE}/files/sqlitestudio3/complete/tar/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cli cups tcl test"

QT_MINIMAL=5.3

RDEPEND="
	dev-db/sqlite:3
	$(add_qt_dep qtcore)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtscript)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	$(add_qt_dep designer)
	cups? ( $(add_qt_dep qtprintsupport) )
	cli? ( sys-libs/readline:= )
	tcl? ( dev-lang/tcl:= )
"
DEPEND="${RDEPEND}
	>=sys-devel/gcc-4.8:*
	test? ( $(add_qt_dep qttest) )
"

S="${WORKDIR}"
core_build_dir="${S}/output/build"
core_src_dir="${S}/SQLiteStudio3"
plugins_build_dir="${core_build_dir}/Plugins"
plugins_src_dir="${S}/Plugins"

src_prepare() {
	PATCHES=(
		"${FILESDIR}"/${PN}-3.0.6-qt5_5-QDataStream.patch
		"${FILESDIR}"/${PN}-3.0.6-portable.patch
		"${FILESDIR}"/${PN}-3.0.7-paths.patch
	)
	default

	disable_modules() {
		[ $# -lt 2 ] && return 0
		local file="$1"; shift

		edos2unix "${file}"

		local regex=""
		for m in "$@"; do
			regex+="\b${m}\b( \\\\|\$)|"
		done
		regex="${regex:0:-1}" # last pipe

		elog "Disabling modules: '$*' in '${file#${S}/}'"
		sed -i -r -e "/${regex}/d" -- "${file}" || return 1
	}

	## Core
	local disabled_modules=(
		$(usex cli '' 'cli')
	)
	disable_modules "${core_src_dir}/SQLiteStudio3.pro" "${disabled_modules[@]}" || die

	## Plugins
	local disabled_plugins=(
		'DbSqlite2'
		$(usex tcl '' 'ScriptingTcl')
		$(usex cups '' 'Printing')
	)
	disable_modules "${plugins_src_dir}/Plugins.pro" "${disabled_plugins[@]}" || die
}

src_configure() {
	local qmake_args=(
		"LIBDIR=${EROOT}usr/$(get_libdir)"
		"BINDIR=${EROOT}usr/bin"
		"DEFINES+=PLUGINS_DIR=${EROOT}usr/$(get_libdir)/${PN}"
		"DEFINES+=ICONS_DIR=${EROOT}usr/share/${PN}/icons"
		"DEFINES+=FORMS_DIR=${EROOT}usr/share/${PN}/forms"

		'DEFINES+=NO_AUTO_UPDATES' # not strictly needed since 3.0.6, but nevermind
		$(usex test 'DEFINES+=tests' '')
	)

	## Core
	mkdir -p "${core_build_dir}" && cd "${core_build_dir}" || die
	eqmake5 "${qmake_args[@]}" "${core_src_dir}"

	## Plugins
	mkdir -p "${plugins_build_dir}" && cd "${plugins_build_dir}" || die
	eqmake5 "${qmake_args[@]}" "${plugins_src_dir}"
}

src_compile() {
	cd "${core_build_dir}"		|| die && emake
	cd "${plugins_build_dir}"	|| die && emake
}

src_install() {
	cd "${core_build_dir}"		|| die && emake INSTALL_ROOT="${ED}" install
	cd "${plugins_build_dir}"	|| die && emake INSTALL_ROOT="${ED}" install

	dodoc "${core_src_dir}/docs/sqlitestudio3_docs.cfg"
	doicon -s scalable "${core_src_dir}/guiSQLiteStudio/img/${PN}.svg"

	make_desktop_entry_args=(
		"${EROOT}usr/bin/${PN} %F"	# exec
		'SQLiteStudio3'				# name
		"${PN}"						# icon
		'Development;Utility'		# categories
	)
	make_desktop_entry_extras=( 'MimeType=application/x-sqlite3;' )
	make_desktop_entry "${make_desktop_entry_args[@]}" \
		"$( printf '%s\n' "${make_desktop_entry_extras[@]}" )"
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}
