# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic linux-info

DESCRIPTION="Embedded Linux Library provides core, low-level functionality for system daemons"
HOMEPAGE="https://01.org/ell"
if [[ "${PV}" == *9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/libs/ell/ell.git"
else
	SRC_URI="https://mirrors.edge.kernel.org/pub/linux/libs/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
fi
LICENSE="LGPL-2.1"
SLOT="0"

IUSE="pie test"
RESTRICT="!test? ( test )"

DEPEND="test? ( sys-apps/dbus )"

CONFIG_CHECK="
	~TIMERFD
	~EVENTFD
	~CRYPTO_USER_API
	~CRYPTO_USER_API_HASH
	~CRYPTO_MD5
	~CRYPTO_SHA1
	~KEY_DH_OPERATIONS
"

src_prepare() {
	default
	sed -i -e "s#/tmp/ell-test-bus#/tmp/ell-test-bus-$(uuidgen)#" \
		unit/test-dbus*.c unit/dbus.conf || die
	[[ "${PV}" == *9999 ]] && eautoreconf
}

src_configure() {
	append-cflags "-fsigned-char" #662694
	local myeconfargs=(
		$(use_enable pie)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	find "${ED}" -name "*.la" -delete || die
}
