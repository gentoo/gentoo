# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic multilib

SOVER=$(ver_cut 1)

DESCRIPTION="Software for graph, mesh and hypergraph partitioning"
HOMEPAGE="https://www.labri.u-bordeaux.fr/perso/pelegrin/scotch/ https://gitlab.inria.fr/scotch/scotch"
SRC_URI="https://gitlab.inria.fr/${PN}/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="CeCILL-2"
SLOT="0/${SOVER}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc int64 mpi static-libs test tools +threads"
# bug #532620
REQUIRED_USE="test? ( threads )"
RESTRICT="!test? ( test )"

DEPEND="
	sys-libs/zlib
	mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

static_to_shared() {
	local libstatic=${1}; shift
	local libname=$(basename ${libstatic%.a})
	local soname=${libname}$(get_libname ${SOVER})
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
		VERS_COMP=${PV//.}
		[[ "${#VERS_COMP}" -gt 1 ]] && \
			ln -s ${soname} ${libdir}/${libname}$(get_libname ${SOVER})
		ln -s ${soname} ${libdir}/${libname}$(get_libname)
	fi
}

src_prepare() {
	default
	use int64 && append-cflags -DIDXSIZE64
	if use threads; then
		append-cflags "-DSCOTCH_PTHREAD_NUMBER=$(nproc)"
	else
		append-cflags "-DSCOTCH_PTHREAD_NUMBER=1"
		sed -i \
			-e 's/ -DSCOTCH_PTHREAD//' \
			src/Make.inc/Makefile.inc.i686_pc_linux3 || die
	fi

	# Be careful with replacing here, bug #577272
	sed -e "s/= gcc$/= $(tc-getCC)/" \
		-e "s/-O3/${CFLAGS} -pthread/" \
		-e "s/= ar$/= $(tc-getAR)/" \
		-e "s/= ranlib$/= $(tc-getRANLIB)/" \
		-e "s/= ranlib$/= $(tc-getRANLIB)/" \
		-e "/^LDFLAGS/ s/$/ ${LDFLAGS}/" \
		src/Make.inc/Makefile.inc.i686_pc_linux3 > src/Makefile.inc || die
}

src_compile() {
	emake -C src CLIBFLAGS=-fPIC scotch esmumps
	static_to_shared lib/libscotcherr.a
	static_to_shared lib/libscotcherrexit.a
	static_to_shared lib/libscotch.a -Llib -lz -lm -lrt -lpthread -lscotcherr
	static_to_shared lib/libesmumps.a -Llib -lscotch
	static_to_shared lib/libscotchmetisv3.a -Llib -lscotch
	static_to_shared lib/libscotchmetisv5.a -Llib -lscotch

	if use mpi; then
		emake -C src CLIBFLAGS=-fPIC ptscotch ptesmumps
		export LINK=mpicc
		static_to_shared lib/libptscotcherr.a
		static_to_shared lib/libptscotcherrexit.a
		static_to_shared lib/libptscotch.a -Llib -lscotch -lptscotcherr -lz -lm -lrt
		static_to_shared lib/libptesmumps.a -Llib -lscotch -lptscotch
	fi
	if use static-libs; then
		emake -C src clean
		emake -C src
		use mpi && emake -C src ptscotch
	fi
}

src_test() {
	tc-export FC
	LD_LIBRARY_PATH="${S}/lib" emake -C src check
}

src_install() {
	dolib.so lib/lib*$(get_libname)*
	use static-libs && dolib.a lib/*.a

	# Install metis headers into a subdir
	# to allow usage of real metis and scotch
	# in the same code
	insinto /usr/include/scotch/metis
	doins include/*metis*
	rm include/*metis* || die

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
		Cflags: -I\${includedir}/scotch/metis
	EOF
	insinto /usr/$(get_libdir)/pkgconfig
	doins scotchmetis.pc

	# Not sure it is actually a full replacement of metis
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
			Cflags: -I\${includedir}/scotch/metis
			Requires: scotchmetis
		EOF
			insinto /usr/$(get_libdir)/pkgconfig
			doins ptscotchparmetis.pc
			# Not sure it is actually a full replacement of parmetis
			#alternatives_for metis-mpi ptscotch 0 \
			#	/usr/$(get_libdir)/pkgconfig/metis-mpi.pc ptscotchparmetis.pc
	fi

	dodoc README.txt

	if use tools; then
		local b m
		pushd bin > /dev/null || die
		for b in *; do
			newbin ${b} scotch_${b}
		done
		popd > /dev/null || die

		pushd man/man1 > /dev/null || die
		for m in *.1; do
			newman ${m} scotch_${m}
		done
		popd > /dev/null || die
	fi

	use doc && dodoc doc/*.pdf
}
