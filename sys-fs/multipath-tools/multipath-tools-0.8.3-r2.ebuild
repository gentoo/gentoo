# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit linux-info systemd toolchain-funcs udev vcs-snapshot toolchain-funcs

DESCRIPTION="Device mapper target autoconfig"
HOMEPAGE="http://christophe.varoqui.free.fr/"
SRC_URI="https://git.opensvc.com/?p=multipath-tools/.git;a=snapshot;h=${PV};sf=tgz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ppc ppc64 x86"
IUSE="systemd rbd"

BDEPEND="virtual/pkgconfig"

RDEPEND="
	dev-libs/json-c:=
	dev-libs/libaio
	dev-libs/userspace-rcu:=
	>=sys-fs/lvm2-2.02.45
	>=virtual/libudev-232-r3
	sys-libs/readline:0=
	rbd? ( sys-cluster/ceph )
	systemd? ( sys-apps/systemd )
"

DEPEND="${RDEPEND}"

CONFIG_CHECK="~DM_MULTIPATH"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.5-respect-flags.patch
	"${FILESDIR}"/${PN}-0.8.3-no-gziped-docs.patch
	"${FILESDIR}"/${PN}-0.8.3-json-c-0.14.patch
	"${FILESDIR}"/${PN}-0.8.3-fix-gcc-10-compatibility.patch
)

get_systemd_pv() {
	use systemd && \
		$(tc-getPKG_CONFIG) --modversion systemd
}

src_prepare() {
	default

	# The upstream lacks any way to configure the build at present
	# and ceph is a huge dependency, so we're using sed to make it
	# optional until the upstream has a proper configure system
	if ! use rbd ; then
		sed \
			-e "s/libcheckrbd.so/# libcheckrbd.so/" \
			-e "s/-lrados//" \
			-i libmultipath/checkers/Makefile \
			|| die
	fi
}

src_compile() {
	# LIBDM_API_FLUSH involves grepping files in /usr/include,
	# so force the test to go the way we want #411337.
	emake \
		CC="$(tc-getCC)" \
		LIBDM_API_FLUSH=1 SYSTEMD="$(get_systemd_pv)"
}

src_install() {
	dodir /sbin /usr/share/man/man{5,8}
	emake \
		DESTDIR="${D}" \
		RUN=run \
		SYSTEMD=$(get_systemd_pv) \
		unitdir="$(systemd_get_systemunitdir)" \
		libudevdir='${prefix}'/"$(get_udevdir)" \
		pkgconfdir='${prefix}'/usr/'${LIB}'/pkgconfig \
		install

	newinitd "${FILESDIR}"/multipathd-r1.rc multipathd
	newinitd "${FILESDIR}"/multipath.rc multipath

	einstalldocs
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "If you need multipath on your system, you must"
		elog "add 'multipath' into your boot runlevel!"
	fi
}
