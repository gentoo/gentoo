# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/nsis/nsis-2.46-r1.ebuild,v 1.5 2014/09/26 12:54:56 pacho Exp $

EAPI="5"
mingw32_variants=$(echo {,i{6,5,4,3}86-{,pc-,w32-,w64-}}mingw32)

inherit eutils

DESCRIPTION="Nullsoft Scriptable Install System"
HOMEPAGE="http://nsis.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.bz2
	http://f0rt.users.sourceforge.net/makensis_64bit.patch
	http://f0rt.users.sourceforge.net/nsis_w64-mingw.patch"

LICENSE="ZLIB BZIP2 CPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="bzip2 config-log doc zlib"
RESTRICT="strip"

# NSIS Menu uses wxwindows but it's all broken, so disable for now
#	wxwindows? ( x11-libs/wxGTK )
RDEPEND="bzip2? ( app-arch/bzip2 )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	>=dev-util/scons-0.98"

S="${WORKDIR}"/${P}-src

mingw_CTARGET() {
	local i
	for i in ${mingw32_variants} ; do
		type -P ${i}-g++ > /dev/null && echo ${i} && return
	done
}

pkg_pretend() {
	[[ -n $(mingw_CTARGET) ]] && return 0

	eerror "Before you could emerge nsis, you need to install mingw with C++ support"
	eerror "Run the following commands:"
	eerror "  emerge crossdev"
	eerror "  USE='cxx' crossdev --stable --libc '[latest]' -t i686-w64-mingw32"
	die "mingw is needed"
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc47.patch
	epatch "${DISTDIR}/makensis_64bit.patch"
	epatch "${DISTDIR}/nsis_w64-mingw.patch"

	sed -i 's/SetDefault/Append/' "${S}/Source/exehead/SConscript" || die #505996

	# a dirty but effective way of killing generated docs
	use doc || echo > Docs/src/SConscript
}

get_additional_options() {
	echo \
		PREFIX=/usr \
		PREFIX_CONF=/etc \
		PREFIX_DOC=/usr/share/doc/${PF} \
		PREFIX_DEST=\"${D}\" \
		VERSION=${PV} \
		DEBUG=no \
		STRIP=no
	echo \
		SKIPSTUBS=\"$(use zlib || echo zlib) $(use bzip2 || echo bzip2)\" \
		SKIPUTILS=\"NSIS Menu\"
	use config-log && echo NSIS_CONFIG_LOG=yes

	local tcpfx=$($(mingw_CTARGET)-gcc -print-file-name=libshell32.a)
	tcpfx=${tcpfx%/lib/libshell32.a}
	echo \
		PREFIX_PLUGINAPI_INC=${tcpfx}/include \
		PREFIX_PLUGINAPI_LIB=${tcpfx}/lib
	echo CROSS_W32=$(mingw_CTARGET)-
}

do_scons() {
	local cmd=$1
	eval set -- $(get_additional_options)
	echo scons $(get_additional_options) ${cmd}
	scons "$@" ${cmd}
}

src_compile() {
	do_scons || die "scons failed"
}

src_install() {
	do_scons install || die "scons failed"
	use doc || rm -rf "${D}"/usr/share/doc/${PF}/{Docs,Examples}

	fperms -R go-w,a-x,a+X /usr/share/${PN}/ /usr/share/doc/${PF}/ /etc/nsisconf.nsh

	env -uRESTRICT prepstrip "${D}/usr/bin"
	src_strip_win32
}

src_strip_win32() {
	# need to strip win32 binaries ourselves ... should fold this
	# back in to prepstrip at some point
	local STRIP_PROG=$(mingw_CTARGET)-strip
	local STRIP_FLAGS="--strip-unneeded"

	echo
	echo "strip: ${STRIP_PROG} ${STRIP_FLAGS}"
	local FILE
	for FILE in $(find "${D}" -iregex '.*\.\(dll\|exe\|a\)$') ; do
		echo "   /${FILE#${D}}"
		${STRIP_PROG} ${STRIP_FLAGS} "${FILE}"
	done
}
