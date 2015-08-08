# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit eutils toolchain flag-o-matic autotools prefix

GCC_VERS=${PV/_p*/}
APPLE_VERS="${PV/*_p/}.3"
DESCRIPTION="Apple branch of the GNU Compiler Collection, Developer Tools 4.0"
HOMEPAGE="http://gcc.gnu.org"
SRC_URI="http://www.opensource.apple.com/darwinsource/tarballs/other/gcc-${APPLE_VERS}.tar.gz
		http://www.opensource.apple.com/darwinsource/tarballs/other/libstdcxx-16.tar.gz
		http://www.opensource.apple.com/darwinsource/tarballs/other/libstdcxx-39.tar.gz
		fortran? ( mirror://gnu/gcc/gcc-4.2.4/gcc-fortran-4.2.4.tar.bz2 )"
LICENSE="GPL-2 GPL-3"

case ${CHOST} in
	*-darwin1*|i?86-*-darwin9|powerpc-*-darwin9)
		LIBSTDCXX_APPLE_VERSION=39
	;;
	*)
		# pre Leopard has no dtrace, which is required by 37.11 and above
		# Leopard only has 32-bits version of dtrace
		LIBSTDCXX_APPLE_VERSION=16
	;;
esac

if is_crosscompile; then
	SLOT="${CTARGET}-42"
else
	SLOT="42"
fi

KEYWORDS="~ppc-macos ~x64-macos ~x86-macos"

IUSE="fortran nls +openmp objc objc++ +cxx"

RDEPEND=">=sys-libs/zlib-1.1.4
	>=sys-libs/ncurses-5.2-r2
	nls? ( sys-devel/gettext )
	>=sys-devel/gcc-config-1.8-r1
	sys-libs/csu
	!<sys-apps/portage-2.2.14
	fortran? (
		>=dev-libs/gmp-4.2.1
		>=dev-libs/mpfr-2.2.0_p10
	)"
DEPEND="${RDEPEND}
	>=sys-apps/texinfo-4.2-r4
	>=sys-devel/bison-1.875
	${CATEGORY}/binutils-apple
	>=dev-libs/mpfr-2.2.0_p10"

S=${WORKDIR}/gcc-${APPLE_VERS}

# TPREFIX is the prefix of the CTARGET installation
export TPREFIX=${TPREFIX:-${EPREFIX}}

LIBPATH=${EPREFIX}/usr/lib/gcc/${CTARGET}/${GCC_VERS}
if is_crosscompile ; then
	BINPATH=${EPREFIX}/usr/${CHOST}/${CTARGET}/gcc-bin/${GCC_VERS}
else
	BINPATH=${EPREFIX}/usr/${CTARGET}/gcc-bin/${GCC_VERS}
fi
STDCXX_INCDIR=${LIBPATH}/include/g++-v${GCC_VERS/\.*/}

do_bootstrap() {
	is_crosscompile && return 1
	[[ ${CHOST} != ${CBUILD} ]] && return 1
	[[ ${EPREFIX} != ${TPREFIX} ]] && return 1
	return 0
}

src_unpack() {
	# override toolchain.eclass func
	unpack ${A}
}

src_prepare() {
	# Support for fortran
	if use fortran ; then
		mv "${WORKDIR}"/gcc-4.2.4/gcc/fortran gcc/ || die
		mv "${WORKDIR}"/gcc-4.2.4/libgfortran . || die
		# from: substracted from http://r.research.att.com/tools/
		epatch "${FILESDIR}"/${PN}-4.2.1_p5646-gfortran.patch
	fi

	# move in libstdc++
	mv "${WORKDIR}"/libstdcxx-${LIBSTDCXX_APPLE_VERSION}/libstdcxx/libstdc++-v3 .
	if [[ ${LIBSTDCXX_APPLE_VERSION} == 16 ]] ; then
		epatch "${FILESDIR}"/libstdc++-${LIBSTDCXX_APPLE_VERSION}.patch # does it apply on 37?
		sed -i -e 's/__block\([^_]\)/__blk\1/g' \
			libstdc++-v3/include/ext/mt_allocator.h \
			libstdc++-v3/src/mt_allocator.cc || die "conflict fix failed"
	fi

	# we use our libtool
	sed -i -e "s:/usr/bin/libtool:${EPREFIX}/usr/bin/${CTARGET}-libtool:" \
		gcc/config/darwin.h || die "sed gcc/config/darwin.h failed"
	# add prefixed Frameworks to default search paths (may want to change this
	# in a cross-compile)
	sed -i -e "/\"\/System\/Library\/Frameworks\"\,/i\ \   \"${EPREFIX}/Frameworks\"\, " \
		gcc/config/darwin-c.c || die "sed  gcc/config/darwin-c.c failed"

	# Workaround deprecated "+Nc" syntax for GNU tail(1)
	sed -i -e "s:tail +16c:tail -c +16:g" \
		gcc/Makefile.in || die "sed gcc/Makefile.in failed."

	# default to AltiVec on PPC, like for older releases
	epatch "${FILESDIR}"/${PN}-4.0.1_p5465-default-altivec.patch

	# support -arch XXX if XXX is actually what the toolchain targets because
	# some upstreams insist on setting it
	epatch "${FILESDIR}"/${PN}-4.2.1-arch-option.patch

	# dsymutil stuff breaks on 10.4/x86, revert it
	[[ ${CHOST} == *86*-apple-darwin8 ]] && \
		epatch "${FILESDIR}"/${PN}-${GCC_VERS}-dsymutil.patch

	# support OS X 10.10
	epatch "${FILESDIR}"/${P}-darwin14.patch

	# bootstrapping might fail with host provided gcc on 10.4/x86
	if ! is_crosscompile && ! echo "int main(){return 0;}" | gcc -o "${T}"/foo \
		-mdynamic-no-pic -x c - >/dev/null 2>&1;
	then
		einfo "-mdynamic-no-pic doesn't work - disabling..."
		echo "BOOT_CFLAGS=-g -O2" > config/mh-x86-darwin
		XD=gcc/config/i386/x-darwin
		awk 'BEGIN{x=1}{if ($0 ~ "use -mdynamic-no-pic to build x86")
		{x=1-x} else if (x) print}' $XD > t && mv t $XD \
			|| die "Failed to rewrite $XD"
	fi

	epatch "${FILESDIR}"/${P}-perl-5.18.patch

	epatch "${FILESDIR}"/${PN}-4.2.1-prefix-search-dirs-r1.patch
	eprefixify "${S}"/gcc/gcc.c
	sed -i -e "s|@GENTOO_PORTAGE_TPREFIX@|${TPREFIX}|g" "${S}"/gcc/config/darwin.h

	if use !bootstrap ; then
		# this only occurs with up-to-date tools from the Prefix, and actually
		# breaks the bootstrap since the autoconf needs a very recent automake
		epatch "${FILESDIR}"/${PN}-${GCC_VERS}-texinfo.patch
		epatch "${FILESDIR}"/${PN}-${GCC_VERS}-autoconf-m4-precious.patch
		cd "${S}"/gcc && eautoconf
		cd "${S}"/libgomp && eautoconf
	fi

	local BRANDING_GCC_PKGVERSION="$(sed -n -e '/^#define VERSUFFIX/s/^[^"]*"\([^"]\+\)".*$/\1/p' "${S}"/gcc/version.c)"
	BRANDING_GCC_PKGVERSION=${BRANDING_GCC_PKGVERSION/(/(Gentoo ${PVR}, }
	einfo "patching gcc version: ${GCC_VERS}${BRANDING_GCC_PKGVERSION}"

	sed -i -e "s~VERSUFFIX \"[^\"]*~VERSUFFIX \"${BRANDING_GCC_PKGVERSION}~" \
		"${S}"/gcc/version.c || die "failed to update VERSUFFIX with Gentoo branding"
	sed -i -e 's~developer\.apple\.com\/bugreporter~bugs\.gentoo\.org\/~' \
		"${S}"/gcc/version.c || die "Failed to change the bug URL"

	# fix the install_names of all shared libraries for the target
	# NOTE: do this after any automake-ing!
	# Yes, patching generated files is bad. Talk to me once you've found a way to do this inside automake.
	sed -i -e "s|-install_name \$(slibdir)|-install_name ${TPREFIX}/usr/${CTARGET}/lib/gcc|" "${S}"/gcc/config/t-slibgcc-darwin
	sed -i -e "s|-rpath \$(toolexeclibdir)|-rpath ${TPREFIX}/usr/${CTARGET}/lib/gcc|" \
		"${S}"/{libgomp,libstdc++-v3/src,libstdc++-v3/libsupc++}/Makefile.in
}

src_configure() {
	local langs="c"
	use cxx && langs="${langs},c++"
	use objc && langs="${langs},objc"
	use objc++ && langs="${langs/,objc/},objc,obj-c++" # need objc with objc++
	use fortran && langs="${langs},fortran"

	local myconf="${myconf} \
		--prefix=${EPREFIX}/usr \
		--bindir=${BINPATH} \
		--includedir=${LIBPATH}/include \
		--datadir=${EPREFIX}/usr/share/gcc-data/${CTARGET}/${GCC_VERS} \
		--mandir=${EPREFIX}/usr/share/gcc-data/${CTARGET}/${GCC_VERS}/man \
		--infodir=${EPREFIX}/usr/share/gcc-data/${CTARGET}/${GCC_VERS}/info \
		--with-gxx-include-dir=${STDCXX_INCDIR} \
		--host=${CHOST} \
		--enable-version-specific-runtime-libs"

	if is_crosscompile ; then
		# Straight from the GCC install doc:
		# "GCC has code to correctly determine the correct value for target
		# for nearly all native systems. Therefore, we highly recommend you
		# not provide a configure target when configuring a native compiler."
		myconf="${myconf} --target=${CTARGET}"

		# Tell compiler where to find what it needs
		myconf="${myconf} --with-sysroot=${EPREFIX}/usr/${CTARGET}"

		# Set this to something sane for both native and target
		CFLAGS="-O2 -pipe"

		local VAR="CFLAGS_"${CTARGET//-/_}
		CXXFLAGS=${!VAR}
	fi
	[[ -n ${CBUILD} ]] && myconf="${myconf} --build=${CBUILD}"

	# Native Language Support
	if use nls ; then
		myconf="${myconf} --enable-nls --without-included-gettext"
	else
		myconf="${myconf} --disable-nls"
	fi

	# reasonably sane globals (hopefully)
	myconf="${myconf} \
		--with-system-zlib \
		--disable-checking \
		--disable-werror"

	# ???
	myconf="${myconf} --enable-shared --enable-threads=posix"

	# make clear we're in an offset
	use prefix && myconf="${myconf} --with-local-prefix=${TPREFIX}/usr"

	do_bootstrap || myconf="${myconf} --disable-bootstrap"

	# we don't use a GNU linker, so tell GCC where to find the linker stuff we
	# want it to use
	myconf="${myconf} \
		--with-as=${EPREFIX}/usr/bin/${CTARGET}-as \
		--with-ld=${EPREFIX}/usr/bin/${CTARGET}-ld"

	# make sure we never do multilib stuff, for that we need a different Prefix
	[[ -z ${I_KNOW_WHAT_IM_DOING_I_WANT_APPLE_MULTILIB} ]] \
		&& myconf="${myconf} --disable-multilib"

	myconf="${myconf} --enable-languages=${langs} $(use_enable openmp libgomp)"

	# The produced libgcc_s.dylib is faulty if using a bit too much
	# optimisation.  Nail it down to something sane
	CFLAGS="-O2 -pipe"
	CXXFLAGS=${CFLAGS}

	# http://gcc.gnu.org/ml/gcc-patches/2006-11/msg00765.html
	# (won't hurt if already 64-bits, but is essential when coming from a
	# multilib compiler -- the default)
	[[ ${CTARGET} == powerpc64-* || ${CTARGET} == x86_64-* ]] && \
		export CC="${CC:-$(tc-getCC)} -m64"

	mkdir -p "${WORKDIR}"/build
	cd "${WORKDIR}"/build
	einfo "Configuring GCC with: ${myconf//--/\n\t--}"
	"${S}"/configure ${myconf} || die "conf failed"
}

src_compile() {
	cd "${WORKDIR}"/build || die
	if ! do_bootstrap; then
		GCC_MAKE_TARGET=${GCC_MAKE_TARGET-all}
	else
		GCC_MAKE_TARGET=${GCC_MAKE_TARGET-bootstrap}
	fi
	emake ${GCC_MAKE_TARGET} || die "emake failed"
}

src_install() {
	cd "${WORKDIR}"/build
	# -jX doesn't work
	emake -j1 DESTDIR="${D}" install || die

	# Punt some tools which are really only useful while building gcc
	find "${ED}" -name install-tools -prune -type d -exec rm -rf "{}" \;
	# This one comes with binutils
	find "${ED}" -name libiberty.a -exec rm -f "{}" \;

	# Basic sanity check
	if ! is_crosscompile ; then
		local EXEEXT
		eval $(grep ^EXEEXT= "${WORKDIR}"/build/gcc/config.log)
		[[ -r ${D}${BINPATH}/gcc${EXEEXT} ]] || die "gcc not found in ${ED}"
	fi

	# create gcc-config entry
	dodir /etc/env.d/gcc
	local gcc_envd_base="/etc/env.d/gcc/${CHOST}-${GCC_VERS}"

	gcc_envd_file="${ED}${gcc_envd_base}"

	# phase PATH/ROOTPATH out ...
	echo "PATH=\"${BINPATH}\"" > ${gcc_envd_file}
	echo "ROOTPATH=\"${BINPATH}\"" >> ${gcc_envd_file}
	echo "GCC_PATH=\"${BINPATH}\"" >> ${gcc_envd_file}

	# we don't do multilib
	LDPATH="${LIBPATH}"
	echo "LDPATH=\"${LDPATH}\"" >> ${gcc_envd_file}
	echo "MANPATH=\"${EPREFIX}/usr/share/gcc-data/${CHOST}/${GCC_VERS}/man\"" >> ${gcc_envd_file}
	echo "INFOPATH=\"${EPREFIX}/usr/share/gcc-data/${CHOST}/${GCC_VERS}/info\"" >> ${gcc_envd_file}
	echo "STDCXX_INCDIR=\"g++-v${GCC_VERS/\.*/}\"" >> ${gcc_envd_file}
	is_crosscompile && echo "CTARGET=${CTARGET}" >> ${gcc_envd_file}

	# Move <cxxabi.h> to compiler-specific directories
	[[ -f ${D}${STDCXX_INCDIR}/cxxabi.h ]] && \
		mv -f "${D}"${STDCXX_INCDIR}/cxxabi.h "${D}"${LIBPATH}/include/

	# These should be symlinks
	dodir /usr/bin
	cd "${D}"${BINPATH}
	for x in cpp gcc g++ c++ g77 gcj gcjh gfortran ; do
		# For some reason, g77 gets made instead of ${CTARGET}-g77...
		# this should take care of that
		[[ -f ${x} ]] && mv ${x} ${CTARGET}-${x}

		if [[ -f ${CTARGET}-${x} ]] && ! is_crosscompile ; then
			ln -sf ${CTARGET}-${x} ${x}

			# Create version-ed symlinks
			dosym ${BINPATH#${EPREFIX}}/${CTARGET}-${x} \
				/usr/bin/${CTARGET}-${x}-${GCC_VERS}
			dosym ${BINPATH#${EPREFIX}}/${CTARGET}-${x} \
				/usr/bin/${x}-${GCC_VERS}
		fi

		if [[ -f ${CTARGET}-${x}-${GCC_VERS} ]] ; then
			rm -f ${CTARGET}-${x}-${GCC_VERS}
			ln -sf ${CTARGET}-${x} ${CTARGET}-${x}-${GCC_VERS}
		fi
	done

	# I do not know if this will break gcj stuff, so I'll only do it for
	#	objc for now; basically "ffi.h" is the correct file to include,
	#	but it gets installed in .../GCCVER/include and yet it does
	#	"#include <ffitarget.h>" which (correctly, as it's an "extra" file)
	#	is installed in .../GCCVER/include/libffi; the following fixes
	#	ffi.'s include of ffitarget.h - Armando Di Cianno <fafhrd@gentoo.org>
	if [[ -d ${D}${LIBPATH}/include/libffi ]] ; then
		mv -i "${D}"${LIBPATH}/include/libffi/* "${D}"${LIBPATH}/include || die
		rm -r "${D}"${LIBPATH}/include/libffi || die
	fi

	# Now do the fun stripping stuff
	env RESTRICT="" CHOST=${CHOST} prepstrip "${D}${BINPATH}"
	env RESTRICT="" CHOST=${CTARGET} prepstrip "${D}${LIBPATH}"
	# gcc used to install helper binaries in lib/ but then moved to libexec/
	[[ -d ${ED}/usr/libexec/gcc ]] && \
		env RESTRICT="" CHOST=${CHOST} prepstrip "${ED}/usr/libexec/gcc/${CTARGET}/${GCC_VERS}"

	# prune empty dirs left behind
	find "${ED}" -type d | xargs rmdir >& /dev/null

	# The gcc runtime libs have an invalid install_name; this is correct,
	# as they are copied to the right location by gcc-config later.
	QA_IGNORE_INSTALL_NAME_FILES=()
	pushd "${ED}/usr/lib/gcc/${CTARGET}/${GCC_VERS}" > /dev/null
	for file in *.dylib; do
		QA_IGNORE_INSTALL_NAME_FILES+=( "${file}" )
	done
	popd > /dev/null
}

pkg_postinst() {
	# beware this also switches when it's on another branch version of GCC
	gcc-config ${CTARGET}-${GCC_VERS}
}

pkg_postrm() {
	# clean up the cruft left behind by cross-compilers
	if is_crosscompile ; then
		if [[ -z $(ls "${EROOT}"/etc/env.d/gcc/${CTARGET}* 2>/dev/null) ]] ; then
			rm -f "${EROOT}"/etc/env.d/gcc/config-${CTARGET}
			rm -f "${EROOT}"/etc/env.d/??gcc-${CTARGET}
			rm -f "${EROOT}"/usr/bin/${CTARGET}-{gcc,{g,c}++}{,32,64}
		fi
		return 0
	fi
}
