# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )
inherit toolchain-funcs python-any-r1 udev

DESCRIPTION="Central Regulatory Domain Agent for wireless networks"
HOMEPAGE="https://wireless.wiki.kernel.org/en/developers/regulatory/crda"
SRC_URI="https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/crda.git/snapshot/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="gcrypt libressl"

RDEPEND="!gcrypt? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	gcrypt? ( dev-libs/libgcrypt:0= )
	dev-libs/libnl:3
	net-wireless/wireless-regdb"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/m2crypto[${PYTHON_USEDEP}]')
	virtual/pkgconfig"

python_check_deps() {
	has_version --host-root "dev-python/m2crypto[${PYTHON_USEDEP}]"
}

PATCHES=(
	"${FILESDIR}"/${PN}-no-ldconfig.patch
	"${FILESDIR}"/${PN}-no-werror.patch
	"${FILESDIR}"/${PN}-cflags.patch
	"${FILESDIR}"/${PN}-libreg-link.patch #542436
	"${FILESDIR}"/${PN}-4.14-python-3.patch
	"${FILESDIR}"/${PN}-4.14-openssl-1.1.0-compatibility.patch #652428
	"${FILESDIR}"/${PN}-libressl.patch
	"${FILESDIR}"/${PN}-ldflags.patch
	"${FILESDIR}"/${PN}-4.14-do-not-compress-doc.patch
)

src_prepare() {
	default
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
