# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit user versionator toolchain-funcs flag-o-matic systemd linux-info

MY_P="${PN}-${PV/_beta/-dev}"

DESCRIPTION="A TCP/HTTP reverse proxy for high availability environments"
HOMEPAGE="http://haproxy.1wt.eu"
SRC_URI="http://haproxy.1wt.eu/download/$(get_version_component_range 1-2)/src/${MY_P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE="+crypt doc examples libressl slz net_ns +pcre pcre-jit ssl tools vim-syntax +zlib" # lua
REQUIRED_USE="pcre-jit? ( pcre )
	?? ( slz zlib )"

DEPEND="
	pcre? (
		dev-libs/libpcre
		pcre-jit? ( dev-libs/libpcre[jit] )
	)
	ssl? (
		!libressl? ( dev-libs/openssl:0=[zlib?] )
		libressl? ( dev-libs/libressl:0= )
	)
	slz? ( dev-libs/libslz:= )
	zlib? ( sys-libs/zlib )"
# lua? ( dev-lang/lua:5.3 )
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=( CHANGELOG CONTRIBUTING MAINTAINERS )

haproxy_use() {
	(( $# != 2 )) && die "${FUNCNAME} <USE flag> <make option>"

	usex "${1}" "USE_${2}=1" "USE_${2}="
}

pkg_setup() {
	enewgroup haproxy
	enewuser haproxy -1 -1 -1 haproxy

	if use net_ns; then
		CONFIG_CHECK="~NET_NS"
		linux-info_pkg_setup
	fi
}

src_prepare() {
	default

	sed -e 's:@SBINDIR@:'/usr/bin':' contrib/systemd/haproxy.service.in \
		> contrib/systemd/haproxy.service || die

	sed -ie 's:/usr/sbin/haproxy:/usr/bin/haproxy:' src/haproxy-systemd-wrapper.c || die
}

src_compile() {
	local -a args=(
		TARGET=linux2628
		USE_GETADDRINFO=1
	)

	args+=( $(haproxy_use crypt LIBCRYPT) )

# bug 541042
#	args+=( $(haproxy_use lua LUA) )

	args+=( $(haproxy_use net_ns NS) )
	args+=( $(haproxy_use pcre PCRE) )
	args+=( $(haproxy_use pcre-jit PCRE_JIT) )

#	args+=( $(haproxy_use kernel_linux LINUX_SPLICE) )
#	args+=( $(haproxy_use kernel_linux LINUX_TPROXY) )

	args+=( $(haproxy_use ssl OPENSSL) )
	args+=( $(haproxy_use slz SLZ) )
	args+=( $(haproxy_use zlib ZLIB) )

	# For now, until the strict-aliasing breakage will be fixed
	append-cflags -fno-strict-aliasing

	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC=$(tc-getCC) ${args[@]}

	if use tools ; then
		for contrib in halog iprange ; do
			emake -C contrib/${contrib} \
				CFLAGS="${CFLAGS}" OPTIMIZE="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC=$(tc-getCC) ${args[@]}
		done
	fi
}

src_install() {
	dobin haproxy

	newconfd "${FILESDIR}/${PN}.confd" $PN
	newinitd "${FILESDIR}/${PN}.initd-r3" $PN

	doman doc/haproxy.1

	dobin haproxy-systemd-wrapper
	systemd_dounit contrib/systemd/haproxy.service

	einstalldocs

	if use doc; then
		dodoc ROADMAP doc/{close-options,configuration,cookie-options,intro,linux-syn-cookies,management,proxy-protocol}.txt
	fi

	if use tools ; then
		dobin contrib/halog/halog
		newbin contrib/iprange/iprange haproxy_iprange
	fi

	if use net_ns && use doc; then
		dodoc doc/network-namespaces.txt
	fi

	if use examples ; then
		docinto examples
		dodoc examples/*.cfg
		dodoc examples/seamless_reload.txt
	fi

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax
		doins examples/haproxy.vim
	fi
}

pkg_postinst() {
	if [[ ! -f "${EROOT}/etc/haproxy/haproxy.cfg" ]] ; then
		ewarn "You need to create /etc/haproxy/haproxy.cfg before you start the haproxy service."
		ewarn "It's best practice to not run haproxy as root, user and group haproxy was therefore created."
		ewarn "Make use of them with the \"user\" and \"group\" directives."

		if [[ -d "${EROOT}/usr/share/doc/${PF}" ]]; then
			einfo "Please consult the installed documentation for learning the configuration file's syntax."
			einfo "The documentation and sample configuration files are installed here:"
			einfo "   ${EROOT}usr/share/doc/${PF}"
		fi
	fi
}
