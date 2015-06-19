# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/axtls/axtls-1.5.1.ebuild,v 1.6 2015/05/10 12:16:07 blueness Exp $

EAPI="5"

inherit eutils multilib multilib-minimal savedconfig toolchain-funcs user

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
SLOT="0"
KEYWORDS="amd64 arm hppa ~mips ppc ppc64 ~s390 x86"

IUSE="httpd cgi-lua cgi-php static static-libs doc"

# TODO: add ipv6, and c#, java, lua, perl bindings
# Currently these all have some issue
DEPEND="doc? ( app-doc/doxygen )"
RDEPEND="
	httpd? (
		cgi-lua? ( dev-lang/lua )
		cgi-php? ( dev-lang/php[cgi] )
	)"

#Note1: static, cgi-* makes no sense if httpd is not given
REQUIRED_USE="
	static? ( httpd )
	cgi-lua? ( httpd )
	cgi-php? ( httpd )"

AXTLS_GROUP="axtls"
AXTLS_USER="axtls"

pkg_setup() {
	use httpd && {
		ebegin "Creating axtls user and group"
		enewgroup ${AXTLS_GROUP}
		enewuser ${AXTLS_USER} -1 -1 -1 ${AXTLS_GROUP}
	}
}

src_prepare() {
	tc-export AR CC

	epatch "${FILESDIR}/explicit-libdir-r1.patch"

	#We want CONFIG_DEBUG to avoid stripping
	#but not for debugging info
	sed -i -e 's: -g::' config/Rules.mak || die
	sed -i -e 's: -g::' config/makefile.conf || die

	multilib_copy_sources
}

use_flag_config() {
	cp "${FILESDIR}"/config config/.config || die

	#Respect CFLAGS/LDFLAGS
	sed -i -e "s:^CONFIG_EXTRA_CFLAGS_OPTIONS.*$:CONFIG_EXTRA_CFLAGS_OPTIONS=\"${CFLAGS}\":" \
		config/.config || die
	sed -i -e "s:^CONFIG_EXTRA_LDFLAGS_OPTIONS.*$:CONFIG_EXTRA_LDFLAGS_OPTIONS=\"${LDLAGS}\":" \
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
	else
		sed -i -e 's:^CONFIG_AXHTTPD:# CONFIG_AXHTTPD:' \
			config/.config || die
	fi

	yes "n" | emake -j1 oldconfig > /dev/null || die
}

multilib_src_configure() {
	#Per-ABI substitutions.
	sed -i -e 's:^LIBDIR.*/lib:LIBDIR = $(PREFIX)/'"$(get_libdir):" \
		Makefile || die

	#Use CC as the host compiler for mconf
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
		yes "" | emake -j1 oldconfig > /dev/null || die
	else
		use_flag_config
	fi
}

multilib_src_install() {
	if multilib_is_native_abi && use savedconfig; then
		save_config config/.config
	fi

	emake PREFIX="${ED}/usr" install

	if ! use static-libs; then
		rm -f "${ED}"/usr/$(get_libdir)/libaxtls.a || die
	fi

	# The build system needs to install before it builds docs
	if multilib_is_native_abi && use doc; then
		emake docs
		dodoc -r docsrc/html
	fi
}

multilib_src_install_all() {
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
