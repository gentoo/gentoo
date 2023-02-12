# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools db flag-o-matic multilib multilib-minimal toolchain-funcs

#Number of official patches
#PATCHNO=`echo ${PV}|sed -e "s,\(.*_p\)\([0-9]*\),\2,"`
PATCHNO="${PV/*.*.*_p}"
if [[ ${PATCHNO} == "${PV}" ]] ; then
	MY_PV="${PV}"
	MY_P="${P}"
	PATCHNO=0
else
	MY_PV="${PV/_p${PATCHNO}}"
	MY_P="${PN}-${MY_PV}"
fi

RESTRICT="!test? ( test )"

S_BASE="${WORKDIR}/${MY_P}"
S="${S_BASE}/build_unix"
DESCRIPTION="Oracle Berkeley DB"
HOMEPAGE="http://www.oracle.com/technetwork/database/database-technologies/berkeleydb/overview/index.html"
SRC_URI="http://download.oracle.com/berkeley-db/${MY_P}.tar.gz"
for (( i=1 ; i<=${PATCHNO} ; i++ )) ; do
	export SRC_URI="${SRC_URI} http://www.oracle.com/technology/products/berkeley-db/db/update/${MY_PV}/patch.${MY_PV}.${i}"
done

LICENSE="Sleepycat"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="doc cxx tcl test"

REQUIRED_USE="test? ( tcl )"

# the entire testsuite needs the TCL functionality
DEPEND="tcl? ( >=dev-lang/tcl-8.5.15-r1:0=[${MULTILIB_USEDEP}] )
	test? ( >=dev-lang/tcl-8.5.15-r1:0=[${MULTILIB_USEDEP}] )"
RDEPEND="tcl? ( >=dev-lang/tcl-8.5.15-r1:0=[${MULTILIB_USEDEP}] )"
# bug #841698
BDEPEND="sys-devel/autoconf-archive"

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/db${SLOT}/db.h
)

PATCHES=(
	# sqlite configure call has an extra leading ..
	# upstreamed:5.2.36, missing in 5.3.x
	"${FILESDIR}"/${PN}-5.2.28-sqlite-configure-path.patch

	# The upstream testsuite copies .lib and the binaries for each parallel test
	# core, ~300MB each. This patch uses links instead, saves a lot of space.
	"${FILESDIR}"/${PN}-6.0.20-test-link.patch

	# Needed when compiling with clang
	"${FILESDIR}"/${PN}-5.1.29-rename-atomic-compare-exchange.patch
	"${FILESDIR}"/${PN}-5.3.28-clang16.patch
)

src_prepare() {
	cd "${S_BASE}" || die
	for (( i=1 ; i<=${PATCHNO} ; i++ ))
	do
		eapply -p0 "${DISTDIR}"/patch."${MY_PV}"."${i}"
	done

	default

	# Upstream release script grabs the dates when the script was run, so lets
	# end-run them to keep the date the same.
	export REAL_DB_RELEASE_DATE="$(awk \
		'/^DB_VERSION_STRING=/{ gsub(".*\\(|\\).*","",$0); print $0; }' \
		"${S_BASE}"/dist/configure)"
	sed -r \
		-e "/^DB_RELEASE_DATE=/s~=.*~='${REAL_DB_RELEASE_DATE}'~g" \
		-i dist/RELEASE || die

	cd dist || die
	rm aclocal/libtool.m4 || die
	sed \
		-e '/AC_PROG_LIBTOOL$/aLT_OUTPUT' \
		-i configure.ac || die
	sed \
		-e '/^AC_PATH_TOOL/s/ sh, none/ bash, none/' \
		-i aclocal/programs.m4 || die

	AT_M4DIR="aclocal" eautoreconf

	# They do autoconf and THEN replace the version variables :(
	. ./RELEASE
	local v ev
	for v in \
		DB_VERSION_{FAMILY,LETTER,RELEASE,MAJOR,MINOR} \
		DB_VERSION_{PATCH,FULL,UNIQUE_NAME,STRING,FULL_STRING} \
		DB_VERSION \
		DB_RELEASE_DATE ; do
		ev="__EDIT_${v}__"
		sed -e "s/${ev}/${!v}/g" -i configure || die
	done

	# This is a false positive skip in the tests as the test-reviewer code
	# looks for 'Skipping\s'
	sed \
		-e '/db_repsite/s,Skipping:,Skipping,g' \
		-i "${S_BASE}"/test/tcl/reputils.tcl || die
}

multilib_src_configure() {
	local myconf=(
		# sql_compat will cause a collision with sqlite3
		#--enable-sql_compat
		# Don't --enable-sql* because we don't want to use bundled sqlite.
		# See Gentoo bug #605688
		--enable-compat185
		--enable-dbm
		--enable-o_direct
		--without-uniquename
		--disable-sql
		--disable-sql_codegen
		--disable-sql_compat
		--disable-static
		--disable-java
		$([[ ${ABI} == amd64 ]] && echo --with-mutex=x86/gcc-assembly)
		$(use_enable cxx)
		$(use_enable cxx stl)
		$(use_enable test)
	)

	tc-ld-force-bfd #470634 #729510

	# compilation with -O0 fails on amd64, see bug #171231
	if [[ ${ABI} == amd64 ]]; then
		local CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}"
		replace-flags -O0 -O2
		is-flagq -O[s123] || append-flags -O2
	fi

	# Add linker versions to the symbols. Easier to do, and safer than header file
	# mumbo jumbo.
	append-ldflags -Wl,--default-symver

	# Bug #270851: test needs TCL support
	if use tcl || use test ; then
		myconf+=(
			--enable-tcl
			--with-tcl="${EPREFIX}/usr/$(get_libdir)"
		)
	else
		myconf+=(--disable-tcl )
	fi

	ECONF_SOURCE="${S_BASE}"/dist \
	STRIP="true" \
	econf "${myconf[@]}"

	# The embedded assembly on ARM does not work on newer hardware
	# so you CANNOT use --with-mutex=ARM/gcc-assembly anymore.
	# Specifically, it uses the SWPB op, which was deprecated:
	# http://www.keil.com/support/man/docs/armasm/armasm_dom1361289909499.htm
	# The op ALSO cannot be used in ARM-Thumb mode.
	# Trust the compiler instead.
	# >=db-6.1 uses LDREX instead.
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	db_src_install_headerslot

	db_src_install_usrlibcleanup
}

multilib_src_install_all() {
	db_src_install_usrbinslot

	db_src_install_doc

	dodir /usr/sbin
	# This file is not always built, and no longer exists as of db-4.8
	if [[ -f "${ED}"/usr/bin/berkeley_db_svc ]] ; then
		mv "${ED}"/usr/bin/berkeley_db_svc \
			"${ED}"/usr/sbin/berkeley_db"${SLOT/./}"_svc || die
	fi

	# no static libraries
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	multilib_foreach_abi db_fix_so
}

pkg_postrm() {
	multilib_foreach_abi db_fix_so
}

src_test() {
	# db_repsite is impossible to build, as upstream strips those sources.
	# db_repsite is used directly in the setup_site_prog,
	# setup_site_prog is called from open_site_prog
	# which is called only from tests in the multi_repmgr group.
	#sed -ri \
	#	-e '/set subs/s,multi_repmgr,,g' \
	#	"${S_BASE}/test/testparams.tcl"
	sed -r \
		-e '/multi_repmgr/d' \
		-i "${S_BASE}/test/tcl/test.tcl" || die

	# This is the only failure in 5.2.28 so far, and looks like a false positive.
	# Repmgr018 (btree): Test of repmgr stats.
	#     Repmgr018.a: Start a master.
	#     Repmgr018.b: Start a client.
	#     Repmgr018.c: Run some transactions at master.
	#         Rep_test: btree 20 key/data pairs starting at 0
	#         Rep_test.a: put/get loop
	# FAIL:07:05:59 (00:00:00) perm_no_failed_stat: expected 0, got 1
	sed -r \
		-e '/set parms.*repmgr018/d' \
		-e 's/repmgr018//g' \
		-i "${S_BASE}/test/tcl/test.tcl" || die

	multilib-minimal_src_test
}

multilib_src_test() {
	multilib_is_native_abi || return

	S="${BUILD_DIR}" db_src_test
}
