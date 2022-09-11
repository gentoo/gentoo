# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..4} luajit )

inherit lua-single savedconfig toolchain-funcs

################################################################################
# axtls CONFIG MINI-HOWTO
#
# Note: axtls is highly configurable and uses mconf, like the linux kernel.
# You can configure it in a couple of ways:
#
# 1) USE="-savedconfig" and set/unset the remaining flags to obtain the features
# you want, and possibly a lot more.
#
# 2) You can create your own configuration file by doing
#
#	FEATURES="keepwork" USE="savedconfig -*" emerge axtls
#	cd /var/tmp/portage/net-libs/axtls*/work/axTLS
#	make menuconfig
#
# Now configure axtls as you want.  Finally save your config file:
#
#	cp config/.config /etc/portage/savedconfig/net-libs/axtls-${PV}
#
# where ${PV} is the current version.  You can then run emerge again with
# your configuration by doing
#
#	USE="savedconfig" emerge axtls
#
################################################################################

MY_PN=${PN/tls/TLS}

DESCRIPTION="Embedded client/server TLSv1 SSL library and small HTTP(S) server"
HOMEPAGE="http://axtls.sourceforge.net/"
SRC_URI="mirror://sourceforge/axtls/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${PN}-code"

LICENSE="BSD GPL-2"
SLOT="0/1"
KEYWORDS="amd64 arm ~arm64 ~hppa ~mips ppc ppc64 ~s390 ~sparc x86"

IUSE="httpd cgi-lua cgi-php static doc"

# TODO: add ipv6, and c#, java, lua, perl bindings
# Currently these all have some issue
BDEPEND="doc? ( app-doc/doxygen )"
RDEPEND="
	httpd? (
		acct-group/axtls
		acct-user/axtls
		cgi-lua? ( ${LUA_DEPS} )
		cgi-php? ( dev-lang/php[cgi] )
	)"

#Note1: static, cgi-* makes no sense if httpd is not given
REQUIRED_USE="
	static? ( httpd )
	cgi-lua? ( httpd ${LUA_REQUIRED_USE} )
	cgi-php? ( httpd )"

pkg_setup() {
	use cgi-lua && lua-single_pkg_setup
}

src_prepare() {
	tc-export AR CC

	eapply "${FILESDIR}/explicit-libdir-r1.patch"

	# We want CONFIG_DEBUG to avoid stripping
	# but not for debugging info
	sed -i -e 's: -g::' config/Rules.mak || die
	sed -i -e 's: -g::' config/makefile.conf || die

	eapply_user
}

use_flag_config() {
	cp "${FILESDIR}"/config config/.config || die

	#Respect CFLAGS/LDFLAGS
	sed -i -e "s:^CONFIG_EXTRA_CFLAGS_OPTIONS.*$:CONFIG_EXTRA_CFLAGS_OPTIONS=\"${CFLAGS}\":" \
		config/.config || die
	sed -i -e "s:^CONFIG_EXTRA_LDFLAGS_OPTIONS.*$:CONFIG_EXTRA_LDFLAGS_OPTIONS=\"${LDFLAGS}\":" \
		config/.config || die

	#The logic is that the default config file enables everything and we disable
	#here with sed unless a USE flags says to keep it
	if use httpd; then
		if ! use static; then
			sed -i -e 's:^CONFIG_HTTP_STATIC_BUILD:# CONFIG_HTTP_STATIC_BUILD:' \
				config/.config || die
		fi
		if ! use cgi-php && ! use cgi-lua; then
			sed -i -e 's:^CONFIG_HTTP_HAS_CGI:# CONFIG_HTTP_HAS_CGI:' \
				config/.config || die
		fi
		if ! use cgi-php; then
			sed -i -e 's:,.php::' config/.config || die
		fi
		if ! use cgi-lua; then
			sed -i -e 's:\.lua,::' \
				-e 's:lua:php:' \
				-e 's:^CONFIG_HTTP_ENABLE_LUA:# CONFIG_HTTP_ENABLE_LUA:' \
				config/.config || die
		fi
		if use cgi-lua; then
			sed -i -e "s:/usr/bin/lua:${LUA}:" config/.config || die
		fi
	else
		sed -i -e 's:^CONFIG_AXHTTPD:# CONFIG_AXHTTPD:' \
			config/.config || die
	fi

	emake -j1 oldconfig < <(yes n) > /dev/null
}

src_configure() {
	# Per-ABI substitutions.
	sed -i -e 's:^LIBDIR.*/lib:LIBDIR = $(PREFIX)/'"$(get_libdir):" \
		Makefile || die

	# Use CC as the host compiler for mconf
	sed -i -e "s:^HOSTCC.*:HOSTCC=${CC}:" \
		config/Rules.mak || die

	if use savedconfig; then
		restore_config config/.config
		if [[ -f config/.config ]]; then
			ewarn "Using saved config, all other USE flags ignored"
		else
			ewarn "No saved config, seeding with the default"
			cp "${FILESDIR}"/config config/.config || die
		fi
		emake -j1 oldconfig < <(yes '') > /dev/null
	else
		use_flag_config
	fi
}

src_install() {
	if use savedconfig; then
		save_config config/.config
	fi

	emake PREFIX="${ED}/usr" install

	rm -f "${ED}"/usr/$(get_libdir)/libaxtls.a || die

	# The build system needs to install before it builds docs
	if use doc; then
		emake docs
		dodoc -r docsrc/html
	fi

	if [[ -f "${ED}"/usr/bin/htpasswd ]]; then
		mv "${ED}"/usr/bin/{,ax}htpasswd || die
	fi

	if use httpd; then
		newinitd "${FILESDIR}"/axhttpd.initd axhttpd
		newconfd "${FILESDIR}"/axhttpd.confd axhttpd
	fi

	docompress -x /usr/share/doc/${PF}/README
	dodoc README
}
