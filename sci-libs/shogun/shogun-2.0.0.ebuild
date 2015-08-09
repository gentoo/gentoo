# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib versionator toolchain-funcs java-pkg-opt-2

MYPV=$(get_version_component_range 1-2)
MYPD=${PN}-data-0.4

DESCRIPTION="Large Scale Machine Learning Toolbox"
HOMEPAGE="http://shogun-toolbox.org/"
SRC_URI="ftp://shogun-toolbox.org/shogun/releases/${MYPV}/sources/${P}.tar.bz2
	test? ( ftp://shogun-toolbox.org/shogun/data/${MYPD}.tar.bz2 )
	examples? ( ftp://shogun-toolbox.org/shogun/data/${MYPD}.tar.bz2 )"

LICENSE="GPL-3 free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="arpack bzip2 doc eigen examples glpk gzip hdf5 json lapack lpsolve mono lua lzma
	lzo nlopt java R ruby octave python readline smp snappy static-libs superlu test xml"

RDEPEND="
	sci-libs/gsl
	sys-libs/zlib
	arpack? ( sci-libs/arpack )
	bzip2? ( app-arch/bzip2 )
	eigen? ( >=dev-cpp/eigen-3 )
	glpk? ( sci-mathematics/glpk )
	gzip? ( app-arch/gzip )
	hdf5? ( sci-libs/hdf5 )
	java? ( >=virtual/jdk-1.5 )
	json? ( dev-libs/json-c )
	lapack? ( virtual/cblas virtual/lapack )
	lpsolve? ( sci-mathematics/lpsolve )
	lua? ( dev-lang/lua )
	lzo? ( dev-libs/lzo )
	mono? ( dev-lang/mono )
	nlopt? ( sci-libs/nlopt )
	octave? ( sci-mathematics/octave[hdf5=] )
	python? ( dev-python/numpy )
	R? ( dev-lang/R )
	readline? ( sys-libs/readline )
	ruby? ( >=dev-ruby/narray-0.6.0.1-r2 )
	snappy? ( app-arch/snappy )
	superlu? ( sci-libs/superlu )
	xml? ( dev-libs/libxml2 )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
	java? ( >=dev-lang/swig-2.0.4 dev-java/ant )
	octave? ( >=dev-lang/swig-2.0.4 )
	python? ( >=dev-lang/swig-2.0.4 test? ( sci-libs/scipy ) )
	ruby? ( >=dev-lang/swig-2.0.4 )"

S="${WORKDIR}/${P}/src"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.1.0-respect-ldflags.patch \
		"${FILESDIR}"/${PN}-1.1.0-test-readline.patch \
		"${FILESDIR}"/${PN}-1.1.0-as-needed.patch

	# dist-packages is only for debian
	# remove exagarated optimizations (-O9 does not exist...)
	# use gentoo lapack framework
	sed -i \
		-e 's/dist-packages/site-packages/g' \
		-e '/^COMP_OPTS=/d' \
		-e "s:-llapack -lcblas:$($(tc-getPKG_CONFIG) --libs cblas lapack):g" \
		configure || die

	# disable ldconfig which violates sandbox
	# install in gentoo java standard paths
	sed -i \
		-e '/ldconfig/d' \
		-e '/share\/java/d' \
		-e '/jni/d' \
		-e 's/OCTAVE_LOADPATH/OCTAVE_PATH/g' \
		Makefile.template || die
}

src_configure() {
	# define interfaces to shogun library to build
	local x iface
	for x in java lua octave python ruby ; do
		use ${x} && iface="${iface}${x}_modular,"
	done
	use mono &&	iface="${iface}csharp_modular,"
	use R && iface="${iface}r_modular,"
	if use static-libs; then
		iface="${iface}cmdline_static,"
		use octave && iface="${iface}octave_static,"
		use python && iface="${iface}python_static,"
		use R && iface="${iface}r_static,"
		use octave && use python && use R && iface="${iface}elwms_static,"
	fi
	iface="${iface%,}"

	# gentoo bug #302621
	use hdf5 && has_version sci-libs/hdf5[mpi] && export CXX=mpicxx CC=mpicc
	./configure \
		--disable-cpudetection \
		--destdir="${D}" \
		--prefix="${EPREFIX}/usr" \
		--mandir="${EPREFIX}/usr/share/man" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--cc="$(tc-getCC)" \
		--cxx="$(tc-getCXX)" \
		--target="${CTARGET}" \
		--interfaces=${iface} \
		$(use_enable arpack) \
		$(use_enable bzip2) \
		$(use_enable doc doxygen) \
		$(use_enable eigen eigen3) \
		$(use_enable glpk) \
		$(use_enable gzip) \
		$(use_enable hdf5) \
		$(use_enable json) \
		$(use_enable lapack) \
		$(use_enable lpsolve) \
		$(use_enable lzma) \
		$(use_enable lzo) \
		$(use_enable nlopt) \
		$(use_enable readline) \
		$(use_enable smp hmm-parallel) \
		$(use_enable snappy) \
		$(use_enable static-libs static) \
		$(use_enable superlu) \
		$(use_enable xml) || die
}

src_compile() {
	emake
	use doc && emake -C ../doc
}

src_test() {
	use lapack || return
	ln -s ../../${MYPD}/* ../data/
	emake DESTDIR="${D}" install
	# disable because very long
	# emake tests
	emake -C shogun check-examples
}

src_install() {
	default
	use static-libs || rm "${ED}"/usr/$(get_libdir)/*.a
	if use java; then
		java-pkg_dojar interfaces/java_modular/shogun.jar
		java-pkg_doso interfaces/java_modular/libmodshogun.so
	fi

	use doc && dohtml -r ../doc/html/*
	if use examples; then
		insinto /usr/share/doc/${PF}
		emake -C ../examples clean && doins -r ../examples
		insinto /usr/share/doc/${PF}/data
		doins -r "${WORKDIR}"/${MYPD}/*
	fi
}
