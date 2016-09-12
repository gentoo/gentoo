# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils systemd toolchain-funcs udev

DESCRIPTION="Device mapper target autoconfig"
HOMEPAGE="http://christophe.varoqui.free.fr/"
COMMIT_ID='e165b73a16fc9027aa3306df40052038c175be1b'
SRC_URI="http://git.opensvc.com/?p=multipath-tools/.git;a=snapshot;h=${COMMIT_ID};sf=tgz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="systemd"

RDEPEND=">=sys-fs/lvm2-2.02.45
	>=virtual/udev-171
	dev-libs/libaio
	dev-libs/userspace-rcu
	sys-libs/readline:*
	systemd? ( sys-apps/systemd )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${COMMIT_ID:0:7}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.2-makefile.patch
	"${FILESDIR}"/${PN}-0.6.2-ignore-modprobe-failures.patch
)

get_systemd_pv() {
	use systemd && \
		$(tc-getPKG_CONFIG) --modversion systemd
}

src_compile() {
	# LIBDM_API_FLUSH involves grepping files in /usr/include,
	# so force the test to go the way we want #411337.
	emake \
		LIBDM_API_FLUSH=1 CC="$(tc-getCC)" SYSTEMD="$(get_systemd_pv)"
}

src_install() {
	local udevdir="$(get_udevdir)"

	dodir /sbin /usr/share/man/man{5,8}
	emake \
		DESTDIR="${D}" \
		SYSTEMD=$(get_systemd_pv) \
		unitdir="$(systemd_get_systemunitdir)" \
		libudevdir='${prefix}'/"${udevdir}" \
		install

	newinitd "${FILESDIR}"/rc-multipathd multipathd
	newinitd "${FILESDIR}"/multipath.rc multipath

	dodoc README ChangeLog
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "If you need multipath on your system, you must"
		elog "add 'multipath' into your boot runlevel!"
	fi
}
