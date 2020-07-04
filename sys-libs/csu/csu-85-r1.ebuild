# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Darwin Csu (crt1.o) - Mac OS X 10.10 version"
HOMEPAGE="http://www.opensource.apple.com/"
SRC_URI="http://www.opensource.apple.com/tarballs/Csu/Csu-${PV}.tar.gz"

LICENSE="APSL-2"

SLOT="0"
KEYWORDS="~ppc-macos ~x64-macos ~x86-macos"
IUSE=""
S=${WORKDIR}/Csu-${PV}

# for now it seems FSF GCC can't compile this thing, so we need
# gcc-apple or clang (which is also sort of "-apple")
DEPEND="|| (
		sys-devel/clang
		=sys-devel/gcc-apple-4.2.1*
	)"

src_prepare() {
	# since we don't have crt0, we can't build it either
	sed -i \
		-e 's:$(SYMROOT)/crt0.o::' \
		-e '/LOCLIBDIR)\/crt0.o/d' \
		-e '/^CC = /d' \
		-e "/ARCH_CFLAGS =/s|=|= ${CFLAGS}|" \
		Makefile || die

	# only require Availability.h for arm, bugs #538602, #539964
	eapply "${FILESDIR}"/${P}-arm-availability.patch

	if [[ ${CHOST} == powerpc* ]] ; then
		# *must not* be compiled with -Os on PPC because that
		# will optimize out
		# _pointer_to__darwin_gcc3_preregister_frame_info which
		# causes linker errors for large programs because the
		# jump to ___darwin_gcc3_preregister_frame_info gets to
		# be more than 16MB away
		sed -i -e "s, -Os , -O ,g" Makefile || die
	fi

	eapply_user
}

src_compile() {
	# FSF GCC-7.3.0 most notably complains about private_externs, but it
	# also has issues with the assembly, so use gcc-apple, if it is
	# installed.  Normally, (non-ppc) users will have clang installed,
	# so this isn't used, should they have gcc-apple installed, then
	# this wouldn't hurt either.
	type -P gcc-4.2.1 > /dev/null && export CC=gcc-4.2.1
	emake USRLIBDIR="${EPREFIX}"/lib
}

src_install() {
	emake -j1 \
		USRLIBDIR="${EPREFIX}"/lib \
		LOCLIBDIR="${EPREFIX}"/lib \
		DSTROOT="${D}" \
		install
}
