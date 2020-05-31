# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools linux-info systemd

DESCRIPTION="Live sync tool based on inotify, written in GNU C"
HOMEPAGE="https://github.com/clsync/clsync http://ut.mephi.ru/oss/clsync"
SRC_URI="https://github.com/clsync/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+caps cluster control-socket cgroups debug extra-debug
extra-hardened gio hardened +highload-locks +inotify mhash
namespaces seccomp"

REQUIRED_USE="
	|| ( gio inotify )
	extra-debug? ( debug )
	extra-hardened? ( hardened )
	mhash? ( cluster )
	seccomp? ( caps )
"
BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	dev-libs/glib:2
	caps? ( sys-libs/libcap )
	cgroups? ( dev-libs/libcgroup )
	mhash? ( app-crypt/mhash )
"
RDEPEND="${DEPEND}
	~app-doc/clsync-docs-${PV}
"

pkg_pretend() {
	use inotify && CONFIG_CHECK+=" ~INOTIFY_USER"
	use namespaces && CONFIG_CHECK="~NAMESPACES ~UTS_NS ~IPC_NS ~USER_NS ~PID_NS ~NET_NS"
	use seccomp && CONFIG_CHECK+=" ~SECCOMP"
	check_extra_config
}

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	local harden_level=0
	use hardened && harden_level=1
	use extra-hardened && harden_level=2

	local debug_level=0
	use debug && debug_level=1
	use extra-debug && debug_level=2

	econf \
		--disable-socket-library \
		--enable-clsync \
		--enable-debug=${debug_level} \
		--enable-paranoid=${harden_level} \
		--without-bsm \
		--without-kqueue \
		$(use_enable caps capabilities) \
		$(use_enable cluster) \
		$(use_enable control-socket socket) \
		$(use_enable highload-locks) \
		$(use_enable namespaces unshare) \
		$(use_enable seccomp) \
		$(use_with cgroups libcgroup) \
		$(use_with gio gio lib) \
		$(use_with inotify inotify native) \
		$(use_with mhash)
}

src_install() {
	emake DESTDIR="${D}" install

	# docs go into clsync-docs
	rm -rf "${ED}/usr/share/doc" || die

	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	# filter rules and sync scripts are supposed to be here
	insinto /etc/${PN}
	newins "${FILESDIR}/${PN}.conf" "${PN}.conf"
	keepdir /etc/${PN}

	systemd_dounit "examples/clsync@.service"
}

pkg_postinst() {
	einfo "${PN} is just a convenient way to run synchronization tools on live data,"
	einfo "it doesn't copy data itself, so you need to install software to do actual"
	einfo "data transfer. Usually net-misc/rsync is a good choise, but ${PN} is"
	einfo "is flexible enough to use any user tool, see manual page for details."
	einfo
	einfo "${PN} init script can be multiplexed, to use symlink init script to"
	einfo "othername and use conf.d/othername to configure it."
	einfo
	einfo "If you're interested in improved security, enable"
	einfo "USE=\"caps cgroups hardened namespaces seccomp\""
}
