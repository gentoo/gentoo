# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit db flag-o-matic multilib

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

DESCRIPTION="Berkeley DB for transaction support in MySQL"
HOMEPAGE="http://www.oracle.com/technetwork/database/database-technologies/berkeleydb/overview/index.html"
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
RESTRICT="!test? ( test )"

DEPEND="${RDEPEND}
	=sys-libs/db-1.85*"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	# Get db to link libdb* to correct dependencies ... for example if we use
	# NPTL or NGPT, db detects usable mutexes, and should link against
	# libpthread, but does not do so ...
	# <azarah@gentoo.org> (23 Feb 2003)
	"${FILESDIR}"/${MY_P}-fix-dep-link.patch

	"${FILESDIR}"/${MY_P}-gcc43.patch
)

pkg_setup() {
	# This doesn't build without exceptions
	replace-flags -fno-exceptions -fexceptions
}

src_prepare() {
	for (( i=1 ; i<=${PATCHNO} ; i++ ))
	do
		eapply -p0 "${DISTDIR}"/patch."${MY_PV}"."${i}"
	done

	default

	# We should get dump185 to link against system db1 ..
	# <azarah@gentoo.org> (23 Feb 2003)
	mv dist/Makefile.in{,.orig} || die
	sed \
		-e 's:DB185INC=:DB185INC= -I/usr/include/db1:' \
		-e 's:DB185LIB=:DB185LIB= -ldb1:' \
		dist/Makefile.in.orig \
		> dist/Makefile.in || die

	cd dist || die
	# remove config.guess else we have problems with gcc-3.2
	rm config.guess || die
	sed -i "s,\(-D_GNU_SOURCE\),\1 ${CFLAGS}," configure || die
}

src_configure() {
	local conf=(
		--host=${CHOST}
		--build=${CHOST}
		--enable-cxx
		--enable-compat185
		--enable-dump185
	)

	local conf_shared=(
		--disable-static
		--enable-shared

		# --enable-rpc DOES NOT BUILD
		# Robin H. Johnson <robbat2@gentoo.org> (18 Oct 2003)
		--enable-dynamic
	)

	local conf_static=(
		--disable-shared
		--enable-static
	)

	# TCL support is also broken
	# Robin H. Johnson <robbat2@gentoo.org> (18 Oct 2003)
	# conf_shared="${conf_shared}
	#	`use_enable tcl tcl`
	#	`use_with tcl tcl /usr/$(get_libdir)`"

	# NOTE: we should not build both shared and static versions
	#       of the libraries in the same build root!

	einfo "Configuring ${P} (static)..."
	mkdir build-static || die
	pushd build-static &>/dev/null || die
	strip="${EPREFIX}"/bin/true \
	ECONF_SOURCE="${S}"/dist \
	econf "${conf[@]}" "${conf_static[@]}"
	popd &>/dev/null || die

	einfo "Configuring ${P} (shared)..."
	mkdir build-shared || die
	pushd build-shared &>/dev/null || die
	strip="${EPREFIX}"/bin/true \
	ECONF_SOURCE="${S}"/dist \
	econf "${conf[@]}" "${conf_shared[@]}"
	popd &>/dev/null || die
}

src_compile() {
	# Parallel make does not work
	MAKEOPTS="${MAKEOPTS} -j1"

	einfo "Building ${P} (static)..."
	pushd "${S}"/build-static &>/dev/null || die
	emake strip="${EPREFIX}"/bin/true
	popd &>/dev/null || die

	einfo "Building ${P} (shared)..."
	pushd build-shared &>/dev/null || die
	emake strip="${EPREFIX}"/bin/true
	popd &>/dev/null || die
}

src_install() {
	pushd build-shared &>/dev/null || die
	# build system does not support DESTDIR
	emake \
		libdb=libdb-3.2.a \
		libcxx=libcxx_3.2.a \
		DESTDIR="${D}" \
		prefix="${ED}"/usr \
		libdir="${ED}"/usr/$(get_libdir) \
		strip="${EPREFIX}"/bin/true \
		install
	popd &>/dev/null || die

	pushd build-static &>/dev/null || die
	newlib.a libdb.a libdb-3.2.a
	newlib.a libdb_cxx.a libdb_cxx-3.2.a
	popd &>/dev/null || die

	db_src_install_headerslot || die "db_src_install_headerslot failed!"

	# this is now done in the db eclass, function db_fix_so and db_src_install_usrlibcleanup
	#cd "${D}"/usr/lib
	#ln -s libdb-3.2.so libdb.so.3

	# For some reason, db.so's are *not* readable by group or others,
	# resulting in no one but root being able to use them!!!
	# This fixes it -- DR 15 Jun 2001
	pushd "${ED}"/usr/$(get_libdir) &>/dev/null || die
	chmod go+rx *.so
	# The .la's aren't readable either
	chmod go+r *.la
	popd &>/dev/null || die

	dodoc README

	db_src_install_doc || die "db_src_install_doc failed!"

	db_src_install_usrbinslot || die "db_src_install_usrbinslot failed!"

	db_src_install_usrlibcleanup || die "db_src_install_usrlibcleanup failed!"
}

pkg_postinst() {
	db_fix_so
}

pkg_postrm() {
	db_fix_so
}

src_test() {
	if use test; then
		eerror "We'd love to be able to test, but the testsuite is broken in the 3.2.9 series"
	fi
}
