# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/live/live-2013.02.11.ebuild,v 1.4 2015/06/11 19:16:25 maekke Exp $

EAPI=3
inherit flag-o-matic eutils toolchain-funcs multilib

DESCRIPTION="Libraries for standards-based RTP/RTCP/RTSP multimedia streaming"
HOMEPAGE="http://www.live555.com/"
SRC_URI="http://www.live555.com/liveMedia/public/${P/-/.}.tar.gz
	mirror://gentoo/${P/-/.}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="examples static-libs"

S="${WORKDIR}"

# Alexis Ballier <aballier@gentoo.org>
# Be careful, bump this everytime you bump the package and the ABI has changed.
# If you don't know, ask someone.
LIVE_ABI_VERSION=6

src_prepare() {
	cd "${WORKDIR}"
	epatch "${FILESDIR}/${PN}-recursive2.patch"

	if use static-libs ; then
		cp -pPR live live-shared
		mv live live-static
	else
		mv live live-shared
	fi

	use static-libs && cp "${FILESDIR}/config.gentoo" live-static
	cp "${FILESDIR}/config.gentoo-so-r1" live-shared

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
}

src_configure() { :; }

src_compile() {
	tc-export CC CXX LD

	# Still build the old synchronous interface as mplayer still needs it.
	# Please drop me at some point!
	append-flags '-DRTSPCLIENT_SYNCHRONOUS_INTERFACE'

	if use static-libs ; then
		cd "${WORKDIR}/live-static"

		einfo "Beginning static library build"
		./genMakefiles gentoo
		emake -j1 LINK_OPTS="-L. $(raw-ldflags)" || die "failed to build static libraries"
	fi

	cd "${WORKDIR}/live-shared"
	einfo "Beginning shared library build"
	./genMakefiles gentoo-so-r1
	local suffix=$(get_libname ${LIVE_ABI_VERSION})
	emake -j1 LINK_OPTS="-L. ${LDFLAGS}" LIB_SUFFIX="${suffix#.}" || die "failed to build shared libraries"

	for i in liveMedia groupsock UsageEnvironment BasicUsageEnvironment ; do
		pushd "${WORKDIR}/live-shared/${i}" > /dev/null
		ln -s lib${i}.${suffix#.} lib${i}$(get_libname) || die
		popd > /dev/null
	done

	einfo "Beginning programs build"
	for i in $(use examples && echo "testProgs") proxyServer mediaServer ; do
		cd "${WORKDIR}/live-shared/${i}"
		emake LINK_OPTS="-L. ${LDFLAGS}" || die "failed to build test programs"
	done
}

src_install() {
	for library in UsageEnvironment liveMedia BasicUsageEnvironment groupsock; do
		use static-libs && dolib.a live-static/${library}/lib${library}.a
		dolib.so live-shared/${library}/lib${library}$(get_libname ${LIVE_ABI_VERSION})
		dosym lib${library}$(get_libname ${LIVE_ABI_VERSION}) /usr/$(get_libdir)/lib${library}$(get_libname)

		insinto /usr/include/${library}
		doins live-shared/${library}/include/*h
	done

	# Should we really install these?
	use examples && find live-shared/testProgs -type f -perm +111 -print0 | \
		xargs -0 dobin

	dobin live-shared/mediaServer/live555MediaServer
	dobin live-shared/proxyServer/live555ProxyServer

	# install docs
	dodoc live-shared/README
}
