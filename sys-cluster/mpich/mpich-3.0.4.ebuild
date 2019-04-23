# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

FORTRAN_NEEDED=fortran

inherit fortran-2

MY_PV=${PV/_/}
DESCRIPTION="A high performance and portable MPI implementation"
HOMEPAGE="http://www.mpich.org/"
SRC_URI="http://www.mpich.org/static/downloads/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="mpich2"
KEYWORDS="amd64 hppa ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="+cxx doc fortran mpi-threads romio threads"

COMMON_DEPEND="
	dev-libs/libaio
	<sys-apps/hwloc-2
	romio? ( net-fs/nfs-utils )"

DEPEND="${COMMON_DEPEND}
	dev-lang/perl
	sys-devel/libtool"

RDEPEND="${COMMON_DEPEND}
	!sys-cluster/mpich2
	!sys-cluster/openmpi"

S="${WORKDIR}"/${PN}-${MY_PV}

pkg_setup() {
	FORTRAN_STANDARD="77 90"
	fortran-2_pkg_setup

	if use mpi-threads && ! use threads; then
		ewarn "mpi-threads requires threads, assuming that's what you want"
	fi
}

src_prepare() {
	# Using MPICHLIB_LDFLAGS doesn't seem to fully work.
	sed -i 's| *@WRAPPER_LDFLAGS@ *||' \
		src/packaging/pkgconfig/mpich.pc.in \
		src/env/*.in \
		|| die
}

src_configure() {
	local c="--enable-shared"

	# The configure statements can be somewhat confusing, as they
	# don't all show up in the top level configure, however, they
	# are picked up in the children directories.

	if use mpi-threads; then
		# MPI-THREAD requries threading.
		c="${c} --with-thread-package=pthreads"
		c="${c} --enable-threads=runtime"
	else
		if use threads ; then
			c="${c} --with-thread-package=pthreads"
		else
			c="${c} --with-thread-package=none"
		fi
		c="${c} --enable-threads=single"
	fi

	c="${c} --sysconfdir=${EPREFIX}/etc/${PN}"
	c="${c} --docdir=${EPREFIX}/usr/share/doc/${PF}"

	export MPICHLIB_CFLAGS=${CFLAGS}
	export MPICHLIB_CPPFLAGS=${CPPFLAGS}
	export MPICHLIB_CXXFLAGS=${CXXFLAGS}
	export MPICHLIB_FFLAGS=${FFLAGS}
	export MPICHLIB_FCFLAGS=${FCFLAGS}
	export MPICHLIB_LDFLAGS=${LDFLAGS}
	unset CFLAGS CPPFLAGS CXXFLAGS FFLAGS FCFLAGS LDFLAGS

	econf ${c} \
		--with-pm=hydra \
		--disable-mpe \
		--disable-fast \
		--enable-smpcoll \
		--enable-versioning \
		--with-hwloc-prefix=/usr \
		$(use_enable romio) \
		$(use_enable cxx) \
		$(use_enable fortran f77) \
		$(use_enable fortran fc)
}

src_test() {
	emake -j1 check
}

src_install() {
	default

	dodir /usr/share/doc/${PF}
	dodoc README{,.envvar} CHANGES RELEASE_NOTES
	newdoc src/pm/hydra/README README.hydra
	if use romio; then
		newdoc src/mpi/romio/README README.romio
	fi

	if ! use doc; then
		rm -rf "${D}"usr/share/doc/${PF}/www*
	fi
}
