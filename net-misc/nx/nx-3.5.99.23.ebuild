# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="NX compression technology core libraries"
HOMEPAGE="https://github.com/ArcticaProject/nx-libs"

SRC_URI="https://github.com/ArcticaProject/nx-libs/archive/${PV}.tar.gz -> nx-libs-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="elibc_glibc"

RDEPEND="dev-libs/libxml2
	>=media-libs/libpng-1.2.8:0=
	>=sys-libs/zlib-1.2.3
	virtual/jpeg:*
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXfont2
	x11-libs/libXinerama
	x11-libs/libXpm
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pixman"

DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libfontenc
	x11-misc/gccmakedep
	x11-misc/imake"

BDEPEND="
	virtual/pkgconfig"

S="${WORKDIR}/nx-libs-${PV}"

src_prepare() {
	default

	# We want predictable behavior. So let's assume we never
	# have quilt installed.
	sed 's@which quilt@false@' -i mesa-quilt || die

	# Do not compress man pages by default
	sed '/^[[:space:]]*gzip.*man/d' -i Makefile || die

	# run autoreconf in all needed folders
	local subdir
	for subdir in nxcomp nxdialog nx-X11/lib nxcompshad nxproxy ; do
		pushd ${subdir} || die
		eautoreconf
		popd || die
	done
}

src_configure() {
	# Workaround until fixed upstream
	# https://github.com/ArcticaProject/nx-libs/issues/907
	append-cflags -fcommon

	# From xorg-x11-6.9.0-r3.ebuild
	pushd nx-X11 || die
	HOSTCONF="config/cf/host.def"
	echo "#define CcCmd $(tc-getCC)" >> ${HOSTCONF}
	echo "#define OptimizedCDebugFlags ${CFLAGS} GccAliasingArgs" >> ${HOSTCONF}
	echo "#define OptimizedCplusplusDebugFlags ${CXXFLAGS} GccAliasingArgs" >> ${HOSTCONF}
	# Respect LDFLAGS
	echo "#define ExtraLoadFlags ${LDFLAGS}" >> ${HOSTCONF}
	echo "#define SharedLibraryLoadFlags -shared ${LDFLAGS}" >> ${HOSTCONF}
	# Disable SunRPC, #370767
	echo "#define HasSecureRPC NO" >> ${HOSTCONF}
	popd || die

	local subdir
	for subdir in nxcomp nxdialog nxcompshad nxproxy ; do
		pushd ${subdir} || die
		econf
		popd || die
	done

	pushd "nx-X11/lib" || die
	econf --disable-poll
	popd || die
}

src_compile() {
	# First set up the build environment
	emake build-env

	# We replicate the "build-full" make target here because
	# we cannot call "make build-full" as it
	#  - calls autoreconf several times
	#  - invokes make directly but we prefer our emake

	emake -C nxcomp
	emake -C nx-X11/lib

	mkdir -p nx-X11/exports/lib/ || die
	local nxlib
	for nxlib in libNX_X11.so{,.6{,.3.0}} ; do
		ln -s ../../lib/src/.libs/${nxlib} nx-X11/exports/lib/${nxlib} || die
	done

	emake -C nxcompshad

	./mesa-quilt push -a || die

	emake -C nx-X11 BuildDependsOnly
	# Parallel make issue resurfaced, upstream working on autotools switch
	emake -j1 -C nx-X11 World \
		USRLIBDIR="/usr/$(get_libdir)/${PN}/X11" \
		SHLIBDIR="/usr/$(get_libdir)"

	emake -C nxproxy
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="/usr" \
		NXLIBDIR="/usr/$(get_libdir)/${PN}" \
		SHLIBDIR="/usr/$(get_libdir)" \
		USRLIBDIR="/usr/$(get_libdir)/${PN}/X11" \
		install

	# Already provided by mesa & related packages
	rm -r "${ED}"/usr/include/GL || die

	# Get rid of libtool files and static libs.
	find "${ED}" \( -name "*.a" -o -name "*.la" \) -delete || die
}
