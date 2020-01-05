# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python2_7 python3_6 )

inherit python-r1 toolchain-funcs

MY_PV="${PV/_rc/-rc}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Jens Axboe's Flexible IO tester"
HOMEPAGE="https://brick.kernel.dk/snaps/"
SRC_URI="https://brick.kernel.dk/snaps/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~x86"
IUSE="aio curl glusterfs gnuplot gtk libressl numa rbd rdma static tcmalloc zlib"
REQUIRED_USE="gnuplot? ( ${PYTHON_REQUIRED_USE} )
	libressl? ( curl )"

BDEPEND="virtual/pkgconfig"

# GTK+:2 does not offer static libaries.
LIB_DEPEND="aio? ( dev-libs/libaio[static-libs(+)] )
	curl? (
		net-misc/curl:=[static-libs(+)]
		!libressl? ( dev-libs/openssl:0=[static-libs(+)] )
		libressl? ( dev-libs/libressl:0=[static-libs(+)] )
	)
	glusterfs? ( sys-cluster/glusterfs[static-libs(+)] )
	gtk? ( dev-libs/glib:2[static-libs(+)] )
	numa? ( sys-process/numactl[static-libs(+)] )
	rbd? ( sys-cluster/ceph[static-libs(+)] )
	rdma? (
		sys-fabric/libibverbs[static-libs(+)]
		sys-fabric/librdmacm[static-libs(+)]
	)
	tcmalloc? ( dev-util/google-perftools:=[static-libs(+)] )
	zlib? ( sys-libs/zlib[static-libs(+)] )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	gtk? ( x11-libs/gtk+:2 )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"
RDEPEND+="
	gnuplot? (
		sci-visualization/gnuplot
		$(python_gen_any_dep 'dev-python/pandas[${PYTHON_USEDEP}]')
		${PYTHON_DEPS}
	)"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/fio-2.2.13-libmtd.patch
	"${FILESDIR}"/fio-3.16-snprintf.patch
)

python_check_deps() {
	has_version "dev-python/pandas[${PYTHON_USEDEP}]"
}

src_prepare() {
	default

	sed -i '/^DEBUGFLAGS/s: -D_FORTIFY_SOURCE=2::g' Makefile || die

	# Many checks don't have configure flags.
	sed -i \
		-e "s:\<pkg-config\>:$(tc-getPKG_CONFIG):" \
		-e '/if compile_prog "" "-lz" "zlib" *; *then/  '"s::if $(usex zlib true false) ; then:" \
		-e '/if compile_prog "" "-laio" "libaio" ; then/'"s::if $(usex aio true false) ; then:" \
		configure || die
}

src_configure() {
	chmod g-w "${T}"
	# not a real configure script
	# TODO: pmem
	set -- \
	./configure \
		--disable-optimizations \
		--extra-cflags="${CFLAGS} ${CPPFLAGS}" \
		--cc="$(tc-getCC)" \
		--disable-pmem \
		$(usex curl '' '--disable-http') \
		$(usex glusterfs '' '--disable-gfapi') \
		$(usex gtk '--enable-gfio' '') \
		$(usex numa '' '--disable-numa') \
		$(usex rbd '' '--disable-rbd') \
		$(usex rdma '' '--disable-rdma') \
		$(usex static '--build-static' '') \
		$(usex tcmalloc '' '--disable-tcmalloc')
	echo "$@"
	"$@" || die 'configure failed'
}

src_compile() {
	emake V=1 OPTFLAGS=
}

src_install() {
	emake install DESTDIR="${D}" prefix="${EPREFIX}/usr" mandir="${EPREFIX}/usr/share/man"

	if use gnuplot ; then
		sed -i 's:python2.7:python:g' \
			"${ED}/usr/bin/fio2gnuplot" \
			"${ED}/usr/bin/fiologparser_hist.py" \
			"${ED}/usr/bin/fiologparser.py"
		python_replicate_script \
			"${ED}/usr/bin/fio2gnuplot" \
			"${ED}/usr/bin/fiologparser_hist.py" \
			"${ED}/usr/bin/fiologparser.py"
	else
		rm "${ED}"/usr/bin/{fio2gnuplot,fio_generate_plots} || die
		rm "${ED}"/usr/share/man/man1/{fio2gnuplot,fio_generate_plots}.1 || die
		rm "${ED}"/usr/share/fio/*.gpm || die
		rmdir "${ED}"/usr/share/fio/ 2>/dev/null
	fi

	# This tool has security/parallel issues -- it hardcodes /tmp/template.fio.
	rm "${ED}"/usr/bin/genfio || die

	dodoc README REPORTING-BUGS HOWTO
	docinto examples
	dodoc examples/*
}
