# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info systemd tmpfiles toolchain-funcs udev

DESCRIPTION="Device mapper target autoconfig"
HOMEPAGE="http://christophe.varoqui.free.fr/"
SRC_URI="https://github.com/opensvc/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm arm64 ~ia64 ~loong ~ppc ppc64 ~riscv ~x86"
IUSE="systemd test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/json-c:=
	dev-libs/libaio
	dev-libs/userspace-rcu:=
	>=sys-fs/lvm2-2.02.45
	sys-libs/readline:=
	>=virtual/libudev-232-r3
	systemd? ( sys-apps/systemd )
"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cmocka )
"
BDEPEND="virtual/pkgconfig"

CONFIG_CHECK="~DM_MULTIPATH"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.4-remove-Werror.patch
)

myemake() {
	local myemakeargs=(
		prefix="${EPREFIX}"
		usr_prefix="${EPREFIX}/usr"
		LIB="$(get_libdir)"
		RUN=run
		plugindir="${EPREFIX}/$(get_libdir)/multipath"
		unitdir="$(systemd_get_systemunitdir)"
		libudevdir="${EPREFIX}$(get_udevdir)"
		GENTOO_CFLAGS="${CFLAGS}"
		GENTOO_CPPFLAGS="${CPPFLAGS}"
		FORTIFY_OPT=
		OPTFLAGS=
		FAKEVAR=1
		V=1
	)

	emake "${myemakeargs[@]}" "$@"
}

src_prepare() {
	default

	sed -r -i -e '/^(CPPFLAGS|CFLAGS)\>/s,^(CPPFLAGS|CFLAGS)\>[[:space:]]+:=,\1 := $(GENTOO_\1),' \
		"${S}"/Makefile.inc || die
}

src_compile() {
	tc-export CC
	myemake
}

src_test() {
	myemake test
}

src_install() {
	dodir /sbin

	myemake DESTDIR="${ED}" install

	einstalldocs

	newinitd "${FILESDIR}"/multipathd-r1.rc multipathd
	newinitd "${FILESDIR}"/multipath.rc multipath

	find "${ED}" -type f -name '*.la' -delete || die
}

pkg_postinst() {
	tmpfiles_process /usr/lib/tmpfiles.d/multipath.conf
	udev_reload

	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "If you need multipath on your system, you must"
		elog "add 'multipath' into your boot runlevel!"
	fi
}

pkg_postrm() {
	udev_reload
}
