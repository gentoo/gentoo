# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools db flag-o-matic java-pkg-opt-2 multilib

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
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ppc ppc64 ~s390 sparc x86"
IUSE="doc java cxx tcl test"

# the entire testsuite needs the TCL functionality
DEPEND="tcl? ( >=dev-lang/tcl-8.4 )
	test? ( >=dev-lang/tcl-8.4 )
	java? ( >=virtual/jdk-1.8 )"
RDEPEND="tcl? ( dev-lang/tcl )
	java? ( >=virtual/jre-1.8 )"

PATCHES=(
	"${FILESDIR}"/"${PN}"-4.4-libtool.patch

	# use the includes from the prefix
	"${FILESDIR}"/"${PN}"-4.6-jni-check-prefix-first.patch
	"${FILESDIR}"/"${PN}"-4.2-listen-to-java-options.patch
)

# Required to avoid unpack attempt of patches
src_unpack() {
	unpack "${MY_P}".tar.gz
}

src_prepare() {
	pushd "${WORKDIR}"/"${MY_P}" &>/dev/null || die
	for (( i=1 ; i<=${PATCHNO} ; i++ ))
	do
		eapply -p0 "${DISTDIR}"/patch."${MY_PV}"."${i}"
	done

	default

	sed -e "/^DB_RELEASE_DATE=/s/%B %e, %Y/%Y-%m-%d/" \
		-i dist/RELEASE || die

	# Include the SLOT for Java JAR files
	# This supersedes the unused jarlocation patches.
	sed -r \
		-e '/jarfile=.*\.jar$/s,(.jar$),-$(LIBVERSION)\1,g' \
		-i dist/Makefile.in || die

	pushd dist &>/dev/null || die
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

	popd &>/dev/null || die
	popd &>/dev/null || die
}

src_configure() {
	# compilation with -O0 fails on amd64, see bug #171231
	if use amd64 ; then
		replace-flags -O0 -O2
		is-flagq -O[s123] || append-flags -O2
	fi

	local myconf=(
		--enable-compat185
		--enable-o_direct
		--without-uniquename
		--disable-rpc

		$(usex amd64 '--with-mutex=x86/gcc-assembly' '')
		$(use_enable cxx)
		$(use_enable tcl)
		$(usex tcl "--with-tcl=${EPREFIX}/usr/$(get_libdir)" '') #"
		$(use_enable java)
		$(use_enable test)
	)

	if use java; then
		myconf+=(
			--with-java-prefix="${JAVA_HOME}"
			--with-javac-flags="$(java-pkg_javac-args)"
		)
	fi

	# Bug #270851: test needs TCL support
	if use tcl && use test ; then
		myconf+=( --enable-test )
	else
		myconf+=( --disable-test )
	fi

	# Add linker versions to the symbols. Easier to do, and safer than header file
	# mumbo jumbo.
	if use userland_GNU ; then
		append-ldflags -Wl,--default-symver
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
