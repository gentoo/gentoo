# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic verify-sig

# Please bump the following packages together:
# dev-util/lttng-modules
# dev-util/lttng-tools
# dev-util/lttng-ust

MY_P="${P/_rc/-rc}"
MY_SLOT="$(ver_cut 1-2)"

DESCRIPTION="Linux Trace Toolkit - next generation"
HOMEPAGE="https://lttng.org"
SRC_URI="
	https://lttng.org/files/${PN}/${MY_P}.tar.bz2
	verify-sig? ( https://lttng.org/files/${PN}/${MY_P}.tar.bz2.asc )
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0/${MY_SLOT}"
KEYWORDS="amd64 ~x86"
IUSE="kmod test +ust"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/userspace-rcu-0.11.0:=
	dev-libs/popt
	>=dev-libs/libxml2-2.7.6:=
	kmod? ( sys-apps/kmod )
	ust? ( dev-util/lttng-ust:0/${MY_SLOT} )
"
DEPEND="
	${RDEPEND}
	test? ( >=dev-libs/libpfm-4.0 )
"
BDEPEND="
	virtual/pkgconfig
	test? ( dev-util/babeltrace:0 )
	verify-sig? ( sec-keys/openpgp-keys-jeremiegalarneau )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/jeremiegalarneau.asc

QA_CONFIG_IMPL_DECL_SKIP=(
	pthread_get_name_np # different from pthread_getname_*, not on linux
	pthread_set_name_np # different from pthread_setname_*, not on linux
)

PATCHES=(
	"${FILESDIR}"/lttng-tools-2.13.0-libxml2-2.14.patch
)

src_prepare() {
	default

	# skip tests that appear to fail due to the sandbox
	sed -e '/tools\/save-load\/test_autoload/d' \
		-e '/tools\/metadata\/test_ust/d' \
		-i tests/regression/Makefile.am || die

	# skip tests which fail outside the ebuild as well
	sed -e '/tools\/notification\/test_notification_ust_buffer_usage/d' \
		-e '/tools\/notification\/test_notification_notifier_discarded_count/d' \
		-e '/tools\/notification\/test_notification_multi_app/d' \
		-i tests/regression/Makefile.am || die

	eautoreconf
}

src_configure() {
	# bug 906928
	use elibc_musl && append-cppflags -D_LARGEFILE64_SOURCE

	local myeconfargs=(
		$(use_with kmod)
		$(use_with ust lttng-ust)
		--disable-test-sdt-uprobe
		--disable-python-bindings
		--disable-Werror
		--disable-maintainer-mode
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	# see tests/README.adoc
	local -x LTTNG_ENABLE_DESTRUCTIVE_TESTS=0
	local -x LTTNG_TOOLS_DISABLE_KERNEL_TESTS=1

	# Otherwise it might try to use the system installed binary (and fail if its not installed prior!)
	local -x LTTNG_SESSIOND_PATH="${S}/src/bin/lttng-sessiond/lttng-sessiond"

	# Otherwise it might try to use /var/lib/portage/home
	local -x LTTNG_HOME="${HOME}/lttng"
	mkdir -p "${LTTNG_HOME}" || die

	# Tests misbehave if you are unlucky
	emake check -j1
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
