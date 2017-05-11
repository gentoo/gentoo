# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="https://github.com/PowerDNS/pdns.git"

if [[ ${PV} = 9999 ]]; then
	GIT_ECLASS="git-r3"
	EXPERIMENTAL="true"
fi

inherit eutils user flag-o-matic systemd autotools git-r3

DESCRIPTION="dnsdist is a highly DNS-, DoS- and abuse-aware loadbalancer."
HOMEPAGE="http://dnsdist.org"

if [[ ${PV} == 9999 ]] ; then
	SRC_URI=""
	S="${WORKDIR}/${P}/pdns/dnsdistdist"
else
	SRC_URI="https://downloads.powerdns.com/releases/${P}.tar.bz2"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="bindist clang libedit luajit +sodium +protobuf re2 dnscrypt systemd static +readline"

REQUIRED_USE="
	bindist? ( libedit )
	libedit? ( !readline )
	readline? ( !libedit )
	?? ( libedit readline )
	dnscrypt? ( sodium )
"

DEPEND="
	libedit? ( dev-libs/libedit:= )
	readline? ( sys-libs/readline:0= )
	>=dev-libs/boost-1.35:=
	luajit? ( dev-lang/luajit:= )
	!luajit? ( >=dev-lang/lua-5.1:= )
	sodium? ( dev-libs/libsodium:= )
	protobuf? ( dev-libs/protobuf:= )
	re2? ( dev-libs/re2:= )
	clang? ( sys-devel/clang:= )
	systemd? ( sys-apps/systemd:= )
"

RDEPEND="${DEPEND}"

[[ ${PV} == 9999 ]] && DEPEND+="
	dev-util/ragel
	sys-devel/automake
	sys-devel/autoconf
	app-text/pandoc
"

src_prepare() {
	default

	[[ ${PV} == 9999 ]] && eautoreconf

	if use readline ; then

		# Due to licensing (dnsdsit being GPL-2 and readline GPL-3) dnsdist upstream (PowerDNS people)
		# compiles and links agains libedit (BSD-2), as upstream does provide binary packages itself.
		# However, dnsdist will work with readline, too, as it does - when compiled from ports on OpenBSD.
		# Therefore, the default beahavior here is to compile and link against readline, as to not install
		# the outdated libedit present in the portage tree, requiring a small change to dnsdist.cc and 
		# dnsdist-console.cc as described in: https://github.com/PowerDNS/pdns/issues/5294

		# sed's --follow-symlinks is a must here for the 9999 version, since those files are placed in ../.
		# in git, and then symlinked to
		sed --follow-symlinks -iorig \
			-e 's~^#include <editline/readline.h>$~#include <readline/readline.h>~g' dnsdist.cc \
			¦¦ die "dnsdist.cc: Sed broke!"

		sed --follow-symlinks -iorig \
			-e 's~^#include <editline/readline.h>$~#include <readline/readline.h>'"\n"'#include <readline/history.h>~g' dnsdist-console.cc \
			¦¦ die "dnsdist-console.cc: Sed broke!"

	fi
}

src_configure() {
	# dnsdist configure script asks about libedit through pkg-config
	# that is not available by default
	if use readline ; then
		# when using readline, one has to define these
		local -x LIBEDIT_CFLAGS="-I${ROOT}usr/include/readline"
		#local -x LIBEDIT_LIBS="-L/usr/$(get_libdir) -lreadline -lcurses"
		local -x LIBEDIT_LIBS="-lreadline -lcurses"
	fi

	if use clang; then
		local -x CC=${CHOST}-clang
		local -x CXX=${CHOST}-clang++
		#local -x LDFLAGS="${LDFLAGS} -nodefaultlibs -lc"
		strip-unsupported-flags
	fi

	econf \
		--sysconfdir=/etc/dnsdist \
		$(use_enable sodium libsodium ) \
		$(use_with protobuf ) \
		$(use_enable re2 ) \
		$(use_enable dnscrypt ) \
		$(use_with luajit ) \
		$(use_enable systemd ) \
		$(use_enable static ) \
		${myconf}
}

src_install() {
	default

	insinto /etc/dnsdist
	doins "${FILESDIR}"/dnsdist.conf

	newconfd "${FILESDIR}"/dnsdist.confd ${PN}
	newinitd "${FILESDIR}"/dnsdist.initd ${PN}

	systemd_dounit "${FILESDIR}"/dnsdist.service
}

pkg_preinst() {
	enewgroup dnsdist
	enewuser dnsdist -1 -1 -1 dnsdist
}

pkg_postinst() {
	if ! use systemd ; then
		elog "dnsdist provides multiple instances support. You can create more instances"
		elog "by symlinking the dnsdist init script to another name."
		elog
		elog "The name must be in the format dnsdist.<suffix> and dnsdist will use the"
		elog "/etc/dnsdist/dnsdist-<suffix>.conf configuration file instead of the default."
	fi

	if use readline ; then
		ewarn "dnsdist (GPLv2) was linked against readline (GPLv3)."
		ewarn "A binary distribution should therefore not happen."
		ewarn "Instead use the bindist and/or libedit USE-flag."
	fi
}
