# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/fio/fio-2.2.9.ebuild,v 1.2 2015/07/08 04:43:18 vapier Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )
inherit eutils python-r1 toolchain-funcs

MY_PV="${PV/_rc/-rc}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Jens Axboe's Flexible IO tester"
HOMEPAGE="http://brick.kernel.dk/snaps/"
SRC_URI="http://brick.kernel.dk/snaps/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 ~x86"
IUSE="aio glusterfs gnuplot gtk numa rbd rdma zlib"

DEPEND="aio? ( dev-libs/libaio )
	glusterfs? ( !arm? ( sys-cluster/glusterfs ) )
	gtk? (
		dev-libs/glib:2
		x11-libs/gtk+:2
	)
	numa? ( sys-process/numactl )
	rbd? ( sys-cluster/ceph )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}
	gnuplot? (
		sci-visualization/gnuplot
		${PYTHON_DEPS}
	)"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i '/^DEBUGFLAGS/s: -D_FORTIFY_SOURCE=2::g' Makefile || die
	epatch "${FILESDIR}"/${P}-atomic-sync.patch
	epatch_user

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
	./configure \
		--extra-cflags="${CFLAGS} ${CPPFLAGS}" \
		--cc="$(tc-getCC)" \
		$(usex glusterfs '' '--disable-gfapi') \
		$(usex gtk '--enable-gfio' '') \
		$(usex numa '' '--disable-numa') \
		$(usex rbd '' '--disable-rbd') \
		|| die 'configure failed'
}

src_compile() {
	emake V=1 OPTFLAGS=
}

src_install() {
	emake install DESTDIR="${D}" prefix="${EPREFIX}/usr" mandir="${EPREFIX}/usr/share/man"

	if use gnuplot ; then
		python_replicate_script "${ED}/usr/bin/fio2gnuplot"
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
