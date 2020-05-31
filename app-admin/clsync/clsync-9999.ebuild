# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/clsync/clsync.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/clsync/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

inherit autotools linux-info systemd

DESCRIPTION="Live sync tool based on inotify, written in GNU C"
HOMEPAGE="https://github.com/clsync/clsync http://ut.mephi.ru/oss/clsync"
LICENSE="GPL-3+"
SLOT="0"
IUSE="apidoc +caps +clsync cluster control-socket cgroups doc debug
examples extra-debug extra-hardened gio +hardened +highload-locks
+inotify mhash namespaces seccomp socket-library static-libs"

REQUIRED_USE="
	|| ( clsync socket-library )
	|| ( gio inotify )
	mhash? ( cluster )
	seccomp? ( caps )
"
BDEPEND="
	virtual/pkgconfig
	apidoc? ( app-doc/doxygen[dot] )
"
DEPEND="
	caps? ( sys-libs/libcap )
	cgroups? ( dev-libs/libcgroup )
	clsync? ( dev-libs/glib:2 )
	mhash? ( app-crypt/mhash )
"
RDEPEND="${DEPEND}
	!app-doc/clsync-docs
	!dev-libs/libclsync
"

pkg_pretend() {
	if use clsync; then
		use inotify && CONFIG_CHECK+=" ~INOTIFY_USER"
		use namespaces && CONFIG_CHECK="~NAMESPACES ~UTS_NS ~IPC_NS ~USER_NS ~PID_NS ~NET_NS"
		use seccomp && CONFIG_CHECK+=" ~SECCOMP"
		check_extra_config
	fi
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
		--enable-debug=${debug_level} \
		--enable-paranoid=${harden_level} \
		--without-bsm \
		--without-kqueue \
		$(use_enable caps capabilities) \
		$(use_enable clsync) \
		$(use_enable cluster) \
		$(use_enable control-socket socket) \
		$(use_enable highload-locks) \
		$(use_enable namespaces unshare) \
		$(use_enable seccomp) \
		$(use_enable socket-library) \
		$(use_with cgroups libcgroup) \
		$(use_with gio gio lib) \
		$(use_with inotify inotify native) \
		$(use_with mhash)
}

src_compile() {
	default
	if use apidoc; then
		doxygen .doxygen || die "doxygen failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install

	if use socket-library; then
		find "${ED}" -name "*.la" -delete
		use static-libs || find "${ED}" -name "*.a" -delete || die "failed to remove static libs"
	fi

	if use clsync; then
		newinitd "${FILESDIR}/${PN}.initd" "${PN}"
		newconfd "${FILESDIR}/${PN}.confd" "${PN}"

		# filter rules and sync scripts are supposed to be here
		insinto /etc/${PN}
		newins "${FILESDIR}/${PN}.conf" "${PN}.conf"
		keepdir /etc/${PN}

		systemd_dounit "examples/clsync@.service"
	fi

	if use doc; then
		dodoc -r DEVELOPING NOTES PROTOCOL SHORTHANDS TODO doc/devel/*
	else
		rm "${ED}/usr/share/doc/${PF}/"{DEVELOPING,LICENSE,PROTOCOL,TODO}* || die
	fi
	use apidoc && dodoc -r doc/doxygen/html
	if ! use examples; then
		rm -r "${ED}/usr/share/doc/${PF}/examples" || die
	fi
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
	einfo "USE=\"caps cgroups extra-hardened namespaces seccomp\""

	if use socket-library; then
		einfo
		einfo "clsync instances you are going to use _must_ be compiled"
		einfo "with control-socket support"
	fi
}
