# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic eutils multilib toolchain-funcs

DESCRIPTION="Useful Apache tools - htdigest, htpasswd, ab, htdbm"
HOMEPAGE="https://httpd.apache.org/"
SRC_URI="mirror://apache/httpd/httpd-${PV}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc64-solaris ~x64-solaris"
IUSE="libressl ssl"
RESTRICT="test"

RDEPEND=">=dev-libs/apr-1.5.0:1=
	dev-libs/apr-util:1=
	dev-libs/expat
	dev-libs/libpcre
	kernel_linux? ( sys-apps/util-linux )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"

DEPEND="${RDEPEND}
	sys-devel/libtool"

S="${WORKDIR}/httpd-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-2.4.7-Makefile.patch" #459446
)

src_prepare() {
	default

	# This package really should upgrade to using pcre's .pc file.
	cat <<-\EOF >"${T}"/pcre-config
	#!/bin/bash
	flags=()
	for flag; do
		if [[ ${flag} == "--version" ]]; then
			flags+=( --modversion )
		else
			flags+=( "${flag}" )
		fi
	done
	exec ${PKG_CONFIG} libpcre "${flags[@]}"
	EOF
	chmod a+x "${T}"/pcre-config
}

src_configure() {
	# Brain dead check.
	tc-is-cross-compiler && export ap_cv_void_ptr_lt_long="no"

	tc-export PKG_CONFIG

	local myeconfargs=(
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)/apache2/modules
		--sbindir="${EPREFIX}"/usr/sbin
		--with-perl="${EPREFIX}"/usr/bin/perl
		--with-expat="${EPREFIX}"/usr
		--with-z="${EPREFIX}"/usr
		--with-apr="${SYSROOT}${EPREFIX}"/usr
		--with-apr-util="${SYSROOT}${EPREFIX}"/usr
		--with-pcre="${T}"/pcre-config
		$(use_enable ssl)
		$(usex ssl '--with-ssl="${EPREFIX}"/usr' '')
	)
	# econf overwrites the stuff from config.layout.
	ac_cv_path_PKGCONFIG=${PKG_CONFIG} \
	econf "${myeconfargs[@]}"
	sed -i \
		-e '/^LTFLAGS/s:--silent::' \
		build/rules.mk build/config_vars.mk || die
}

src_compile() {
	emake -C support
}

src_install() {
	emake -C support DESTDIR="${D}" install
	dodoc CHANGES
	doman docs/man/{dbmmanage,htdigest,htpasswd,htdbm,ab,logresolve}.1 \
		docs/man/{htcacheclean,rotatelogs}.8

	# Providing compatiblity symlinks for #177697 (which we'll stop to install
	# at some point).
	pushd "${ED%/}"/usr/sbin >/dev/null || die
	local i
	for i in *; do
		dosym ${i} /usr/sbin/${i}2
	done
	popd >/dev/null || die

	# Provide a symlink for ab-ssl
	if use ssl ; then
		dosym ab /usr/bin/ab-ssl
		dosym ab /usr/bin/ab2-ssl
	fi
}
