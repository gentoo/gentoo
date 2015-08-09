# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

BASE_BINUTILS="2.16.1"
GCC_VER="4.1.2"
GCC_SNAPSHOT="20060728"
BIN_VER=${BASE_BINUTILS:0:4}

DESCRIPTION="Cross compiler for Texas Instruments TI-89, TI-92(+) and V200 calculators"
HOMEPAGE="http://tigcc.ticalc.org/"

#original source can be found at:
#SRC_URI="http://tigcc.ticalc.org/linux/tigcc_src.tar.bz2"
#but in fact this file changes as soon as there comes a new beta

#when it hits portage of course it should be mirrored on a gentoo mirror:
#SRC_URI="mirror://gentoo/${PF}.tar.bz2"

SRC_URI="mirror://gentoo/${P}.tar.bz2
	ftp://gcc.gnu.org/pub/gcc/snapshots/4.1-${GCC_SNAPSHOT}/gcc-4.1-${GCC_SNAPSHOT}.tar.bz2
	mirror://kernel/linux/devel/binutils/binutils-${BASE_BINUTILS}.tar.bz2
	http://members.chello.at/gerhard.kofler/kevin/ti89prog/libfargo.zip
	http://members.chello.at/gerhard.kofler/kevin/ti89prog/flashosa.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc"
RESTRICT="strip"

RDEPEND=">=sys-devel/binutils-2.14.90.0.6-r1"
DEPEND="${RDEPEND}
	app-arch/unzip
	>=sys-devel/bison-1.875"

S=${WORKDIR}

src_unpack() {
	unpack ${A}

	# start by patching and cleaning out binutils and gcc directories.
	cd "${WORKDIR}"/binutils-${BASE_BINUTILS}
	epatch "${S}"/sources/gcc/gas-${BIN_VER}-tigcc-*.diff

	rm -f .brik
	rm -f md5.sum
	rm -f -r INSTALL
	rm -f -r maintainer-scripts
	rm -f -r binutils
	rm -f -r cpu
	rm -f -r etc
	rm -f -r gas/doc
	rm -f -r gas/po
	rm -f -r gprof
	rm -f -r include/nlm
	rm -f -r include/regs
	rm -f -r ld
	rm -f -r texinfo

	cd "${WORKDIR}"/gcc-4.1-${GCC_SNAPSHOT}
	epatch "${S}"/sources/gcc/gcc-4.1-tigcc-patch.diff

	rm -f .brik
	rm -f md5.sum
	rm -f -r INSTALL
	rm -f -r fixincludes
	rm -f -r gcc/ginclude
	rm -f -r gcc/po
	rm -f -r gcc/doc
	rm -f -r gcc/treelang
	rm -f -r libcpp/po
	rm -f -r maintainer-scripts
	rm -f -r etc
	rm -f -r gprof
	rm -f -r include/nlm
	rm -f -r include/regs
	rm -f -r texinfo

	# create build directories for binutils and gcc
	mkdir -p "${WORKDIR}"/build/binutils
	mkdir "${WORKDIR}"/build/gcc

	# Workaround for non-existing directories
	sed -ie '/SUBDIRS =/d' "${WORKDIR}"/binutils-${BASE_BINUTILS}/gas/Makefile.in
}

src_compile() {
	# build binutils
	cd "${WORKDIR}"/build/binutils
	CFLAGS="${CFLAGS}" "${WORKDIR}"/binutils-${BASE_BINUTILS}/configure \
		--disable-serial-configure --target=m68k-coff --disable-shared \
		--enable-static --disable-multilib --disable-nls \
		|| die
	emake || die "gas"

	# build gcc
	cd "${WORKDIR}"/build/gcc
	CFLAGS="${CFLAGS}" "${WORKDIR}"/gcc-4.1-${GCC_SNAPSHOT}/configure --target=m68k-coff \
				--with-gnu-as --with-as="${WORKDIR}"/build/binutils/gas/as-new --with-gnu-ld \
				--disable-nls --disable-multilib --disable-shared --enable-static \
				--disable-threads --enable-languages=c --disable-win32-registry \
				--disable-checking --disable-werror --disable-pch --disable-mudflap \
		|| die

	# GCC compilations _is intended_ to fail on a certain point,
	# don't worry about that.
	emake -j1

	# Check if gcc has been built, die otherwise
	( [ -e "${WORKDIR}"/build/gcc/gcc/xgcc ] && [ -e "${WORKDIR}"/build/gcc/gcc/cc1  ] ) || die "gcc"

	# build a68k assembler
	cd "${S}"/sources/a68k
	emake -e || die "a68k"

	# build ld-tigcc linker
	cd "${S}"/sources/ld-tigcc
	emake -e || die "ld-tigcc"

	# build tigcc front-end
	cd "${S}"/sources/tigcc/src
	emake -e || die "tigcc"

	# build tprbuilder (TIGCC project builder)
	cd "${S}"/sources/tprbuilder/src
	emake -e || die "tprbuilder"

	# build patcher (object file patcher)
	cd "${S}"/sources/patcher/src
	emake -e || die "patcher"

}

src_install() {
	# install documentation
	dodir /usr/bin

	if use doc ; then
		# patch the script that launches the documentation
		# browser to point to the correct location
		sed "s:\${TIGCC}/doc:/usr/share/doc/${P}:g" \
			"${S}"/tigcclib/doc/converter/tigccdoc \
		> "${S}"/tigcclib/doc/converter/tigccdoc.new

		cd "${S}"/tigcclib/doc/converter
		newbin tigccdoc.new tigccdoc
		cd "${S}"/tigcclib/doc
		dohtml -r html/*
		cp html/qt-assistant.adp "${D}"/usr/share/doc/${PF}/html

		cd "${S}"/sources/a68k
	fi

	dodir /usr/share/doc/${PF}
	cd "${S}"
	dodoc AUTHORS BUGS CHANGELOG DIRECTORIES HOWTO \
		INSTALL README README.linux README.osX

	cd "${S}"/sources/tigcc
	docinto tigcc
	dodoc AUTHORS ChangeLog README

	cd "${S}"/sources/tprbuilder
	docinto tprbuilder
	dodoc AUTHORS ChangeLog README

	cd "${S}"/sources/patcher
	docinto patcher
	dodoc AUTHORS ChangeLog README

	exeinto /usr/ti-linux-gnu/tigcc-bin/${GCC_VER}
	# install gcc
	cd "${WORKDIR}"/build/gcc
	doexe gcc/cc1
	newexe gcc/xgcc gcc
	dosym /usr/ti-linux-gnu/tigcc-bin/${GCC_VER}/gcc \
		/usr/ti-linux-gnu/tigcc-bin/${GCC_VER}/ti-linux-gnu-gcc

	# install gas
	# exeinto /usr/ti-linux-gnu/bin <-- a symlink will be
	# created so that gas resides in /usr/ti-linux-gnu/bin too
	cd "${WORKDIR}"/build/binutils
	newexe gas/as-new as

	# install a68k
	cd "${S}"/sources/a68k
	newexe A68k a68k

	# install ld-tigcc
	cd "${S}"/sources/ld-tigcc
	doexe ld-tigcc
	doexe ar-tigcc

	# install tigcc
	cd "${S}"/sources/tigcc/src
	doexe tigcc
	dosym /usr/ti-linux-gnu/tigcc-bin/${GCC_VER}/tigcc \
		/usr/ti-linux-gnu/tigcc-bin/${GCC_VER}/ti-linux-gnu-tigcc

	# install tprbuilder
	cd "${S}"/sources/tprbuilder/src
	doexe tprbuilder

	# install patcher
	cd "${S}"/sources/patcher/src
	doexe patcher

	# install header files
	dodir /usr/include/tigcc
	cp -R "${S}"/tigcclib/include/* "${D}"/usr/include/tigcc
	dosym /usr/include/tigcc/asm/os.h /usr/include/tigcc/asm/OS.h

	insinto /usr/lib/gcc-lib/ti-linux-gnu/${GCC_VER}
	# install library
	cd "${S}"/tigcclib
	doins lib/*
	cd "${WORKDIR}"
	doins flashos.a
	doins fargo.a

	dodir /usr/share/tigcc
	# copy example programs
	# cp -r "${S}"/examples ${D}/usr/share/tigcc

	# create TIGCC env variable
	# TIGCC="/usr/ti-linux-gnu/tigcc-bin/${GCC_VER}"
	# CC="tigcc"
	cat <<-EOF > 99tigcc
	TIGCC="/usr/ti-linux-gnu"
	PATH="/usr/ti-linux-gnu/tigcc-bin/${GCC_VER}:/usr/ti-linux-gnu/bin"
	ROOTPATH="/usr/ti-linux-gnu/tigcc-bin/${GCC_VER}:/usr/ti-linux-gnu/bin"
	LDPATH="/usr/lib/gcc-lib/ti-linux-gnu/${GCC_VER}"
	EOF
	doenvd 99tigcc

	# a cross-compiling gcc with hard-coded names has been built.
	# therefore, we must place some symlinks.
	dosym /usr/include/tigcc /usr/ti-linux-gnu/include
	dosym /usr/lib/gcc-lib/ti-linux-gnu/${GCC_VER} /usr/ti-linux-gnu/lib
	dosym /usr/share/doc/${PF} /usr/ti-linux-gnu/doc
	dosym /usr/ti-linux-gnu/tigcc-bin/${GCC_VER} /usr/ti-linux-gnu/bin
}
