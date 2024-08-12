# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit python-r1 toolchain-funcs

MY_PV="${PV/_rc/-rc}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Jens Axboe's Flexible IO tester"
HOMEPAGE="https://brick.kernel.dk/snaps/"
SRC_URI="https://brick.kernel.dk/snaps/${MY_P}.tar.bz2"

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~x86"

IUSE="aio curl glusterfs gnuplot gtk io-uring nfs numa pandas python rbd rdma static tcmalloc test valgrind zbc zlib"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
	gnuplot? ( python )
	io-uring? ( aio )"

RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"

# GTK+:2 does not offer static libaries.
# xnvme
# libblkio
# pmem2
LIB_DEPEND="aio? ( dev-libs/libaio[static-libs(+)] )
	curl? (
		net-misc/curl:=[static-libs(+)]
		dev-libs/openssl:0=[static-libs(+)]
	)
	nfs? ( net-fs/libnfs:=[static-libs(+)] )
	glusterfs? ( sys-cluster/glusterfs[static-libs(+)] )
	gtk? ( dev-libs/glib:2[static-libs(+)] )
	io-uring? ( sys-libs/liburing:=[static-libs(+)] )
	numa? ( sys-process/numactl[static-libs(+)] )
	rbd? ( sys-cluster/ceph[static-libs(+)] )
	rdma? ( sys-cluster/rdma-core[static-libs(+)] )
	tcmalloc? ( dev-util/google-perftools:=[static-libs(+)] )
	zbc? ( >=sys-block/libzbc-5 )
	zlib? ( sys-libs/zlib[static-libs(+)] )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )
	test? ( dev-util/cunit )
	valgrind? ( dev-debug/valgrind )"
RDEPEND+="
	python? (
		${PYTHON_DEPS}
		pandas? ( dev-python/pandas[${PYTHON_USEDEP}] )
	)
	gnuplot? ( sci-visualization/gnuplot )"

PATCHES=(
	"${FILESDIR}"/fio-2.2.13-libmtd.patch
)

QA_CONFIG_IMPL_DECL_SKIP+=(
	# Internally uses -Werror=implicit-function-declaration for all configure
	# checks. bug #904276
	'*'
)

src_prepare() {
	default

	sed -i '/^DEBUGFLAGS/s: -D_FORTIFY_SOURCE=2::g' Makefile || die

	# Many checks don't have configure flags.
	sed -i \
		-e "s:\<pkg-config\>:$(tc-getPKG_CONFIG):" \
		-e '/if compile_prog "" "-lzbc" "libzbc" *; *then/  '"s::if $(usex zbc true false) ; then:" \
		-e '/if compile_prog "" "-lz" "zlib" *; *then/  '"s::if $(usex zlib true false) ; then:" \
		-e '/if compile_prog "" "-laio" "libaio" *; *then/'"s::if $(usex aio true false) ; then:" \
		-e '/if compile_prog "" "-lcunit" "CUnit" *; *then/'"s::if $(usex test true false) ; then:" \
		-e '/if compile_prog "" "" "valgrind_dev" *; *then/'"s::if $(usex valgrind true false) ; then:" \
		configure || die
}

src_configure() {
	chmod g-w "${T}"
	# not a real configure script
	# TODO: cuda
	# TODO: libnbd - not packaged in Gentoo
	# TODO: pmem - not packaged in Gentoo
	# TODO: libblkiio - not packaged in Gentoo
	# TODO: xnvme - not packaged in Gentoo
	# TODO: libhdfs
	# libnfs option does not work as expected:
	# $(usex nfs '' '--disable-libnfs') \
	OPTS=(
		--disable-optimizations
		--extra-cflags="${CFLAGS} ${CPPFLAGS}"
		--cc="$(tc-getCC)"
		--disable-pmem
		--disable-xnvme
		--disable-libblkio
		# Not booleans, enable-only up to this version
		#--disable-cuda
		#--disable-libcufile
		#--disable-libhdfs
		--disable-dfs
		$(usex nfs '' '--disable-libnfs')
		$(usex curl '' '--disable-http')
		$(usex glusterfs '' '--disable-gfapi')
		$(usex gtk '--enable-gfio' '')
		$(usex numa '' '--disable-numa')
		$(usex rbd '' '--disable-rbd')
		$(usex rdma '' '--disable-rdma')
		$(usex static '--build-static' '')
		$(usex tcmalloc '' '--disable-tcmalloc')
	)
	set -- \
	# not autoconf
	./configure "${OPTS[@]}"
	echo "$@" |tr ' ' '\n'
	"$@" || die 'configure failed'
}

src_compile() {
	emake V=1 OPTFLAGS=
}

src_install() {
	emake install DESTDIR="${D}" prefix="${EPREFIX}/usr" mandir="${EPREFIX}/usr/share/man"

	local python2_7_files=(
		"${ED}"/usr/bin/fiologparser_hist.py
		"${ED}"/usr/bin/fiologparser.py
	)
	local python_files=(
		"${python2_7_files[@]}"
		"${ED}"/usr/bin/fio_jsonplus_clat2csv
	)
	if use python ; then
		sed -i 's:python2.7:python:g' "${python2_7_files[@]}" || die
		python_replicate_script "${python2_7_files[@]}"
		use pandas || rm -f "${ED}"/usr/bin/fiologparser_hist.py
	else
		rm "${python_files[@]}" || die
	fi

	local gnuplot_python2_7_files=(
		"${ED}"/usr/bin/fio2gnuplot
	)
	local gnuplot_files=(
		"${gnuplot_python2_7_files[@]}"
		"${ED}"/usr/bin/fio_generate_plots
		"${ED}"/usr/share/man/man1/fio_generate_plots.1
		"${ED}"/usr/share/man/man1/fio2gnuplot.1
		"${ED}"/usr/share/fio/*.gpm
	)
	if use gnuplot ; then
		sed -i 's:python2.7:python:g' "${gnuplot_python2_7_files[@]}" || die
		python_replicate_script "${gnuplot_python2_7_files[@]}"
	else
		rm "${gnuplot_files[@]}" || die
		rmdir "${ED}"/usr/share/fio/ || die
	fi

	# This tool has security/parallel issues -- it hardcodes /tmp/template.fio.
	rm "${ED}"/usr/bin/genfio || die

	dodoc README.rst REPORTING-BUGS HOWTO.rst
	docinto examples
	dodoc examples/*
}
