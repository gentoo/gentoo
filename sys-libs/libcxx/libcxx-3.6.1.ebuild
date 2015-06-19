# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libcxx/libcxx-3.6.1.ebuild,v 1.1 2015/05/29 09:49:41 aballier Exp $

EAPI=5

ESVN_REPO_URI="http://llvm.org/svn/llvm-project/libcxx/trunk"

[ "${PV%9999}" != "${PV}" ] && SCM="subversion" || SCM=""

inherit ${SCM} flag-o-matic toolchain-funcs multilib multilib-minimal

DESCRIPTION="New implementation of the C++ standard library, targeting C++11"
HOMEPAGE="http://libcxx.llvm.org/"
if [ "${PV%9999}" = "${PV}" ] ; then
	SRC_URI="http://llvm.org/releases/${PV}/${P}.src.tar.xz"
	S="${WORKDIR}/${P}.src"
else
	SRC_URI=""
fi

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
if [ "${PV%9999}" = "${PV}" ] ; then
	KEYWORDS="~amd64 ~mips ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
else
	KEYWORDS=""
fi
IUSE="elibc_glibc +libcxxrt +static-libs test"

RDEPEND="libcxxrt? ( >=sys-libs/libcxxrt-0.0_p20130725[static-libs?,${MULTILIB_USEDEP}] )
	!libcxxrt? ( >=sys-devel/gcc-4.7:=[cxx] )"
DEPEND="${RDEPEND}
	test? ( sys-devel/clang )
	app-arch/xz-utils"

DOCS=( CREDITS.TXT )

pkg_setup() {
	if ! use libcxxrt ; then
		ewarn "You have disabled USE=libcxxrt. This will build ${PN} against"
		ewarn "libsupc++. Please note that this is not well supported."
		ewarn "In particular, static linking will not work."
	fi
	if [[ $(gcc-version) < 4.7 ]] && [[ $(tc-getCXX) != *clang++* ]] ; then
		eerror "${PN} needs to be built with clang++ or gcc-4.7 or later."
		eerror "Please use gcc-config to switch to gcc-4.7 or later version."
		die
	fi
}

src_prepare() {
	cp -f "${FILESDIR}/Makefile" lib/ || die
	multilib_copy_sources
}

src_configure() {
	export LIBS="-lpthread -lrt -lc -lgcc_s"
	if use libcxxrt ; then
		append-cppflags -DLIBCXXRT "-I${EPREFIX}/usr/include/libcxxrt/"
		LIBS="-lcxxrt ${LIBS}"
		cp "${EPREFIX}/usr/include/libcxxrt/"*.h "${S}/include"
	else
		# Very hackish, see $HOMEPAGE
		# If someone has a clever idea, please share it!
		local includes="$(echo | ${CHOST}-g++ -Wp,-v -x c++ - -fsyntax-only 2>&1 | grep -C 2 '#include.*<...>' | tail -n 2 | sed -e 's/^ /-I/' | tr '\n' ' ')"
		local libcxx_gcc_dirs="$(echo | ${CHOST}-g++ -Wp,-v -x c++ - -fsyntax-only 2>&1 | grep -C 2 '#include.*<...>' | tail -n 2 | tr '\n' ' ')"
		append-cppflags -D__GLIBCXX__ ${includes}
		LIBS="-lsupc++ ${LIBS}"
		local libsupcxx_includes="cxxabi.h bits/c++config.h bits/os_defines.h bits/cpu_defines.h bits/cxxabi_tweaks.h bits/cxxabi_forced.h"
		for i in ${libsupcxx_includes} ; do
			local found=""
			[ -d "${S}/include/$(dirname ${i})/" ] || mkdir -p "${S}/include/$(dirname ${i})"
			for j in ${libcxx_gcc_dirs} ; do
				if [ -f "${j}/${i}" ] ; then
					cp "${j}/${i}" "${S}/include/$(dirname ${i})/" || die
					found=yes
				fi
			done
			[ -n "${found}" ] || die "Header not found: ${i}"
		done
	fi

	tc-export AR CC CXX

	append-ldflags "-Wl,-z,defs" # make sure we are not underlinked
}

multilib_src_compile() {
	cd "${BUILD_DIR}/lib" || die
	emake shared
	use static-libs && emake static
}

# Tests fail for now, if anybody is able to fix them, help is very welcome.
multilib_src_test() {
	cd "${BUILD_DIR}/test"
	LD_LIBRARY_PATH="${BUILD_DIR}/lib:${LD_LIBRARY_PATH}" \
		CC="clang++ $(get_abi_CFLAGS) ${CXXFLAGS}" \
		HEADER_INCLUDE="-I${BUILD_DIR}/include" \
		SOURCE_LIB="-L${BUILD_DIR}/lib" \
		LIBS="-lm $(usex libcxxrt -lcxxrt "")" \
		./testit || die
	# TODO: fix link against libsupc++
}

# Usage: deps
gen_ldscript() {
	local output_format
	output_format=$($(tc-getCC) ${CFLAGS} ${LDFLAGS} -Wl,--verbose 2>&1 | sed -n 's/^OUTPUT_FORMAT("\([^"]*\)",.*/\1/p')
	[[ -n ${output_format} ]] && output_format="OUTPUT_FORMAT ( ${output_format} )"

	cat <<-END_LDSCRIPT
/* GNU ld script
   Include missing dependencies
*/
${output_format}
GROUP ( $@ )
END_LDSCRIPT
}

gen_static_ldscript() {
	if use libcxxrt ; then
		# Move it first.
		mv "${ED}/usr/$(get_libdir)/libc++.a" "${ED}/usr/$(get_libdir)/libc++_static.a" || die

		# Generate libc++.a ldscript for inclusion of its dependencies so that
		# clang++ -stdlib=libc++ -static works out of the box.
		local deps="${EPREFIX}/usr/$(get_libdir)/libc++_static.a ${EPREFIX}/usr/$(get_libdir)/libcxxrt.a"
		# On Linux/glibc it does not link without libpthread or libdl. It is
		# fine on FreeBSD.
		use elibc_glibc && deps="${deps} ${EPREFIX}/usr/$(get_libdir)/libpthread.a ${EPREFIX}/usr/$(get_libdir)/libdl.a"

		gen_ldscript "${deps}" > "${ED}/usr/$(get_libdir)/libc++.a"
	fi
	# TODO: Generate a libc++.a ldscript when building against libsupc++
}

gen_shared_ldscript() {
	if use libcxxrt ; then
		mv "${ED}/usr/$(get_libdir)/libc++.so" "${ED}/usr/$(get_libdir)/libc++_shared.so" || die
		local deps="${EPREFIX}/usr/$(get_libdir)/libc++_shared.so ${EPREFIX}/usr/$(get_libdir)/libcxxrt.so"
		gen_ldscript "${deps}" > "${ED}/usr/$(get_libdir)/libc++.so"
	fi
	# TODO: Generate the linker script for other confiurations too.
}

multilib_src_install() {
	cd "${BUILD_DIR}/lib"
	if use static-libs ; then
		dolib.a libc++.a
		gen_static_ldscript
	fi
	dolib.so libc++.so*
	gen_shared_ldscript
}

multilib_src_install_all() {
	einstalldocs
	insinto /usr/include/c++/v1
	doins -r include/*
}

pkg_postinst() {
	elog "This package (${PN}) is mainly intended as a replacement for the C++"
	elog "standard library when using clang."
	elog "To use it, instead of libstdc++, use:"
	elog "    clang++ -stdlib=libc++"
	elog "to compile your C++ programs."
}
