# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit autotools eutils flag-o-matic multilib multilib-minimal toolchain-funcs versionator

SRC_PV="$(printf "%u%02u%02u%02u" $(get_version_components))"
DOC_PV="${SRC_PV}"
# DOC_PV="$(printf "%u%02u%02u00" $(get_version_components $(get_version_component_range 1-3)))"

DESCRIPTION="A SQL Database Engine in a C Library"
HOMEPAGE="http://sqlite.org/"
SRC_URI="doc? ( http://sqlite.org/2015/${PN}-doc-${DOC_PV}.zip )
	tcl? ( http://sqlite.org/2015/${PN}-src-${SRC_PV}.zip )
	test? ( http://sqlite.org/2015/${PN}-src-${SRC_PV}.zip )
	tools? ( http://sqlite.org/2015/${PN}-src-${SRC_PV}.zip )
	!tcl? ( !test? ( !tools? ( http://sqlite.org/2015/${PN}-autoconf-${SRC_PV}.tar.gz ) ) )"

LICENSE="public-domain"
SLOT="3"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug doc icu +readline secure-delete static-libs tcl test tools"

RDEPEND="icu? ( dev-libs/icu:0=[${MULTILIB_USEDEP}] )
	readline? ( sys-libs/readline:0=[${MULTILIB_USEDEP}] )
	tcl? ( dev-lang/tcl:0=[${MULTILIB_USEDEP}] )
	tools? ( dev-lang/tcl:0=[${MULTILIB_USEDEP}] )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20131008-r14
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)"
DEPEND="${RDEPEND}
	doc? ( app-arch/unzip )
	tcl? ( app-arch/unzip )
	test? (
		app-arch/unzip
		dev-lang/tcl:0[${MULTILIB_USEDEP}]
	)
	tools? ( app-arch/unzip )"

full_tarball() {
	use tcl || use test || use tools
}

pkg_setup() {
	if full_tarball; then
		S="${WORKDIR}/${PN}-src-${SRC_PV}"
	else
		S="${WORKDIR}/${PN}-autoconf-${SRC_PV}"
	fi
}

src_prepare() {
	if full_tarball; then
		epatch "${FILESDIR}/${PN}-3.8.1-src-dlopen_check.patch"

		# Increase timeout for fuzzcheck from 120 s to 3600 s.
		# (iTimeout in test/fuzzcheck.c:main)
		sed -e "/\.\/fuzzcheck\$(TEXE)/s/\$(FUZZDATA)/--timeout 3600 &/" -i Makefile.in || die "sed failed"

		# Fix shell1-5.0 test.
		# http://mailinglists.sqlite.org/cgi-bin/mailman/private/sqlite-dev/2015-May/002575.html
		sed -e "/if {\$i==0x0D /s/\$i==0x0D /&|| (\$i>=0xE0 \&\& \$i<=0xEF) /" -i test/shell1.test
	else
		epatch "${FILESDIR}/${PN}-3.8.1-autoconf-dlopen_check.patch"
	fi

	eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	local CPPFLAGS="${CPPFLAGS}" options=()

	options+=(
		--enable-$(full_tarball && echo load-extension || echo dynamic-extensions)
		--enable-threadsafe
	)

	# Support detection of misuse of SQLite API.
	# http://sqlite.org/compile.html#enable_api_armor
	append-cppflags -DSQLITE_ENABLE_API_ARMOR

	# Support column metadata functions.
	# http://sqlite.org/c3ref/column_database_name.html
	append-cppflags -DSQLITE_ENABLE_COLUMN_METADATA

	# Support dbstat virtual table.
	# http://sqlite.org/dbstat.html
	append-cppflags -DSQLITE_ENABLE_DBSTAT_VTAB

	# Support Full-Text Search versions 3, 4 and 5.
	# http://sqlite.org/fts3.html
	# http://sqlite.org/fts5.html
	append-cppflags -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS -DSQLITE_ENABLE_FTS4
	options+=(--enable-fts5)

	# Support JSON1 extension.
	# http://sqlite.org/json1.html
	append-cppflags -DSQLITE_ENABLE_JSON1

	# Support Resumable Bulk Update extension.
	# http://sqlite.org/rbu.html
	append-cppflags -DSQLITE_ENABLE_RBU

	# Support R*Trees.
	# http://sqlite.org/rtree.html
	append-cppflags -DSQLITE_ENABLE_RTREE

	# Support scan status functions.
	# http://sqlite.org/c3ref/stmt_scanstatus.html
	# http://sqlite.org/c3ref/stmt_scanstatus_reset.html
	append-cppflags -DSQLITE_ENABLE_STMT_SCANSTATUS

	# Support unlock notification.
	# http://sqlite.org/unlock_notify.html
	append-cppflags -DSQLITE_ENABLE_UNLOCK_NOTIFY

	# Support soundex() function.
	# http://sqlite.org/lang_corefunc.html#soundex
	append-cppflags -DSQLITE_SOUNDEX

	# debug USE flag.
	if full_tarball; then
		options+=($(use_enable debug))
	else
		if use debug; then
			append-cppflags -DSQLITE_DEBUG
		else
			append-cppflags -DNDEBUG
		fi
	fi

	# icu USE flag.
	if use icu; then
		# Support ICU extension.
		# http://sqlite.org/compile.html#enable_icu
		append-cppflags -DSQLITE_ENABLE_ICU
		if full_tarball; then
			sed -e "s/^TLIBS = @LIBS@/& -licui18n -licuuc/" -i Makefile.in || die "sed failed"
		else
			sed -e "s/^LIBS = @LIBS@/& -licui18n -licuuc/" -i Makefile.in || die "sed failed"
		fi
	fi

	# readline USE flag.
	options+=($(use_enable readline))
	if full_tarball && use readline; then
		options+=(--with-readline-inc="-I${EPREFIX}/usr/include/readline")
	fi

	# secure-delete USE flag.
	if use secure-delete; then
		# Enable secure_delete pragma by default.
		# http://sqlite.org/pragma.html#pragma_secure_delete
		append-cppflags -DSQLITE_SECURE_DELETE
	fi

	# static-libs USE flag.
	options+=($(use_enable static-libs static))

	# tcl, test, tools USE flags.
	if full_tarball; then
		options+=(--enable-tcl)
	fi

	if [[ "${CHOST}" == *-mint* ]]; then
		append-cppflags -DSQLITE_OMIT_WAL
	fi

	# Use pread(), pread64(), pwrite(), pwrite64() functions for better performance if they are available.
	if $(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} -Werror=implicit-function-declaration -x c - -o "${T}/pread_pwrite_test" <<< $'#include <unistd.h>\nint main()\n{\n  pread(0, NULL, 0, 0);\n  pwrite(0, NULL, 0, 0);\n  return 0;\n}' &> /dev/null; then
		append-cppflags -DUSE_PREAD
	fi
	if $(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} -Werror=implicit-function-declaration -x c - -o "${T}/pread64_pwrite64_test" <<< $'#include <unistd.h>\nint main()\n{\n  pread64(0, NULL, 0, 0);\n  pwrite64(0, NULL, 0, 0);\n  return 0;\n}' &> /dev/null; then
		append-cppflags -DUSE_PREAD64
	elif $(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} -D_LARGEFILE64_SOURCE -Werror=implicit-function-declaration -x c - -o "${T}/pread64_pwrite64_test" <<< $'#include <unistd.h>\nint main()\n{\n  pread64(0, NULL, 0, 0);\n  pwrite64(0, NULL, 0, 0);\n  return 0;\n}' &> /dev/null; then
		append-cppflags -DUSE_PREAD64 -D_LARGEFILE64_SOURCE
	fi

	econf "${options[@]}"
}

multilib_src_compile() {
	emake HAVE_TCL="$(usex tcl 1 "")" TCLLIBDIR="${EPREFIX}/usr/$(get_libdir)/${P}"

	if use tools && multilib_is_native_abi; then
		emake showdb showjournal showstat4 showwal sqldiff sqlite3_analyzer
	fi
}

multilib_src_test() {
	if [[ "${EUID}" -eq 0 ]]; then
		ewarn "Skipping tests due to root permissions"
		return
	fi

	emake HAVE_TCL="$(usex tcl 1 "")" $(use debug && echo fulltest || echo test)
}

multilib_src_install() {
	emake DESTDIR="${D}" HAVE_TCL="$(usex tcl 1 "")" TCLLIBDIR="${EPREFIX}/usr/$(get_libdir)/${P}" install

	if use tools && multilib_is_native_abi; then
		newbin showdb sqlite3-show-db
		newbin showjournal sqlite3-show-journal
		newbin showstat4 sqlite3-show-stat4
		newbin showwal sqlite3-show-wal
		newbin sqldiff sqlite3-diff
		newbin sqlite3_analyzer sqlite3-analyzer
	fi
}

multilib_src_install_all() {
	prune_libtool_files

	doman sqlite3.1

	if use doc; then
		dohtml -A ico,odf,odg,pdf,svg -r "${WORKDIR}/${PN}-doc-${DOC_PV}/"
	fi
}
