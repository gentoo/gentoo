# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools db flag-o-matic java-pkg-opt-2 multilib toolchain-funcs

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
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="doc java cxx tcl test"

REQUIRED_USE="test? ( tcl )"

# the entire testsuite needs the TCL functionality
DEPEND="tcl? ( >=dev-lang/tcl-8.4:0 )
	test? ( >=dev-lang/tcl-8.4:0 )
	java? ( >=virtual/jdk-1.5 )
	>=sys-devel/binutils-2.16.1"
RDEPEND="tcl? ( dev-lang/tcl:0 )
	java? ( >=virtual/jre-1.5 )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.8-libtool.patch
	"${FILESDIR}"/${PN}-4.8.24-java-manifest-location.patch

	# use the includes from the prefix
	"${FILESDIR}"/${PN}-4.6-jni-check-prefix-first.patch
	"${FILESDIR}"/${PN}-4.2-listen-to-java-options.patch

	# upstream autoconf fails to build DBM when it's supposed to
	# merged upstream in 5.0.26
	#"${FILESDIR}"/${PN}-5.0.21-enable-dbm-autoconf.patch

	# Needed when compiling with clang
	"${FILESDIR}"/${P}-rename-atomic-compare-exchange.patch
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

	# Include the SLOT for Java JAR files
	# This supersedes the unused jarlocation patches.
	sed -r \
		-e '/jarfile=.*\.jar$/s,(.jar$),-$(LIBVERSION)\1,g' \
		-i dist/Makefile.in || die

	cd dist || die
	rm aclocal/libtool.m4 || die
	sed \
		-e '/AC_PROG_LIBTOOL$/aLT_OUTPUT' \
		-i configure.ac || die
	sed \
		-e '/^AC_PATH_TOOL/s/ sh, none/ bash, none/' \
		-i aclocal/programs.m4 || die

	AT_M4DIR="aclocal aclocal_java" eautoreconf

	# Upstream sucks - they do autoconf and THEN replace the version variables.
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

src_configure() {
	local myconf=(
		--enable-compat185
		--enable-dbm
		--enable-o_direct
		--without-uniquename
		--enable-sql
		--enable-sql_codegen
		--disable-sql_compat
		$(use amd64 && echo --with-mutex=x86/gcc-assembly)
		$(use_enable cxx)
		$(use_enable cxx stl)
		$(use_enable java)
		$(use_enable test)
	)

	tc-ld-disable-gold #470634

	# compilation with -O0 fails on amd64, see bug #171231
	if use amd64; then
		replace-flags -O0 -O2
		is-flagq -O[s123] || append-flags -O2
	fi

	if use java ; then
		myconf+=(
			--with-java-prefix="${JAVA_HOME}"
			--with-javac-flags="$(java-pkg_javac-args)"
		)
	fi

	# Add linker versions to the symbols. Easier to do, and safer than header file
	# mumbo jumbo.
	if use userland_GNU ; then
		append-ldflags -Wl,--default-symver
	fi

	# Bug #270851: test needs TCL support
	if use tcl || use test ; then
		myconf+=(
			--enable-tcl
			--with-tcl="${EPREFIX}/usr/$(get_libdir)"
		)
	else
		myconf+=( --disable-tcl )
	fi

	# sql_compat will cause a collision with sqlite3
	# --enable-sql_compat
	cd "${S}" || die

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

src_install() {
	emake DESTDIR="${D}" install

	db_src_install_usrbinslot

	db_src_install_headerslot

	db_src_install_doc

	db_src_install_usrlibcleanup

	dodir /usr/sbin
	# This file is not always built, and no longer exists as of db-4.8
	if [[ -f "${ED}"/usr/bin/berkeley_db_svc ]] ; then
		mv "${ED}"/usr/bin/berkeley_db_svc \
			"${ED}"/usr/sbin/berkeley_db"${SLOT/./}"_svc || die
	fi

	if use java; then
		java-pkg_regso "${ED}"/usr/"$(get_libdir)"/libdb_java*.so
		java-pkg_dojar "${ED}"/usr/"$(get_libdir)"/*.jar
		rm -f "${ED}"/usr/"$(get_libdir)"/*.jar
	fi
}

pkg_postinst() {
	db_fix_so
}

pkg_postrm() {
	db_fix_so
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

	db_src_test
}
