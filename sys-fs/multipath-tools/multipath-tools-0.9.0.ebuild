# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info systemd toolchain-funcs udev

DESCRIPTION="Device mapper target autoconfig"
HOMEPAGE="http://christophe.varoqui.free.fr/"
SRC_URI="https://github.com/opensvc/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~x86"
IUSE="systemd test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/json-c:=
	dev-libs/libaio
	dev-libs/userspace-rcu:=
	>=sys-fs/lvm2-2.02.45
	>=virtual/libudev-232-r3
	sys-libs/readline:=
	systemd? ( sys-apps/systemd )"
DEPEND="${RDEPEND}
	test? ( dev-util/cmocka )"
BDEPEND="virtual/pkgconfig"

CONFIG_CHECK="~DM_MULTIPATH"

PATCHES=( "${FILESDIR}"/${PN}-0.9.0-respect-flags.patch )

src_compile() {
	tc-export CC

	# LIBDM_API_FLUSH involves grepping files in /usr/include,
	# so force the test to go the way we want #411337.
	emake \
		prefix="${EPREFIX}" \
		LIB="$(get_libdir)" \
		LIBDM_API_FLUSH=1 \
		PKGCONFIG="$(tc-getPKG_CONFIG)"
}

src_install() {
	dodir /sbin /usr/share/man/man{3,5,8}
	emake \
		DESTDIR="${D}" \
		prefix="${EPREFIX}" \
		LIB="$(get_libdir)" \
		RUN=run \
		unitdir="$(systemd_get_systemunitdir)" \
		libudevdir='$(prefix)'/$(get_udevdir) \
		pkgconfdir='$(prefix)/usr/$(LIB)/pkgconfig' \
		install
	einstalldocs

	newinitd "${FILESDIR}"/multipathd-r1.rc multipathd
	newinitd "${FILESDIR}"/multipath.rc multipath

	find "${ED}" -type f -name '*.la' -delete || die
}

pkg_postinst() {
	udev_reload

	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "If you need multipath on your system, you must"
		elog "add 'multipath' into your boot runlevel!"
	fi
}

pkg_postrm() {
	udev_reload
}
