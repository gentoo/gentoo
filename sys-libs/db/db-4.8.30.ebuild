# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/db/db-4.8.30.ebuild,v 1.20 2015/03/20 14:41:50 jlec Exp $

EAPI=4

inherit eutils db flag-o-matic java-pkg-opt-2 autotools multilib

#Number of official patches
#PATCHNO=`echo ${PV}|sed -e "s,\(.*_p\)\([0-9]*\),\2,"`
PATCHNO=${PV/*.*.*_p}
if [[ ${PATCHNO} == "${PV}" ]] ; then
	MY_PV=${PV}
	MY_P=${P}
	PATCHNO=0
else
	MY_PV=${PV/_p${PATCHNO}}
	MY_P=${PN}-${MY_PV}
fi

S="${WORKDIR}/${MY_P}/build_unix"
DESCRIPTION="Oracle Berkeley DB"
HOMEPAGE="http://www.oracle.com/technology/software/products/berkeley-db/index.html"
SRC_URI="http://download.oracle.com/berkeley-db/${MY_P}.tar.gz"
for (( i=1 ; i<=${PATCHNO} ; i++ )) ; do
	export SRC_URI="${SRC_URI} http://www.oracle.com/technology/products/berkeley-db/db/update/${MY_PV}/patch.${MY_PV}.${i}"
done

LICENSE="Sleepycat"
SLOT="4.8"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="doc java cxx tcl test"

# the entire testsuite needs the TCL functionality
DEPEND="tcl? ( >=dev-lang/tcl-8.4:0 )
	test? ( >=dev-lang/tcl-8.4:0 )
	java? ( >=virtual/jdk-1.5 )
	>=sys-devel/binutils-2.16.1"
RDEPEND="tcl? ( dev-lang/tcl:0 )
	java? ( >=virtual/jre-1.5 )"

src_unpack() {
	unpack "${MY_P}".tar.gz
}

src_prepare() {
	cd "${WORKDIR}"/"${MY_P}" || die
	for (( i=1 ; i<=${PATCHNO} ; i++ ))
	do
		epatch "${DISTDIR}"/patch."${MY_PV}"."${i}"
	done
	epatch "${FILESDIR}"/${PN}-4.8-libtool.patch
	epatch "${FILESDIR}"/${PN}-4.8.24-java-manifest-location.patch
	epatch "${FILESDIR}"/${PN}-4.8.30-rename-atomic-compare-exchange.patch

	# use the includes from the prefix
	epatch "${FILESDIR}"/${PN}-4.6-jni-check-prefix-first.patch
	epatch "${FILESDIR}"/${PN}-4.3-listen-to-java-options.patch

	sed -e "/^DB_RELEASE_DATE=/s/%B %e, %Y/%Y-%m-%d/" -i dist/RELEASE \
		|| die

	# Include the SLOT for Java JAR files
	# This supersedes the unused jarlocation patches.
	sed -r -i \
		-e '/jarfile=.*\.jar$/s,(.jar$),-$(LIBVERSION)\1,g' \
		"${S}"/../dist/Makefile.in || die

	cd "${S}"/../dist || die
	rm -f aclocal/libtool.m4
	sed -i \
		-e '/AC_PROG_LIBTOOL$/aLT_OUTPUT' \
		configure.ac || die
	sed -i \
		-e '/^AC_PATH_TOOL/s/ sh, none/ bash, none/' \
		aclocal/programs.m4 || die
	AT_M4DIR="aclocal aclocal_java" eautoreconf
	# Upstream sucks - they do autoconf and THEN replace the version variables.
	. ./RELEASE
	sed -i \
		-e "s/__EDIT_DB_VERSION_MAJOR__/$DB_VERSION_MAJOR/g" \
		-e "s/__EDIT_DB_VERSION_MINOR__/$DB_VERSION_MINOR/g" \
		-e "s/__EDIT_DB_VERSION_PATCH__/$DB_VERSION_PATCH/g" \
		-e "s/__EDIT_DB_VERSION_STRING__/$DB_VERSION_STRING/g" \
		-e "s/__EDIT_DB_VERSION_UNIQUE_NAME__/$DB_VERSION_UNIQUE_NAME/g" \
		-e "s/__EDIT_DB_VERSION__/$DB_VERSION/g" configure || die
}

src_configure() {
	local myconf=''

	# compilation with -O0 fails on amd64, see bug #171231
	if use amd64; then
		replace-flags -O0 -O2
		is-flagq -O[s123] || append-flags -O2
	fi

	# use `set` here since the java opts will contain whitespace
	set --
	if use java ; then
		set -- "$@" \
			--with-java-prefix="${JAVA_HOME}" \
			--with-javac-flags="$(java-pkg_javac-args)"
	fi

	# Add linker versions to the symbols. Easier to do, and safer than header file
	# mumbo jumbo.
	if use userland_GNU ; then
		append-ldflags -Wl,--default-symver
	fi

	# Bug #270851: test needs TCL support
	if use tcl || use test ; then
		myconf="${myconf} --enable-tcl"
		myconf="${myconf} --with-tcl=/usr/$(get_libdir)"
	else
		myconf="${myconf} --disable-tcl"
	fi

	ECONF_SOURCE="${S}"/../dist \
	STRIP="true" \
	econf \
		--enable-compat185 \
		--enable-o_direct \
		--without-uniquename \
		$(use arm && echo --with-mutex=ARM/gcc-assembly) \
		$(use amd64 && echo --with-mutex=x86/gcc-assembly) \
		$(use_enable cxx) \
		$(use_enable cxx stl) \
		$(use_enable java) \
		${myconf} \
		$(use_enable test) \
		"$@"
}

src_install() {
	emake install DESTDIR="${D}"

	db_src_install_usrbinslot

	db_src_install_headerslot

	db_src_install_doc

	db_src_install_usrlibcleanup

	dodir /usr/sbin
	# This file is not always built, and no longer exists as of db-4.8
	if [[ -f "${D}"/usr/bin/berkeley_db_svc ]] ; then
		mv "${D}"/usr/bin/berkeley_db_svc \
			"${D}"/usr/sbin/berkeley_db"${SLOT/./}"_svc || die
	fi

	if use java; then
		java-pkg_regso "${D}"/usr/"$(get_libdir)"/libdb_java*.so
		java-pkg_dojar "${D}"/usr/"$(get_libdir)"/*.jar
		rm -f "${D}"/usr/"$(get_libdir)"/*.jar
	fi
}

pkg_postinst() {
	db_fix_so
}

pkg_postrm() {
	db_fix_so
}
