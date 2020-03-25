# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Libraries for standards-based RTP/RTCP/RTSP multimedia streaming"
HOMEPAGE="http://www.live555.com/"
SRC_URI="http://www.live555.com/liveMedia/public/${P/-/.}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="libressl ssl"
DOCS=( "live-shared/README" )
DEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
"

# Alexis Ballier <aballier@gentoo.org>, Sam James <sam@cmpct.info>
# Be careful, bump this everytime you bump the package and the ABI has changed.
# If you don't know, ask someone.
# You may wish to use a site like https://abi-laboratory.pro/index.php?view=timeline&l=live555
LIVE_ABI_VERSION=8
SLOT="0/${LIVE_ABI_VERSION}"

S="${WORKDIR}/live"

src_prepare() {
	default

	cp "${FILESDIR}/config.gentoo-so-r3" "${S}/config.gentoo-so-r1" || die

	# This is all legacy stuff which needs to be cleaned up
	case ${CHOST} in
		*-solaris*)
			sed -i \
				-e '/^COMPILE_OPTS /s/$/ -DSOLARIS -DXLOCALE_NOT_USED/' \
				-e '/^LIBS_FOR_CONSOLE_APPLICATION /s/$/ -lsocket -lnsl/' \
				live/config.gentoo-so-r1 \
				|| die
		;;
		*-darwin*)
			sed -i \
				-e '/^COMPILE_OPTS /s/$/ -DBSD=1 -DHAVE_SOCKADDR_LEN=1/' \
				-e '/^LINK /s/$/ /' \
				-e '/^LIBRARY_LINK /s/=.*$/= $(CXX) -o /' \
				-e '/^LIBRARY_LINK_OPTS /s:-shared.*$:-undefined suppress -flat_namespace -dynamiclib -install_name '"${EPREFIX}/usr/$(get_libdir)/"'$@:' \
				-e '/^LIB_SUFFIX /s/so/dylib/' \
				live/config.gentoo-so-r1 \
				|| die shared
		;;
	esac
}

src_configure() {
	# This ebuild uses its own build system
	# We don't want to call ./configure or anything here.
	# The only thing we can do is honour the user's SSL preference.
	if use ssl; then
		sed -i 's/-DNO_OPENSSL=1//' "${S}/config.gentoo-so-r1" || die
	fi

	# And defer to the scripts that upstream provide.
	./genMakefiles gentoo-so-r1 || die
}

src_compile() {
	export suffix="${LIVE_ABI_VERSION}.so"
	local link_opts="$(usex ssl '-lssl' '') -L. ${LDFLAGS}"
	local lib_suffix="${suffix#.}"

	einfo "Beginning shared library build"
	emake LINK_OPTS="${link_opts}" LIB_SUFFIX="${lib_suffix}"

	for i in liveMedia groupsock UsageEnvironment BasicUsageEnvironment ; do
		cd "${S}/${i}" || die
		ln -s "lib${i}.${suffix}" "lib${i}.so" || die
	done

	einfo "Beginning programs build"
	for i in proxyServer mediaServer ; do
		cd "${S}/${i}" || die
		emake LINK_OPTS="${link_opts}"
	done
}

src_install() {
	for library in UsageEnvironment liveMedia BasicUsageEnvironment groupsock; do
		dolib.so "${S}/${library}/lib${library}.${suffix}"
		dosym "lib${library}.${suffix}" "/usr/$(get_libdir)/lib${library}.so"

		insinto /usr/include/"${library}"
		doins "${S}/${library}"/include/*h
	done

	dobin ${S}/mediaServer/live555MediaServer
	dobin ${S}/proxyServer/live555ProxyServer
}
