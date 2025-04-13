# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_DOC=doc
XORG_MULTILIB=yes
inherit xorg-3

DESCRIPTION="X.Org Session Management library"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="+uuid"

RDEPEND="
	>=x11-libs/libICE-1.1.0[${MULTILIB_USEDEP}]
	uuid? (
		elibc_Darwin? ( sys-libs/native-uuid )
		!elibc_SunOS? ( !elibc_Darwin? (
			>=sys-apps/util-linux-2.24.1-r3[${MULTILIB_USEDEP}]
		) )
	)"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/xtrans"

src_configure() {
	local withuuid=$(use_with uuid libuuid)

	# do not use uuid even if available in libc (like on FreeBSD)
	use uuid || export ac_cv_func_uuid_create=no

	if use uuid ; then
		case ${CHOST} in
			*-solaris*|*-darwin*)
				if [[ ! -d ${EROOT}/usr/include/uuid ]] &&
					[[ -d ${ROOT}/usr/include/uuid ]]
				then
					# Solaris and Darwin have uuid provided by the host
					# system.  Since util-linux's version is based on this
					# version, and on Darwin actually breaks host headers when
					# installed, we can "pretend" for libSM we have libuuid
					# installed, while in fact we don't
					withuuid="--without-libuuid"
					export HAVE_LIBUUID=yes
					export LIBUUID_CFLAGS="-I${ROOT}/usr/include/uuid"
					# Darwin has uuid in libSystem
					[[ ${CHOST} == *-solaris* ]] &&	export LIBUUID_LIBS="-luuid"
				fi
				;;
		esac
	fi

	local XORG_CONFIGURE_OPTIONS=(
		--enable-ipv6
		$(use_enable doc docs)
		$(use_with doc xmlto)
		${withuuid}
		--without-fop
	)
	xorg-3_src_configure
}
