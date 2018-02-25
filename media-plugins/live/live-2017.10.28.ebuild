# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit flag-o-matic eutils toolchain-funcs multilib multilib-minimal

DESCRIPTION="Libraries for standards-based RTP/RTCP/RTSP multimedia streaming"
HOMEPAGE="http://www.live555.com/"
SRC_URI="http://www.live555.com/liveMedia/public/${P/-/.}.tar.gz
	mirror://gentoo/${P/-/.}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ia64 ~mips ~ppc ~ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="examples static-libs"
DOCS=( "live-shared/README" )

# Alexis Ballier <aballier@gentoo.org>
# Be careful, bump this everytime you bump the package and the ABI has changed.
# If you don't know, ask someone.
LIVE_ABI_VERSION=7
SLOT="0/${LIVE_ABI_VERSION}"

src_unpack() {
	unpack ${A}
	mkdir -p "${S}"
	mv "${WORKDIR}/live" "${S}/" || die
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-recursive3.patch"

	if use static-libs ; then
		cp -pPR live live-shared
		mv live live-static
	else
		mv live live-shared
	fi

	use static-libs && cp "${FILESDIR}/config.gentoo-r1" live-static/config.gentoo
	cp "${FILESDIR}/config.gentoo-so-r2" live-shared/config.gentoo-so-r1

	case ${CHOST} in
		*-solaris*)
			use static-libs && { sed -i \
				-e '/^COMPILE_OPTS /s/$/ -DSOLARIS -DXLOCALE_NOT_USED/' \
				-e '/^LIBS_FOR_CONSOLE_APPLICATION /s/$/ -lsocket -lnsl/' \
				live-static/config.gentoo \
				|| die ; }
			sed -i \
				-e '/^COMPILE_OPTS /s/$/ -DSOLARIS -DXLOCALE_NOT_USED/' \
				-e '/^LIBS_FOR_CONSOLE_APPLICATION /s/$/ -lsocket -lnsl/' \
				live-shared/config.gentoo-so-r1 \
				|| die
		;;
		*-darwin*)
			use static-libs && { sed -i \
				-e '/^COMPILE_OPTS /s/$/ -DBSD=1 -DHAVE_SOCKADDR_LEN=1/' \
				-e '/^LINK /s/$/ /' \
				-e '/^LIBRARY_LINK /s/$/ /' \
				-e '/^LIBRARY_LINK_OPTS /s/-Bstatic//' \
				live-static/config.gentoo \
				|| die static ; }
			sed -i \
				-e '/^COMPILE_OPTS /s/$/ -DBSD=1 -DHAVE_SOCKADDR_LEN=1/' \
				-e '/^LINK /s/$/ /' \
				-e '/^LIBRARY_LINK /s/=.*$/= $(CXX) -o /' \
				-e '/^LIBRARY_LINK_OPTS /s:-shared.*$:-undefined suppress -flat_namespace -dynamiclib -install_name '"${EPREFIX}/usr/$(get_libdir)/"'$@:' \
				-e '/^LIB_SUFFIX /s/so/dylib/' \
				live-shared/config.gentoo-so-r1 \
				|| die shared
		;;
	esac
	multilib_copy_sources
}

src_configure() { :; }

multilib_src_compile() {
	tc-export CC CXX LD

	if use static-libs ; then
		cd "${BUILD_DIR}/live-static"

		einfo "Beginning static library build"
		./genMakefiles gentoo
		emake -j1 LINK_OPTS="-L. $(raw-ldflags)" || die "failed to build static libraries"
	fi

	cd "${BUILD_DIR}/live-shared"
	einfo "Beginning shared library build"
	./genMakefiles gentoo-so-r1
	local suffix=$(get_libname ${LIVE_ABI_VERSION})
	emake -j1 LINK_OPTS="-L. ${LDFLAGS}" LIB_SUFFIX="${suffix#.}" || die "failed to build shared libraries"

	for i in liveMedia groupsock UsageEnvironment BasicUsageEnvironment ; do
		pushd "${BUILD_DIR}/live-shared/${i}" > /dev/null
		ln -s lib${i}.${suffix#.} lib${i}$(get_libname) || die
		popd > /dev/null
	done

	if multilib_is_native_abi; then
		einfo "Beginning programs build"
		for i in $(use examples && echo "testProgs") proxyServer mediaServer ; do
			cd "${BUILD_DIR}/live-shared/${i}"
			emake LINK_OPTS="-L. ${LDFLAGS}" || die "failed to build test programs"
		done
	fi
}

multilib_src_install() {
	for library in UsageEnvironment liveMedia BasicUsageEnvironment groupsock; do
		use static-libs && dolib.a live-static/${library}/lib${library}.a
		dolib.so live-shared/${library}/lib${library}$(get_libname ${LIVE_ABI_VERSION})
		dosym lib${library}$(get_libname ${LIVE_ABI_VERSION}) /usr/$(get_libdir)/lib${library}$(get_libname)

		insinto /usr/include/${library}
		doins live-shared/${library}/include/*h
	done

	if multilib_is_native_abi; then
		# Should we really install these?
		use examples && find live-shared/testProgs -type f -perm 755 -print0 | \
			xargs -0 dobin

		dobin live-shared/mediaServer/live555MediaServer
		dobin live-shared/proxyServer/live555ProxyServer
	fi
}
