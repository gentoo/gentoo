# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic linux-info multilib-minimal

DESCRIPTION="Embedded Linux Library provides core, low-level functionality for system daemons"
HOMEPAGE="https://01.org/ell"
if [[ "${PV}" == *9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/libs/ell/ell.git"
else
	SRC_URI="https://mirrors.edge.kernel.org/pub/linux/libs/${PN}/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ~ppc64 ~sparc ~x86"
fi
LICENSE="LGPL-2.1"
SLOT="0"

IUSE="glib pie test"
RESTRICT="!test? ( test )"

RDEPEND="
	glib? ( dev-libs/glib:2[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
	test? ( sys-apps/dbus )
"

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
	[[ "${PV}" == *9999 ]] && eautoreconf
}

multilib_src_configure() {
	append-cflags "-fsigned-char" #662694
	local myeconfargs=(
		$(use_enable glib)
		$(use_enable pie)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	local DOCS=( ChangeLog README )
	einstalldocs

	find "${ED}" -name "*.la" -delete || die
}
