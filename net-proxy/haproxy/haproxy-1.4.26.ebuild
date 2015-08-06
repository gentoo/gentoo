# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/haproxy/haproxy-1.4.26.ebuild,v 1.3 2015/08/06 11:48:30 ago Exp $

EAPI="5"

inherit user versionator toolchain-funcs flag-o-matic

DESCRIPTION="A TCP/HTTP reverse proxy for high availability environments"
HOMEPAGE="http://haproxy.1wt.eu"
SRC_URI="http://haproxy.1wt.eu/download/$(get_version_component_range 1-2)/src/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ~x86"
IUSE="+crypt examples +pcre vim-syntax"

DEPEND="pcre? ( dev-libs/libpcre )"
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup haproxy
	enewuser haproxy -1 -1 -1 haproxy
}

src_compile() {
	local args="TARGET=linux2628"

	if use pcre; then
		args="${args} USE_PCRE=1"
	else
		args="${args} USE_PCRE="
	fi

#	if use kernel_linux; then
#		args="${args} USE_LINUX_SPLICE=1 USE_LINUX_TPROXY=1"
#	else
#		args="${args} USE_LINUX_SPLICE= USE_LINUX_TPROXY="
#	fi

	if use crypt; then
		args="${args} USE_LIBCRYPT=1"
	else
		args="${args} USE_LIBCRYPT="
	fi

	# For now, until the strict-aliasing breakage will be fixed
#	append-cflags -fno-strict-aliasing

	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC=$(tc-getCC) ${args} || die
}

src_install() {
	dobin haproxy || die

	newinitd "${FILESDIR}/haproxy.initd-r2" haproxy || die

	# Don't install useless files
	rm examples/build.cfg doc/*gpl.txt

	dodoc CHANGELOG ROADMAP doc/{configuration,haproxy-en}.txt
	doman doc/haproxy.1

	if use examples;
	then
		docinto examples
		dodoc examples/*.cfg || die
	fi

	if use vim-syntax;
	then
		insinto /usr/share/vim/vimfiles/syntax
		doins examples/haproxy.vim || die
	fi
}

pkg_postinst() {
	if [[ ! -f "${ROOT}/etc/haproxy.cfg" ]] ; then
		ewarn "You need to create /etc/haproxy.cfg before you start the haproxy service."
		ewarn "It's best practice to not run haproxy as root, user and group haproxy was therefore created."
		ewarn "Make use of them with the \"user\" and \"group\" directives."

		if [[ -d "${ROOT}/usr/share/doc/${PF}" ]]; then
			einfo "Please consult the installed documentation for learning the configuration file's syntax."
			einfo "The documentation and sample configuration files are installed here:"
			einfo "   ${ROOT}usr/share/doc/${PF}"
		fi
	fi
}
