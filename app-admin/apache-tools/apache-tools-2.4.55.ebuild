# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Useful Apache tools - htdigest, htpasswd, ab, htdbm"
HOMEPAGE="https://httpd.apache.org/"
SRC_URI="mirror://apache/httpd/httpd-${PV}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc64-solaris ~x64-solaris"
IUSE="ssl"
RESTRICT="test"

RDEPEND=">=dev-libs/apr-1.5.0:1=
	dev-libs/apr-util:1=
	dev-libs/expat
	dev-libs/libpcre2
	virtual/libcrypt:=
	kernel_linux? ( sys-apps/util-linux )
	ssl? ( dev-libs/openssl:0= )"
DEPEND="${RDEPEND}
	sys-devel/libtool"
BDEPEND="
	virtual/pkgconfig
"

S="${WORKDIR}/httpd-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-2.4.54-Makefile.patch" #459446
	"${FILESDIR}/${PN}-2.4.54-no-which.patch" #844868
	"${FILESDIR}/${PN}-2.4.54-libtool.patch" #858833
)

src_prepare() {
	default

	# This package really should upgrade to using pcre's .pc file.
	cat <<-\EOF > "${T}"/pcre2-config
	#!/usr/bin/env bash
	flags=()
	for flag; do
		if [[ ${flag} == "--version" ]]; then
			flags+=( --modversion )
		else
			flags+=( "${flag}" )
		fi
	done
	exec ${PKG_CONFIG} libpcre2-8 "${flags[@]}"
	EOF
	chmod a+x "${T}"/pcre2-config || die

	# Only here for libtool and which patches
	eautoreconf
}

src_configure() {
	# Silly check.
	tc-is-cross-compiler && export ap_cv_void_ptr_lt_long="no"

	tc-export PKG_CONFIG
	export ac_cv_path_PKGCONFIG="${PKG_CONFIG}"
	export ac_cv_prog_ac_ct_PCRE_CONFIG="${T}"/pcre2-config

	local myeconfargs=(
		--libexecdir="${EPREFIX}"/usr/$(get_libdir)/apache2/modules
		--sbindir="${EPREFIX}"/usr/sbin
		--with-z="${EPREFIX}"/usr
		--with-apr="${ESYSROOT}"/usr
		--with-apr-util="${ESYSROOT}"/usr
		--without-pcre
		--with-pcre2="${T}"/pcre2-config
		$(use_enable ssl)
		$(usex ssl '--with-ssl="${EPREFIX}"/usr' '')
	)

	# econf overwrites the stuff from config.layout.
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
	pushd "${ED}"/usr/sbin >/dev/null || die
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
