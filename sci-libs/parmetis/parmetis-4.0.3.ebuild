# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils cmake-utils toolchain-funcs

# Check metis version bundled in parmetis tar ball
# by diff of metis and parmetis tar ball
METISPV=5.1.0
METISP=metis-${METISPV}

DESCRIPTION="Parallel (MPI) unstructured graph partitioning library"
HOMEPAGE="http://www-users.cs.umn.edu/~karypis/metis/parmetis/"
SRC_URI="
	http://glaros.dtc.umn.edu/gkhome/fetch/sw/${PN}/${P}.tar.gz
	doc? ( http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/${METISP}.tar.gz )
	examples? ( http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/${METISP}.tar.gz )"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="free-noncomm"
IUSE="doc double-precision examples int64 mpi openmp pcre static-libs"

DEPEND="mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}
	!<sci-libs/metis-5"

pkg_setup() {
	if use openmp; then
		if [[ $(tc-getCC)$ == *gcc* ]] && ! tc-has-openmp; then
			ewarn "You are using gcc but openmp is not available"
			die "Need an OpenMP capable compiler"
		fi
	fi
}

src_prepare() {
	# libdir love
	sed -i \
		-e '/DESTINATION/s/lib/lib${LIB_SUFFIX}/g' \
		libparmetis/CMakeLists.txt metis/libmetis/CMakeLists.txt || die
	# set metis as separate shared lib
	sed -i \
		-e 's/METIS_LIB/ParMETIS_LIB/g' \
		metis/libmetis/CMakeLists.txt || die
	sed -i \
		-e '/programs/d' \
		CMakeLists.txt metis/CMakeLists.txt || die
	use static-libs && mkdir "${WORKDIR}/${PN}_static"

	if use mpi; then
		export CC=mpicc CXX=mpicxx
	else
		sed -i \
			-e '/add_subdirectory(include/d' \
			-e '/add_subdirectory(libparmetis/d' \
			CMakeLists.txt || die

	fi

	use int64 && \
		sed -i -e '/IDXTYPEWIDTH/s/32/64/' metis/include/metis.h

	use double-precision && \
		sed -i -e '/REALTYPEWIDTH/s/32/64/' metis/include/metis.h
}

src_configure() {
	parmetis_configure() {
		local mycmakeargs=(
			-DGKLIB_PATH="${S}/metis/GKlib"
			-DMETIS_PATH="${S}/metis"
			-DGKRAND=ON
			-DMETIS_INSTALL=ON
			$(cmake-utils_use openmp OPENMP)
			$(cmake-utils_use pcre PCRE)
			$@
		)
		cmake-utils_src_configure
	}
	parmetis_configure -DSHARED=ON
	use static-libs && \
		sed -i -e '/fPIC/d' metis/GKlib/GKlibSystem.cmake && \
		BUILD_DIR="${WORKDIR}/${PN}_static" parmetis_configure
}

src_compile() {
	cmake-utils_src_compile
	use static-libs && \
		BUILD_DIR="${WORKDIR}/${PN}_static" cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	use static-libs && \
		BUILD_DIR="${WORKDIR}/${PN}_static" cmake-utils_src_install
	insinto /usr/include
	doins metis/include/metis.h

	newdoc metis/Changelog Changelog.metis}
	use doc && dodoc "${WORKDIR}/${METISP}"/manual/manual.pdf
	if use examples; then
		insinto /usr/share/doc/${PF}/examples/metis
		doins "${WORKDIR}/${METISP}"/{programs,graphs}/*
	fi
	# alternative stuff
	cat > metis.pc <<-EOF
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include
		Name: metis
		Description: Unstructured graph partitioning library
		Version: ${METISPV}
		URL: ${HOMEPAGE/parmetis/metis}
		Libs: -L\${libdir} -lmetis
		Cflags: -I\${includedir}/metis
	EOF
	insinto /usr/$(get_libdir)/pkgconfig
	doins metis.pc
	# change if scotch is actually an alternative to metis
	#alternatives_for metis metis 0 \
	#	/usr/$(get_libdir)/pkgconfig/metis.pc refmetis.pc

	if use mpi; then
		dodoc Changelog
		use doc && dodoc manual/manual.pdf
		if use examples; then
			insinto /usr/share/doc/${PF}/examples/${PN}
			doins {programs,Graphs}/*
		fi
		# alternative stuff
		cat > ${PN}.pc <<-EOF
			prefix=${EPREFIX}/usr
			libdir=\${prefix}/$(get_libdir)
			includedir=\${prefix}/include
			Name: ${PN}
			Description: ${DESCRIPTION}
			Version: ${PV}
			URL: ${HOMEPAGE}
			Libs: -L\${libdir} -l${PN}
			Cflags: -I\${includedir}/${PN}
			Requires: metis
		EOF
		insinto /usr/$(get_libdir)/pkgconfig
		doins ${PN}.pc
		# change if scotch is actually an alternative to parmetis
		#alternatives_for metis-mpi ${PN} 0 \
		#	/usr/$(get_libdir)/pkgconfig/metis-mpi.pc ${PN}.pc
	fi
}
