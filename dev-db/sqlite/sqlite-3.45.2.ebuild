# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="SQL database engine"
HOMEPAGE="https://sqlite.org/"

# On version updates, make sure to read the forum (https://sqlite.org/forum/forum)
# for hints regarding test failures, backports, etc.
if [[ ${PV} == 9999 ]]; then
	S="${WORKDIR}"/${PN}
	PROPERTIES="live"
else
	printf -v SRC_PV "%u%02u%02u%02u" $(ver_rs 1- " ")
	DOC_PV="${SRC_PV}"
	#printf -v DOC_PV "%u%02u%02u00" $(ver_rs 1-3 " ")

	SRC_URI="
		https://sqlite.org/2024/${PN}-src-${SRC_PV}.zip
		doc? ( https://sqlite.org/2024/${PN}-doc-${DOC_PV}.zip )
	"
	S="${WORKDIR}/${PN}-src-${SRC_PV}"

	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

LICENSE="public-domain"
SLOT="3"
IUSE="debug doc icu +readline secure-delete static-libs tcl test tools"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	icu? ( dev-libs/icu:=[${MULTILIB_USEDEP}] )
	readline? ( sys-libs/readline:=[${MULTILIB_USEDEP}] )
	tcl? ( dev-lang/tcl:=[${MULTILIB_USEDEP}] )
	tools? ( dev-lang/tcl:= )
"
DEPEND="
	${RDEPEND}
	test? ( >=dev-lang/tcl-8.6:0[${MULTILIB_USEDEP}] )
"
BDEPEND=">=dev-lang/tcl-8.6:0"
if [[ ${PV} == 9999 ]]; then
	BDEPEND+=" dev-vcs/fossil"
else
	BDEPEND+=" app-arch/unzip"
fi

PATCHES=(
	"${FILESDIR}"/${PN}-3.45.1-ppc64-ptr.patch
	"${FILESDIR}"/${PN}-3.45.2-tests-x86.patch
)

_fossil_fetch() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	local repo_id="${1}"
	local repo_uri="${2}"

	local -x FOSSIL_HOME="${HOME}"

	mkdir -p "${T}/fossil/${repo_id}" || die
	pushd "${T}/fossil/${repo_id}" > /dev/null || die

	if [[ -n "${EVCS_OFFLINE}" ]]; then
		if [[ ! -f "${distdir}/fossil-src/${repo_id}/${repo_id}.fossil" ]]; then
			die "Network activity disabled using EVCS_OFFLINE and clone of repository missing: \"${distdir}/fossil-src/${repo_id}/${repo_id}.fossil\""
		fi
	else
		if [[ ! -f "${distdir}/fossil-src/${repo_id}/${repo_id}.fossil" ]]; then
			einfo fossil clone --verbose "${repo_uri}" "${repo_id}.fossil"
			fossil clone --verbose "${repo_uri}" "${repo_id}.fossil" || die
			echo
		else
			cp -p "${distdir}/fossil-src/${repo_id}/${repo_id}.fossil" . || die
			einfo fossil pull --repository "${repo_id}.fossil" --verbose "${repo_uri}"
			fossil pull --repository "${repo_id}.fossil" --verbose "${repo_uri}" || die
			echo
		fi

		(
			addwrite "${distdir}"
			mkdir -p "${distdir}/fossil-src/${repo_id}" || die
			cp -p "${repo_id}.fossil" "${distdir}/fossil-src/${repo_id}/${repo_id}.fossil" || die
		)
	fi

	popd > /dev/null || die
}

_fossil_checkout() {
	local distdir="${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}"
	local repo_id="${1}"
	local branch_or_commit="${2}"
	local target_directory="${3}"

	local -x FOSSIL_HOME="${HOME}"

	if [[ ! -f "${distdir}/fossil-src/${repo_id}/${repo_id}.fossil" ]]; then
		die "Clone of repository missing: \"${distdir}/fossil-src/${repo_id}/${repo_id}.fossil\""
	fi

	if [[ ! -f "${T}/fossil/${repo_id}/${repo_id}.fossil" ]]; then
		mkdir -p "${T}/fossil/${repo_id}" || die
		cp -p "${distdir}/fossil-src/${repo_id}/${repo_id}.fossil" "${T}/fossil/${repo_id}" || die
	fi

	mkdir "${target_directory}" || die
	pushd "${target_directory}" > /dev/null || die

	einfo fossil open --quiet "${T}/fossil/${repo_id}/${repo_id}.fossil" "${branch_or_commit}"
	fossil open --quiet "${T}/fossil/${repo_id}/${repo_id}.fossil" "${branch_or_commit}" || die
	echo

	popd > /dev/null || die
}

fossil_fetch() {
	local repo_id="${1}"
	local repo_uri="${2}"
	local target_directory="${3}"

	local branch_or_commit="${EFOSSIL_COMMIT:-${EFOSSIL_BRANCH:-trunk}}"

	_fossil_fetch "${repo_id}" "${repo_uri}"
	_fossil_checkout "${repo_id}" "${branch_or_commit}" "${target_directory}"
}

src_unpack() {
	if [[ ${PV} == 9999 ]]; then
		fossil_fetch sqlite https://sqlite.org/src "${WORKDIR}/${PN}"
		if use doc; then
			fossil_fetch sqlite-doc https://sqlite.org/docsrc "${WORKDIR}/${PN}-doc"
		fi
	else
		default
	fi
}

src_prepare() {
	default

	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	local -x CPPFLAGS="${CPPFLAGS}" CFLAGS="${CFLAGS}"
	local options=()

	options+=(
		--enable-load-extension
		--enable-threadsafe
	)

	# Support detection of misuse of SQLite API.
	# https://sqlite.org/compile.html#enable_api_armor
	append-cppflags -DSQLITE_ENABLE_API_ARMOR

	# Support bytecode and tables_used virtual tables.
	# https://sqlite.org/compile.html#enable_bytecode_vtab
	# https://sqlite.org/bytecodevtab.html
	append-cppflags -DSQLITE_ENABLE_BYTECODE_VTAB

	# Support column metadata functions.
	# https://sqlite.org/compile.html#enable_column_metadata
	# https://sqlite.org/c3ref/column_database_name.html
	append-cppflags -DSQLITE_ENABLE_COLUMN_METADATA

	# Support sqlite_dbpage virtual table.
	# https://sqlite.org/compile.html#enable_dbpage_vtab
	# https://sqlite.org/dbpage.html
	append-cppflags -DSQLITE_ENABLE_DBPAGE_VTAB

	# Support dbstat virtual table.
	# https://sqlite.org/compile.html#enable_dbstat_vtab
	# https://sqlite.org/dbstat.html
	append-cppflags -DSQLITE_ENABLE_DBSTAT_VTAB

	# Support sqlite3_serialize() and sqlite3_deserialize() functions.
	# https://sqlite.org/compile.html#enable_deserialize
	# https://sqlite.org/c3ref/serialize.html
	# https://sqlite.org/c3ref/deserialize.html
	append-cppflags -DSQLITE_ENABLE_DESERIALIZE

	# Support comments in output of EXPLAIN.
	# https://sqlite.org/compile.html#enable_explain_comments
	append-cppflags -DSQLITE_ENABLE_EXPLAIN_COMMENTS

	# Support Full-Text Search versions 3, 4 and 5.
	# https://sqlite.org/compile.html#enable_fts3
	# https://sqlite.org/compile.html#enable_fts3_parenthesis
	# https://sqlite.org/compile.html#enable_fts4
	# https://sqlite.org/compile.html#enable_fts5
	# https://sqlite.org/fts3.html
	# https://sqlite.org/fts5.html
	append-cppflags -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS -DSQLITE_ENABLE_FTS4
	options+=( --enable-fts5 )

	# Support hidden columns.
	append-cppflags -DSQLITE_ENABLE_HIDDEN_COLUMNS

	# Support memsys5 memory allocator.
	# https://sqlite.org/compile.html#enable_memsys5
	# https://sqlite.org/malloc.html#memsys5
	append-cppflags -DSQLITE_ENABLE_MEMSYS5

	# Support sqlite3_normalized_sql() function.
	# https://sqlite.org/c3ref/expanded_sql.html
	append-cppflags -DSQLITE_ENABLE_NORMALIZE

	# Support sqlite_offset() function.
	# https://sqlite.org/compile.html#enable_offset_sql_func
	# https://sqlite.org/lang_corefunc.html#sqlite_offset
	append-cppflags -DSQLITE_ENABLE_OFFSET_SQL_FUNC

	# Support pre-update hook functions.
	# https://sqlite.org/compile.html#enable_preupdate_hook
	# https://sqlite.org/c3ref/preupdate_count.html
	append-cppflags -DSQLITE_ENABLE_PREUPDATE_HOOK

	# Support Resumable Bulk Update extension.
	# https://sqlite.org/compile.html#enable_rbu
	# https://sqlite.org/rbu.html
	append-cppflags -DSQLITE_ENABLE_RBU

	# Support R*Trees.
	# https://sqlite.org/compile.html#enable_rtree
	# https://sqlite.org/compile.html#enable_geopoly
	# https://sqlite.org/rtree.html
	# https://sqlite.org/geopoly.html
	append-cppflags -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_GEOPOLY

	# Support Session extension.
	# https://sqlite.org/compile.html#enable_session
	# https://sqlite.org/sessionintro.html
	append-cppflags -DSQLITE_ENABLE_SESSION

	# Support scan status functions.
	# https://sqlite.org/compile.html#enable_stmt_scanstatus
	# https://sqlite.org/c3ref/stmt_scanstatus.html
	# https://sqlite.org/c3ref/stmt_scanstatus_reset.html
	append-cppflags -DSQLITE_ENABLE_STMT_SCANSTATUS

	# Support sqlite_stmt virtual table.
	# https://sqlite.org/compile.html#enable_stmtvtab
	# https://sqlite.org/stmt.html
	append-cppflags -DSQLITE_ENABLE_STMTVTAB

	# Support unknown() function.
	# https://sqlite.org/compile.html#enable_unknown_sql_function
	append-cppflags -DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION

	# Support unlock notification.
	# https://sqlite.org/compile.html#enable_unlock_notify
	# https://sqlite.org/c3ref/unlock_notify.html
	# https://sqlite.org/unlock_notify.html
	append-cppflags -DSQLITE_ENABLE_UNLOCK_NOTIFY

	# Support LIMIT and ORDER BY clauses on DELETE and UPDATE statements.
	# https://sqlite.org/compile.html#enable_update_delete_limit
	# https://sqlite.org/lang_delete.html#optional_limit_and_order_by_clauses
	# https://sqlite.org/lang_update.html#optional_limit_and_order_by_clauses
	append-cppflags -DSQLITE_ENABLE_UPDATE_DELETE_LIMIT

	# Support soundex() function.
	# https://sqlite.org/compile.html#soundex
	# https://sqlite.org/lang_corefunc.html#soundex
	append-cppflags -DSQLITE_SOUNDEX

	# Support URI filenames.
	# https://sqlite.org/compile.html#use_uri
	# https://sqlite.org/uri.html
	append-cppflags -DSQLITE_USE_URI

	options+=( $(use_enable debug) )

	if use icu; then
		# Support ICU extension.
		# https://sqlite.org/compile.html#enable_icu
		append-cppflags -DSQLITE_ENABLE_ICU
		sed -e "s/^TLIBS = @LIBS@/& -licui18n -licuuc/" -i Makefile.in || die "sed failed"
	fi

	options+=(
		--disable-editline
		$(use_enable readline)
	)

	if use readline; then
		options+=( --with-readline-inc="-I${ESYSROOT}/usr/include/readline" )
	fi

	if use secure-delete; then
		# Enable secure_delete pragma by default.
		# https://sqlite.org/compile.html#secure_delete
		# https://sqlite.org/pragma.html#pragma_secure_delete
		append-cppflags -DSQLITE_SECURE_DELETE
	fi

	options+=( $(use_enable static-libs static) )

	# tcl, test, tools USE flags.
	if use tcl || use test || { use tools && multilib_is_native_abi; }; then
		options+=(
			--enable-tcl
			--with-tcl="${ESYSROOT}/usr/$(get_libdir)"
		)
	else
		options+=( --disable-tcl )
	fi

	if [[ "${ABI}" == "x86" ]]; then
		if $(tc-getCC) ${CPPFLAGS} ${CFLAGS} -E -P -dM - < /dev/null 2> /dev/null | grep -q "^#define __SSE__ 1$"; then
			append-cflags -mfpmath=sse
		else
			append-cflags -ffloat-store
		fi
	fi

	econf "${options[@]}"
}

multilib_src_compile() {
	emake HAVE_TCL="$(usev tcl 1)" TCLLIBDIR="${EPREFIX}/usr/$(get_libdir)/${P}"

	if use tools && multilib_is_native_abi; then
		emake changeset dbdump dbhash dbtotxt index_usage rbu scrub showdb showjournal showshm showstat4 showwal sqldiff sqlite3_analyzer sqlite3_checker sqlite3_expert sqltclsh
	fi

	if [[ ${PV} == 9999 ]] && use doc && multilib_is_native_abi; then
		emake tclsqlite3.c

		local build_directory="$(pwd)"
		build_directory="${build_directory##*/}"

		mkdir "${WORKDIR}/${PN}-doc-build" || die
		pushd "${WORKDIR}/${PN}-doc-build" > /dev/null || die

		emake -f "../${PN}-doc/Makefile" -j1 SRC="../${PN}" BLD="../${build_directory}" DOC="../${PN}-doc" CC="$(tc-getBUILD_CC)" TCLINC="" TCLFLAGS="$($(tc-getBUILD_PKG_CONFIG) --libs tcl) -ldl -lm" base doc
		rmdir doc/matrix{/*,} || die

		popd > /dev/null || die
	fi
}

multilib_src_test() {
	if [[ "${EUID}" -eq 0 ]]; then
		ewarn "Skipping tests due to root permissions"
		return
	fi

	local -x SQLITE_HISTORY="${T}/sqlite_history_${ABI}"

	# e_uri.test tries to open files in /.
	# bug #839798
	local SANDBOX_PREDICT=${SANDBOX_PREDICT}
	addpredict "/test.db"
	addpredict "/ÿ.db"

	emake -Onone HAVE_TCL="$(usex tcl 1 "")" $(usex debug 'fulltest' 'test')
}

multilib_src_install() {
	emake DESTDIR="${D}" HAVE_TCL="$(usex tcl 1 "")" TCLLIBDIR="${EPREFIX}/usr/$(get_libdir)/${P}" install

	if use tools && multilib_is_native_abi; then
		install_tool() {
			if [[ -f ".libs/${1}" ]]; then
				newbin ".libs/${1}" "${2}"
			else
				newbin "${1}" "${2}"
			fi
		}

		install_tool changeset sqlite3-changeset
		install_tool dbdump sqlite3-db-dump
		install_tool dbhash sqlite3-db-hash
		install_tool dbtotxt sqlite3-db-to-txt
		install_tool index_usage sqlite3-index-usage
		install_tool rbu sqlite3-rbu
		install_tool scrub sqlite3-scrub
		install_tool showdb sqlite3-show-db
		install_tool showjournal sqlite3-show-journal
		install_tool showshm sqlite3-show-shm
		install_tool showstat4 sqlite3-show-stat4
		install_tool showwal sqlite3-show-wal
		install_tool sqldiff sqlite3-diff
		install_tool sqlite3_analyzer sqlite3-analyzer
		install_tool sqlite3_checker sqlite3-checker
		install_tool sqlite3_expert sqlite3-expert
		install_tool sqltclsh sqlite3-tclsh

		unset -f install_tool
	fi
}

multilib_src_install_all() {
	find "${ED}" -name "*.la" -delete || die

	doman sqlite3.1

	if use doc; then
		if [[ ${PV} == 9999 ]]; then
			pushd "${WORKDIR}/${PN}-doc-build/doc" > /dev/null || die
		else
			pushd "${WORKDIR}/${PN}-doc-${DOC_PV}" > /dev/null || die
		fi

		find "(" -name "*.db" -o -name "*.txt" ")" -delete || die
		if [[ ${PV} != 9999 ]]; then
			rm search search.d/admin || die
			rmdir search.d || die
			find -name "*~" -delete || die
		fi

		(
			docinto html
			dodoc -r *
		)

		popd > /dev/null || die
	fi
}
