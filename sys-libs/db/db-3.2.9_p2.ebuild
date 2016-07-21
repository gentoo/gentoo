# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils db multilib

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

DESCRIPTION="Berkeley DB for transaction support in MySQL"
HOMEPAGE="http://www.oracle.com/technology/software/products/berkeley-db/index.html"
SRC_URI="http://download.oracle.com/berkeley-db/${MY_P}.tar.gz"
for (( i=1 ; i<=${PATCHNO} ; i++ )) ; do
	export SRC_URI="${SRC_URI} http://www.oracle.com/technology/products/berkeley-db/db/update/${MY_PV}/patch.${MY_PV}.${i}"
done

LICENSE="Sleepycat"
SLOT="3"
# This ebuild is to be the compatibility ebuild for when db4 is put
# in the tree.
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="doc"

DEPEND="${RDEPEND}
	=sys-libs/db-1.85*"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	# This doesn't build without exceptions
	export CXXFLAGS="${CXXFLAGS/-fno-exceptions/-fexceptions}"

	unpack "${MY_P}".tar.gz

	chmod -R ug+w *

	cd "${WORKDIR}"/"${MY_P}"
	for (( i=1 ; i<=${PATCHNO} ; i++ ))
	do
		epatch "${DISTDIR}"/patch."${MY_PV}"."${i}"
	done

	# Get db to link libdb* to correct dependencies ... for example if we use
	# NPTL or NGPT, db detects usable mutexes, and should link against
	# libpthread, but does not do so ...
	# <azarah@gentoo.org> (23 Feb 2003)
	epatch "${FILESDIR}"/${MY_P}-fix-dep-link.patch

	# We should get dump185 to link against system db1 ..
	# <azarah@gentoo.org> (23 Feb 2003)
	mv "${S}"/dist/Makefile.in "${S}"/dist/Makefile.in.orig
	sed -e 's:DB185INC=:DB185INC= -I/usr/include/db1:' \
		-e 's:DB185LIB=:DB185LIB= -ldb1:' \
		"${S}"/dist/Makefile.in.orig > "${S}"/dist/Makefile.in || die "Failed to sed"

	epatch "${FILESDIR}"/${MY_P}-gcc43.patch

	# Fix invalid .la files
	cd "${WORKDIR}"/${MY_P}/dist
	rm -f ltversion.sh
	# remove config.guess else we have problems with gcc-3.2
	rm -f config.guess
	sed -i "s,\(-D_GNU_SOURCE\),\1 ${CFLAGS}," configure

}

src_compile() {
	local conf=
	local conf_shared=
	local conf_static=

	conf="${conf}
		--host=${CHOST} \
		--build=${CHOST} \
		--enable-cxx \
		--enable-compat185 \
		--enable-dump185 \
		--prefix=/usr"

	# --enable-rpc DOES NOT BUILD
	# Robin H. Johnson <robbat2@gentoo.org> (18 Oct 2003)

	conf_shared="${conf_shared}
		--enable-dynamic"

	# TCL support is also broken
	# Robin H. Johnson <robbat2@gentoo.org> (18 Oct 2003)
	# conf_shared="${conf_shared}
	#	`use_enable tcl tcl`
	#	`use_with tcl tcl /usr/$(get_libdir)`"

	# NOTE: we should not build both shared and static versions
	#       of the libraries in the same build root!

	einfo "Configuring ${P} (static)..."
	mkdir -p "${S}"/build-static
	cd "${S}"/build-static
	strip=/bin/true \
	ECONF_SOURCE="${S}"/dist econf \
		${conf} ${conf_static} \
		--libdir=/usr/$(get_libdir) \
		--disable-shared \
		--enable-static || die

	einfo "Configuring ${P} (shared)..."
	mkdir -p "${S}"/build-shared
	cd "${S}"/build-shared
	strip=/bin/true \
	ECONF_SOURCE="${S}"/dist econf \
		${conf} ${conf_shared} \
		--libdir=/usr/$(get_libdir) \
		--disable-static \
		--enable-shared || die

	# Parallel make does not work
	MAKEOPTS="${MAKEOPTS} -j1"
	einfo "Building ${P} (static)..."
	cd "${S}"/build-static
	emake strip=/bin/true || die "Static build failed"
	einfo "Building ${P} (shared)..."
	cd "${S}"/build-shared
	emake strip=/bin/true || die "Shared build failed"
}

src_install () {
	cd "${S}"/build-shared
	make libdb=libdb-3.2.a \
		libcxx=libcxx_3.2.a \
		prefix="${D}"/usr \
		libdir="${D}"/usr/$(get_libdir) \
		strip=/bin/true \
		install || die

	cd "${S}"/build-static
	newlib.a libdb.a libdb-3.2.a || die "failed to package static libraries!"
	newlib.a libdb_cxx.a libdb_cxx-3.2.a || die "failed to package static libraries!"

	db_src_install_headerslot || die "db_src_install_headerslot failed!"

	# this is now done in the db eclass, function db_fix_so and db_src_install_usrlibcleanup
	#cd "${D}"/usr/lib
	#ln -s libdb-3.2.so libdb.so.3

	# For some reason, db.so's are *not* readable by group or others,
	# resulting in no one but root being able to use them!!!
	# This fixes it -- DR 15 Jun 2001
	cd "${D}"/usr/$(get_libdir)
	chmod go+rx *.so
	# The .la's aren't readable either
	chmod go+r *.la

	cd "${S}"
	dodoc README

	db_src_install_doc || die "db_src_install_doc failed!"

	db_src_install_usrbinslot || die "db_src_install_usrbinslot failed!"

	db_src_install_usrlibcleanup || die "db_src_install_usrlibcleanup failed!"
}

pkg_postinst () {
	db_fix_so
}

pkg_postrm () {
	db_fix_so
}

src_test() {
	if use test; then
		eerror "We'd love to be able to test, but the testsuite is broken in the 3.2.9 series"
	fi
}
