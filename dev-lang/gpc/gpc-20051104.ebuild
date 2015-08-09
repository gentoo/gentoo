# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils flag-o-matic versionator

strip-flags
filter-flags "-pipe"

#due to cache requirements we cannot dynamically match gcc version
#so sticking to a particular (and working) one
GCCVER="3.4.5"

DESCRIPTION="Gnu Pascal Compiler"
HOMEPAGE="http://gnu-pascal.de"
SRC_URI="http://www.math.uni.wroc.pl/~hebisch/${PN}/${P}.tar.bz2
	ftp://gcc.gnu.org/pub/gcc/releases/gcc-${GCCVER}/gcc-core-${GCCVER}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="nls"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/gcc-${GCCVER}"

# GCC version strings
GCCMAJOR=$(get_version_component_range 1 "${GCCVER}")
GCCMINOR=$(get_version_component_range 2 "${GCCVER}")
GCCBRANCH=$(get_version_component_range 1-2 "${GCCVER}")
GCCRELEASE=$(get_version_component_range 1-3 "${GCCVER}")

# possible future crosscompilation support
export CTARGET=${CTARGET:-${CHOST}}

PREFIX="/usr"
LIBPATH="${PREFIX}/lib/${PN}/${CTARGET}/${GCCBRANCH}"
LIBEXECPATH="${PREFIX}/libexec/${PN}/${CTARGET}/${GCCBRANCH}"
INCLUDEPATH="${LIBPATH}/include"
DATAPATH="${PREFIX}/share"

BUILDDIR="${WORKDIR}/build"

src_unpack() {
	unpack ${A}

	cd "${WORKDIR}/${P}/p"

	#comment out read to let ebuild continue
	sed -i -e "s:read:#read:"  config-lang.in || die "seding autoreplies failed"
	#and remove that P var (it doesn't seem to do much except to break a build)
	sed -i -e "s:\$(P)::" Make-lang.in || die "seding Make-lan.in failed"

	cd "${WORKDIR}"
	mv ${P}/p "${S}/gcc/"

	# Build in a separate build tree
	mkdir -p ${BUILDDIR}
}

src_compile() {
	local myconf

	if use nls; then
		myconf="${myconf} --enable-nls --without-included-gettext"
	else
		myconf="${myconf} --disable-nls"
	fi

	# reasonably sane globals (from toolchain)
	myconf="${myconf} \
		--with-system-zlib \
		--disable-checking \
		--disable-werror \
		--disable-libunwind-exceptions"

	use amd64 && myconf="${myconf} --disable-multilib"

	cd ${BUILDDIR}

	einfo "Configuring GCC for GPC build..."
#	addwrite "/dev/zero"
	"${S}"/configure \
		--prefix=${PREFIX} \
		--libdir="${LIBPATH}" \
		--libexecdir="${LIBEXECPATH}" \
		--datadir=${DATAPATH} \
		--mandir=${DATAPATH}/man \
		--infodir=${DATAPATH}/info \
		--program-prefix="" \
		--enable-shared \
		--host=${CHOST} \
		--target=${CTARGET} \
		--enable-languages="c,pascal" \
		--enable-threads=posix \
		--enable-long-long \
		--enable-cstdio=stdio \
		--enable-clocale=generic \
		--enable-__cxa_atexit \
		--enable-version-specific-runtime-libs \
		--with-local-prefix=${PREFIX}/local \
		${myconf} || die "configure failed"

	touch "${S}"/gcc/c-gperf.h

	einfo "Building GPC..."
	# Fix for our libtool-portage.patc
	MAKEOPTS="${MAKEOPTS} -j1" emake LIBPATH="${LIBPATH}" bootstrap || die "make failed"
}

src_install () {
	# Do not allow symlinks in ${PREFIX}/lib/gcc-lib/${CHOST}/${PV}/include as
	# this can break the build.
	for x in cd ${BUILDDIR}/gcc/include/*; do
		if [ -L ${x} ]; then
			rm -f ${x}
		fi
	done

	einfo "Installing GPC..."
	cd ${BUILDDIR}/gcc
	make DESTDIR="${D}" \
		pascal.install-with-gcc || die

	# gcc insists on installing libs in its own place
	mv "${D}${LIBPATH}/gcc/${CTARGET}/${GCCRELEASE}"/* "${D}${LIBPATH}"
	if [ "${ARCH}" == "amd64" ]; then
		# ATTN! this may in fact be related to multilib, rather than amd64
		mv "${D}${LIBPATH}/gcc/${CTARGET}"/lib64/libgcc_s* "${D}${LIBPATH}"
		mv "${D}${LIBPATH}/gcc/${CTARGET}"/lib/libgcc_s* "${D}${LIBPATH}"/32/
	fi
	mv "${D}${LIBEXECPATH}/gcc/${CTARGET}/${GCCRELEASE}"/* "${D}${LIBEXECPATH}"

	rm -rf "${D}${LIBPATH}/gcc"
	rm -rf "${D}${LIBEXECPATH}/gcc"
	rm -rf "${D}${LIBEXECPATH}"/install-tools/

	# Install documentation.
	dodir /usr/share/doc/${PF}
	mv "${D}${PREFIX}"/doc/gpc/* "${D}"/usr/share/doc/${PF}
	prepalldocs

	# final cleanups
	rmdir "${D}${PREFIX}"/include "${D}/${PREFIX}"/share/man/man7
	rm -rf "${D}${PREFIX}"/doc

	# create an env.d entry
	dodir /etc/env.d
	echo "PATH=${LIBEXECPATH}" > "${D}"etc/env.d/56gpc
	echo "ROOTPATH=${LIBEXECPATH}" >> "${D}"etc/env.d/56gpc
}

pkg_postinst ()
{
	einfo
	elog "Please don't forget to source /etc/profile"
	einfo
}
