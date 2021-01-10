# Copyright 2020-2021 Gentoo Authors
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
IUSE="tapi"

DEPEND="sys-devel/binutils-config
	app-arch/xar
	tapi? ( sys-libs/tapi )"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/darwin-xtools-gentoo-${PVR}"

src_prepare() {
	cmake_src_prepare

	# make prunetrie a static archive, because the dynamic libs aren't
	# installed, for there really are no consumers
	# fixed for next release
	sed -i -e '/add_library/s/prunetrie/& STATIC/' \
		ld64/src/CMakeLists.txt || die
}

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
			x86_64-*|powerpc64*)   echo YES   ;;
			*)                     echo NO    ;;
		esac
	}

	local mycmakeargs=(
		-DCMAKE_OSX_DEPLOYMENT_TARGET=${MACOSX_DEPLOYMENT_TARGET}
		-DPACKAGE_VERSION="Gentoo ${PN}-${PVR}"
		-DCMAKE_INSTALL_PREFIX=${EPREFIX}${BINPATH%/*}  # cmake insists on /bin
		-DCCTOOLS_LD_CLASSIC=NO  # fails to link, and is useless anyway
		-DXTOOLS_LTO_SUPPORT=NO
		-DXTOOLS_HAS_LIBPRUNETRIE=YES
		-DXTOOLS_TAPI_SUPPORT=$(use tapi && echo ON || echo OFF)
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

	keepdir "${LIBPATH}"

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
