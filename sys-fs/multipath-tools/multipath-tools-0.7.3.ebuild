# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-info systemd toolchain-funcs udev vcs-snapshot toolchain-funcs

DESCRIPTION="Device mapper target autoconfig"
HOMEPAGE="http://christophe.varoqui.free.fr/"
SRC_URI="http://git.opensvc.com/?p=multipath-tools/.git;a=snapshot;h=${PV};sf=tgz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="systemd rbd"

RDEPEND="
	dev-libs/json-c
	dev-libs/libaio
	dev-libs/userspace-rcu
	>=sys-fs/lvm2-2.02.45
	>=virtual/udev-171
	sys-libs/readline:0=
	rbd? ( sys-cluster/ceph )
	systemd? ( sys-apps/systemd )
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

CONFIG_CHECK="~DM_MULTIPATH"

PATCHES=( "${FILESDIR}"/${PN}-0.7.3-fix-build-without-systemd.patch )

get_systemd_pv() {
	use systemd && \
		$(tc-getPKG_CONFIG) --modversion systemd
}

pkg_pretend() {
	linux-info_pkg_setup
}

pkg_setup() {
	linux-info_pkg_setup
}

src_prepare() {
	default

	# Fix for bug #624884
	if grep -qF DM_TABLE_STATE kpartx/kpartx.rules ; then
		sed '/DM_TABLE_STATE/d' -i kpartx/kpartx.rules || die
	else
		elog "DM_TABLE_STATE sed hack is no longer necessary."
	fi

	# The upstream lacks any way to configure the build at present
	# and ceph is a huge dependency, so we're using sed to make it
	# optional until the upstream has a proer configure system
	if ! use rbd ; then
		sed -i -e "s/libcheckrbd.so/# libcheckrbd.so/" libmultipath/checkers/Makefile
		sed -i -e "s/-lrados//" libmultipath/checkers/Makefile
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
		SYSTEMD=$(get_systemd_pv) \
		unitdir="$(systemd_get_systemunitdir)" \
		libudevdir='${prefix}'/"$(get_udevdir)" \
		install

	newinitd "${FILESDIR}"/rc-multipathd multipathd
	newinitd "${FILESDIR}"/multipath.rc multipath

	einstalldocs
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "If you need multipath on your system, you must"
		elog "add 'multipath' into your boot runlevel!"
	fi
}
