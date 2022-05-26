# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR=emake  # keep dependencies down

inherit cmake toolchain-funcs

DESCRIPTION="Darwin Xtools matching Xcode Tools ${PN}"
HOMEPAGE="https://github.com/iains/darwin-xtools"
SRC_URI="https://github.com/grobian/darwin-xtools/archive/gentoo-${PVR}.tar.gz -> darwin-xtools-${PVR}.tar.gz"

LICENSE="APSL-2"
SLOT="8"
KEYWORDS="~ppc-macos ~x64-macos"

# xtools uses c++11 features, not available in gcc-apple, hence gcc/clang dep
DEPEND="sys-devel/binutils-config
	|| ( sys-devel/gcc:* sys-devel/clang:* )
	app-arch/xar
	dev-libs/libyaml"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/darwin-xtools-gentoo-${PVR}"

PATCHES=(
	"${FILESDIR}"/${PN}-8.2.1-macos-12.patch
)

src_configure() {
	CTARGET=${CTARGET:-${CHOST}}
	if [[ ${CTARGET} == ${CHOST} ]] ; then
		if [[ ${CATEGORY} == cross-* ]] ; then
			export CTARGET=${CATEGORY#cross-}
		fi
	fi

	LIBPATH=/usr/$(get_libdir)/binutils/${CTARGET}/xtools-${PV}
	DATAPATH=/usr/share/binutils-data/${CTARGET}/xtools-${PV}
	if [[ ${CHOST} != ${CTARGET} ]] ; then
		BINPATH=/usr/${CHOST}/${CTARGET}/binutils-bin/xtools-${PV}
	else
		BINPATH=/usr/${CTARGET}/binutils-bin/xtools-${PV}
	fi

	is-host-64bit() {
		case ${CTARGET} in
			x86_64-*|powerpc64-*|arm64-*)   echo YES   ;;
			*)                              echo NO    ;;
		esac
	}

	local mycmakeargs=(
		-DCMAKE_OSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET}
		-DPACKAGE_VERSION="Gentoo ${PN}-${PVR}"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${BINPATH%/*}" # cmake insists on /bin
		-DCCTOOLS_LD_CLASSIC=NO  # fails to link, and is useless anyway
		-DXTOOLS_AS_USE_CLANG=YES  # default to host as for unsupported targets
		-DXTOOLS_AS_CLANG_USE_HOST=YES  # search for arch/as-host iso clang
		-DXTOOLS_AS_SUBDIR="${EPREFIX}${LIBPATH}/"
		-DXTOOLS_LTO_SUPPORT=NO
		-DXTOOLS_HAS_LIBPRUNETRIE=YES
		-DXTOOLS_TAPI_SUPPORT=ON
		-DXTOOLS_USE_TAPILITE=ON
		-DXTOOLS_HOST_IS_64B=$(is-host-64bit)
		-DXTOOLS_BUGURL="https://bugs.gentoo.org/"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install

	# cmake insists on installing in /bin, so move bins to the place we
	# want them
	mv "${ED}${BINPATH%/*}/bin" "${ED}${BINPATH}" || die

	# move as impls into LIBPATH, such that binutils-config doesn't
	# create links for this
	dodir "${LIBPATH}"
	local as
	for as in "${ED}${BINPATH}"/*/as ; do
		as=${as%/as}
		mv "${as}" "${ED}${LIBPATH}"/ || die
	done

	# provide as-host wrappers, used on "unsupported" platforms: x86,
	# x64, arm, arm64, the main reason here is missing support for
	# instructions, e.g. the as works fine, until newer instruction sets
	# are used like SSE4.1, AVX, etc.
	local arch
	for arch in i386 x86_64 arm arm64 ; do
		mkdir -p "${ED}${LIBPATH}"/${arch}
		as="${ED}${LIBPATH}"/${arch}/as-host
		rm -f "${as}"
		cat <<-EOF > "${as}"
			#!/usr/bin/env bash
			exec /usr/bin/as "\$@"
		EOF
		chmod 755 "${as}"
	done

	doman ld64/doc/man/man*/* cctools/man/*.[135]
	dodir "${DATAPATH}"
	mv "${ED}"/usr/share/man "${ED}/${DATAPATH}/" || die

	cd "${S}"
	insinto /etc/env.d/binutils
	cat <<-EOF > env.d
		TARGET="${CHOST}"
		VER="xtools-${PV}"
		FAKE_TARGETS="${CHOST}"
	EOF
	newins env.d ${CHOST}-xtools-${PV}
}

pkg_postinst() {
	binutils-config ${CHOST}-xtools-${PV}
}
