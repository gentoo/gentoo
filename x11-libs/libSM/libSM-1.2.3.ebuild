# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

XORG_DOC=doc
XORG_MULTILIB=yes
inherit xorg-2

DESCRIPTION="X.Org Session Management library"

KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="doc ipv6 +uuid"

RDEPEND="x11-base/xorg-proto
	>=x11-libs/libICE-1.0.8-r1[${MULTILIB_USEDEP}]
	x11-libs/xtrans
	!elibc_FreeBSD? ( !elibc_SunOS? ( !elibc_Darwin? (
		uuid? ( >=sys-apps/util-linux-2.24.1-r3[${MULTILIB_USEDEP}] )
	) ) )"
DEPEND="${RDEPEND}"

src_configure() {
	local withuuid=$(use_with uuid libuuid)

	# do not use uuid even if available in libc (like on FreeBSD)
	use uuid || export ac_cv_func_uuid_create=no

	if use uuid ; then
		case ${CHOST} in
			*-solaris*|*-darwin*)
				if [[ ! -d ${EROOT}usr/include/uuid ]] &&
					[[ -d ${ROOT}usr/include/uuid ]]
				then
					# Solaris and Darwin have uuid provided by the host
					# system.  Since util-linux's version is based on this
					# version, and on Darwin actually breaks host headers when
					# installed, we can "pretend" for libSM we have libuuid
					# installed, while in fact we don't
					withuuid="--without-libuuid"
					export HAVE_LIBUUID=yes
					export LIBUUID_CFLAGS="-I${ROOT}usr/include/uuid"
					# Darwin has uuid in libSystem
					[[ ${CHOST} == *-solaris* ]] &&	export LIBUUID_LIBS="-luuid"
				fi
				;;
		esac
	fi
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable ipv6)
		$(use_enable doc docs)
		$(use_with doc xmlto)
		${withuuid}
		--without-fop
	)
	xorg-2_src_configure
}
