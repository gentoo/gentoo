# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs versionator flag-o-matic multilib

# use esmumps version to allow linking with mumps
MYP="${PN}_${PV}_esmumps"
# download id on gforge changes every goddamn release
DID=28978

DESCRIPTION="Software for graph, mesh and hypergraph partitioning"
HOMEPAGE="http://www.labri.u-bordeaux.fr/perso/pelegrin/scotch/"
# broken ssl cert, so mirroring
#SRC_URI="http://gforge.inria.fr/frs/download.php/${DID}/${MYP}.tar.gz"
SRC_URI="http://dev.gentooexperimental.org/~patrick/${MYP}.tar.gz"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples int64 mpi static-libs tools"

DEPEND="sys-libs/zlib
	mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MYP/b}"

static_to_shared() {
	local libstatic=${1}; shift
	local libname=$(basename ${libstatic%.a})
	local soname=${libname}$(get_libname $(get_version_component_range 1-2))
	local libdir=$(dirname ${libstatic})

	einfo "Making ${soname} from ${libstatic}"
	if [[ ${CHOST} == *-darwin* ]] ; then
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-dynamiclib -install_name "${EPREFIX}"/usr/lib/"${soname}" \
			-Wl,-all_load -Wl,${libstatic} \
			"$@" -o ${libdir}/${soname} || die "${soname} failed"
	else
		${LINK:-$(tc-getCC)} ${LDFLAGS}  \
			-shared -Wl,-soname=${soname} \
			-Wl,--whole-archive ${libstatic} -Wl,--no-whole-archive \
			"$@" -o ${libdir}/${soname} || die "${soname} failed"
		[[ $(get_version_component_count) -gt 1 ]] && \
			ln -s ${soname} ${libdir}/${libname}$(get_libname $(get_major_version))
		ln -s ${soname} ${libdir}/${libname}$(get_libname)
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-as-needed.patch
	sed -e "s/gcc/$(tc-getCC)/" \
		-e "s/-O3/${CFLAGS} -pthread/" \
		-e "s/ ar/ $(tc-getAR)/" \
		-e "s/ranlib/$(tc-getRANLIB)/" \
		src/Make.inc/Makefile.inc.i686_pc_linux2 > src/Makefile.inc || die
	use int64 && append-cflags -DIDXSIZE64
}

src_compile() {
	emake -C src CLIBFLAGS=-fPIC
	static_to_shared lib/libscotcherr.a
	static_to_shared lib/libscotcherrexit.a
	static_to_shared lib/libscotch.a -Llib -lz -lm -lrt -lscotcherr
	static_to_shared lib/libesmumps.a -Llib -lscotch
	static_to_shared lib/libscotchmetis.a -Llib -lscotch

	if use mpi; then
		emake -C src CLIBFLAGS=-fPIC ptscotch
		export LINK=mpicc
		static_to_shared lib/libptscotcherr.a
		static_to_shared lib/libptscotcherrexit.a
		static_to_shared lib/libptscotch.a -Llib -lptscotcherr -lz -lm -lrt
		static_to_shared lib/libptesmumps.a -Llib -lptscotch
		static_to_shared lib/libptscotchparmetis.a -Llib -lptscotch
	fi
	if use static-libs; then
		emake -C src clean
		emake -C src
		use mpi && emake -C src ptscotch
	fi
}

src_install() {
	dolib.so lib/lib*$(get_libname)*
	use static-libs && dolib.a lib/*.a

	insinto /usr/include/scotch
	doins include/*

	cat <<-EOF > scotchmetis.pc
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include
		Name: scotchmetis
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Libs: -L\${libdir} -lscotchmetis -lscotcherr -lscotch
		Private: -lm -lz -lrt
		Cflags: -I\${includedir}/scotch
	EOF
	insinto /usr/$(get_libdir)/pkgconfig
	doins scotchmetis.pc

	# not sure it is actually a full replacement of metis
	#alternatives_for metis scotch 0 \
	#	/usr/$(get_libdir)/pkgconfig/metis.pc scotchmetis.pc

	if use mpi; then
		cat <<-EOF > ptscotchparmetis.pc
			prefix=${EPREFIX}/usr
			libdir=\${prefix}/$(get_libdir)
			includedir=\${prefix}/include
			Name: ptscotchparmetis
			Description: ${DESCRIPTION}
			Version: ${PV}
			URL: ${HOMEPAGE}
			Libs: -L\${libdir} -lptscotchparmetis -lptscotcherr -lptscotch
			Private: -lm -lz -lrt
			Cflags: -I\${includedir}/scotch
			Requires: scotchmetis
		EOF
			insinto /usr/$(get_libdir)/pkgconfig
			doins ptscotchparmetis.pc
			# not sure it is actually a full replacement of parmetis
			#alternatives_for metis-mpi ptscotch 0 \
			#	/usr/$(get_libdir)/pkgconfig/metis-mpi.pc ptscotchparmetis.pc
	fi

	dodoc README.txt

	if use tools; then
		local b m
		pushd bin > /dev/null
		for b in *; do
			newbin ${b} scotch_${b}
		done
		popd > /dev/null

		pushd man/man1 > /dev/null
		for m in *; do
			newman ${m} scotch_${m}
		done
		popd > /dev/null
	fi

	use doc && dodoc doc/*.pdf

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/* tgt grf
	fi
}
