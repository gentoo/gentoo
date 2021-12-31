# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils flag-o-matic multilib-minimal multilib toolchain-funcs

PV1="$(ver_cut 1)"
PV2="$(ver_cut 2)"
MY_PV="${PV1}_U${PV2}"

DESCRIPTION="High level abstract threading library"
HOMEPAGE="https://www.threadingbuildingblocks.org"
SRC_URI="https://github.com/intel/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug examples"

DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/${PN}-${MY_PV}"

DOCS=( CHANGES README README.md doc/Release_Notes.txt )

src_prepare() {
	default

	find include -name \*.html -delete || die

	# Give it a soname on FreeBSD
	echo 'LIB_LINK_FLAGS += -Wl,-soname=$(BUILDING_LIBRARY)' >>	build/FreeBSD.gcc.inc
	# Set proper versionning on FreeBSD
	sed -i -e '/.DLL =/s/$/.1/' build/FreeBSD.inc || die

	use debug || sed -i -e '/_debug/d' Makefile
}

multilib_src_configure() {
	# pc files are for debian and fedora compatibility
	# some deps use them
	cat <<-EOF > ${PN}.pc.template
		prefix=${EPREFIX}/usr
		libdir=\${prefix}/$(get_libdir)
		includedir=\${prefix}/include
		Name: ${PN}
		Description: ${DESCRIPTION}
		Version: ${PV}
		URL: ${HOMEPAGE}
		Cflags: -I\${includedir}
	EOF
	cp ${PN}.pc.template ${PN}.pc || die
	cat <<-EOF >> ${PN}.pc
		Libs: -L\${libdir} -ltbb
		Libs.private: -lm -lrt
	EOF
	cp ${PN}.pc.template ${PN}malloc.pc || die
	cat <<-EOF >> ${PN}malloc.pc
		Libs: -L\${libdir} -ltbbmalloc
		Libs.private: -lm -lrt
	EOF
	cp ${PN}.pc.template ${PN}malloc_proxy.pc || die
	cat <<-EOF >> ${PN}malloc_proxy.pc
		Libs: -L\${libdir} -ltbbmalloc_proxy
		Libs.private: -lrt
		Requires: tbbmalloc
	EOF
}

local_src_compile() {
	cd "${S}"

	local comp arch

	case ${MULTILIB_ABI_FLAG} in
		abi_x86_64) arch=x86_64 ;;
		abi_x86_32) arch=ia32 ;;
#		abi_ppc_64) arch=ppc64 ;;
#		abi_ppc_32) arch=ppc32 ;;
	esac

	case "$(tc-getCXX)" in
		*clang*) comp="clang" ;;
		*g++*) comp="gcc" ;;
		*ic*c) comp="icc" ;;
		*) die "compiler $(tc-getCXX) not supported by build system" ;;
	esac

	CXX="$(tc-getCXX)" \
	CC="$(tc-getCC)" \
	AS="$(tc-getAS)" \
	arch=${arch} \
	CPLUS_FLAGS="${CXXFLAGS}" \
	emake compiler=${comp} work_dir="${BUILD_DIR}" tbb_root="${S}" $@
}

multilib_src_compile() {
	local_src_compile tbb tbbmalloc
}

multilib_src_test() {
	CXXFLAGS="${CXXFLAGS} -fabi-version=4" \
	local_src_compile -j1 test
}

multilib_src_install() {
	local bt
	local buildtypes
	if use debug ; then
		buildtypes="release debug"
	else
		buildtypes="release"
	fi
	for bt in ${buildtypes}; do
		cd "${BUILD_DIR}_${bt}" || die
		local l
		for l in $(find . -name lib\*$(get_libname \*)); do
			dolib.so ${l}
			local bl=$(basename ${l})
			dosym ${bl} /usr/$(get_libdir)/${bl%%.*}$(get_libname)
		done
	done

	cd "${BUILD_DIR}" || die
	insinto /usr/$(get_libdir)/pkgconfig
	doins *.pc
}

multilib_src_install_all() {
	doheader -r include/*

	einstalldocs

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples/build
		doins build/*.inc
		insinto /usr/share/doc/${PF}/examples
		doins -r examples
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
}
