# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit eutils toolchain-funcs python-any-r1 udev

DESCRIPTION="Central Regulatory Domain Agent for wireless networks"
HOMEPAGE="https://wireless.wiki.kernel.org/en/developers/regulatory/crda"
SRC_URI="http://linuxwireless.org/download/crda/${P}.tar.xz
	mirror://kernel/software/network/crda/${P}.tar.xz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="gcrypt libressl"

RDEPEND="!gcrypt? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
	)
	gcrypt? ( dev-libs/libgcrypt:0 )
	dev-libs/libnl:3
	net-wireless/wireless-regdb"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/m2crypto[${PYTHON_USEDEP}]')
	virtual/pkgconfig"

python_check_deps() {
	has_version --host-root "dev-python/m2crypto[${PYTHON_USEDEP}]"
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.18-no-ldconfig.patch
	epatch "${FILESDIR}"/${PN}-3.18-no-werror.patch
	epatch "${FILESDIR}"/${PN}-3.18-openssl.patch
	epatch "${FILESDIR}"/${PN}-3.18-cflags.patch
	epatch "${FILESDIR}"/${PN}-3.18-libreg-link.patch #542436
	sed -i \
		-e "s:\<pkg-config\>:$(tc-getPKG_CONFIG):" \
		Makefile || die
}

_emake() {
	# The source hardcodes /usr/lib/crda/ paths (ignoring all make vars
	# that look like it should change it).  We want to use /usr/lib/
	# anyways as this file is not ABI specific and we want to share it
	# among all ABIs rather than pointlessly duplicate it.
	#
	# The trailing slash on SBINDIR is required by the source.
	emake \
		PREFIX="${EPREFIX}/usr" \
		SBINDIR='$(PREFIX)/sbin/' \
		LIBDIR='$(PREFIX)/'"$(get_libdir)" \
		UDEV_RULE_DIR="$(get_udevdir)/rules.d" \
		REG_BIN="${SYSROOT}"/usr/lib/crda/regulatory.bin \
		USE_OPENSSL=$(usex gcrypt 0 1) \
		CC="$(tc-getCC)" \
		V=1 \
		WERROR= \
		"$@"
}

src_compile() {
	_emake all_noverify
}

src_test() {
	_emake verify
}

src_install() {
	_emake DESTDIR="${D}" install
	keepdir /etc/wireless-regdb/pubkeys
}
