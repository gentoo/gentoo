# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools db flag-o-matic java-pkg-opt-2 multilib multilib-minimal toolchain-funcs

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

S="${WORKDIR}/${MY_P}/build_unix"
DESCRIPTION="Oracle Berkeley DB"
HOMEPAGE="http://www.oracle.com/technetwork/database/database-technologies/berkeleydb/overview/index.html"
SRC_URI="http://download.oracle.com/berkeley-db/${MY_P}.tar.gz"
for (( i=1 ; i<=${PATCHNO} ; i++ )) ; do
	export SRC_URI="${SRC_URI} http://www.oracle.com/technology/products/berkeley-db/db/update/${MY_PV}/patch.${MY_PV}.${i}"
done

LICENSE="Sleepycat"
SLOT="$(ver_cut 1-2)"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="doc java cxx tcl test"

REQUIRED_USE="test? ( tcl )"

# the entire testsuite needs the TCL functionality
DEPEND="tcl? ( >=dev-lang/tcl-8.5.15-r1:0=[${MULTILIB_USEDEP}] )
	test? ( >=dev-lang/tcl-8.5.15-r1:0=[${MULTILIB_USEDEP}] )
	java? ( >=virtual/jdk-1.5 )
	>=sys-devel/binutils-2.16.1"
RDEPEND="tcl? ( >=dev-lang/tcl-8.5.15-r1:0=[${MULTILIB_USEDEP}] )
	java? ( >=virtual/jre-1.5 )"

PATCHES=(
	"${FILESDIR}"/${PN}-4.8-libtool.patch
	"${FILESDIR}"/${PN}-4.8.24-java-manifest-location.patch
	"${FILESDIR}"/${PN}-4.8.30-rename-atomic-compare-exchange.patch

	# use the includes from the prefix
	"${FILESDIR}"/${PN}-4.6-jni-check-prefix-first.patch
	"${FILESDIR}"/${PN}-4.2-listen-to-java-options.patch
)

src_prepare() {
	cd "${WORKDIR}"/"${MY_P}" || die
	for (( i=1 ; i<=${PATCHNO} ; i++ ))
	do
		eapply -p0 "${DISTDIR}"/patch."${MY_PV}"."${i}"
	done

	default

	sed -e "/^DB_RELEASE_DATE=/s/%B %e, %Y/%Y-%m-%d/" -i dist/RELEASE \
		|| die

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
	sed \
		-e "s/__EDIT_DB_VERSION_MAJOR__/$DB_VERSION_MAJOR/g" \
		-e "s/__EDIT_DB_VERSION_MINOR__/$DB_VERSION_MINOR/g" \
		-e "s/__EDIT_DB_VERSION_PATCH__/$DB_VERSION_PATCH/g" \
		-e "s/__EDIT_DB_VERSION_STRING__/$DB_VERSION_STRING/g" \
		-e "s/__EDIT_DB_VERSION_UNIQUE_NAME__/$DB_VERSION_UNIQUE_NAME/g" \
		-e "s/__EDIT_DB_VERSION__/$DB_VERSION/g" \
		-i configure || die
}

multilib_src_configure() {
	local myconf=(
		--enable-compat185
		--enable-o_direct
		--without-uniquename
		$([[ ${ABI} == amd64 ]] && echo --with-mutex=x86/gcc-assembly)
		$(use_enable cxx)
		$(use_enable cxx stl)
		$(multilib_native_use_enable java)
		$(use_enable test)
	)

	tc-ld-disable-gold #470634

	# compilation with -O0 fails on amd64, see bug #171231
	if [[ ${ABI} == amd64 ]]; then
		local CFLAGS=${CFLAGS} CXXFLAGS=${CXXFLAGS}
		replace-flags -O0 -O2
		is-flagq -O[s123] || append-flags -O2
	fi

	# Add linker versions to the symbols. Easier to do, and safer than header file
	# mumbo jumbo.
	if use userland_GNU ; then
		append-ldflags -Wl,--default-symver
	fi

	# use `set` here since the java opts will contain whitespace
	if multilib_is_native_abi && use java ; then
		myconf+=(
			--with-java-prefix="${JAVA_HOME}"
			--with-javac-flags="$(java-pkg_javac-args)"
		)
	fi

	# Bug #270851: test needs TCL support
	if use tcl || use test ; then
		myconf+=(
			--enable-tcl
			--with-tcl="${EPREFIX}/usr/$(get_libdir)"
		)
	else
		myconf+=(--disable-tcl )
	fi

	ECONF_SOURCE="${S}"/../dist \
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

multilib_src_test() {
	multilib_is_native_abi || return

	S="${BUILD_DIR}" db_src_test
}

multilib_src_install() {
	emake install DESTDIR="${D}"

	db_src_install_headerslot

	db_src_install_usrlibcleanup

	if multilib_is_native_abi && use java; then
		java-pkg_regso "${ED}"/usr/"$(get_libdir)"/libdb_java*.so
		java-pkg_dojar "${ED}"/usr/"$(get_libdir)"/*.jar
		rm -f "${ED}"/usr/"$(get_libdir)"/*.jar
	fi
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
}

pkg_postinst() {
	multilib_foreach_abi db_fix_so
}

pkg_postrm() {
	multilib_foreach_abi db_fix_so
}
