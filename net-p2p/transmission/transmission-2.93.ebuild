# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools flag-o-matic gnome2-utils qmake-utils systemd user xdg-utils

DESCRIPTION="A Fast, Easy and Free BitTorrent client"
HOMEPAGE="http://www.transmissionbt.com/"
SRC_URI="https://github.com/transmission/transmission-releases/raw/master/${P}.tar.xz"

# web/LICENSE is always GPL-2 whereas COPYING allows either GPL-2 or GPL-3 for the rest
# transmission in licenses/ is for mentioning OpenSSL linking exception
# MIT is in several libtransmission/ headers
LICENSE="|| ( GPL-2 GPL-3 Transmission-OpenSSL-exception ) GPL-2 MIT"
SLOT=0
IUSE="ayatana gtk libressl lightweight systemd qt5 xfs"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux"

RDEPEND=">=dev-libs/libevent-2.0.10:=
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	net-libs/libnatpmp
	>=net-libs/miniupnpc-1.7:=
	>=net-misc/curl-7.16.3[ssl]
	sys-libs/zlib:=
	gtk? (
		>=dev-libs/dbus-glib-0.100
		>=dev-libs/glib-2.32:2
		>=x11-libs/gtk+-3.4:3
		ayatana? ( >=dev-libs/libappindicator-0.4.90:3 )
		)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		)
	systemd? ( >=sys-apps/systemd-209:= )"
DEPEND="${RDEPEND}
	>=dev-libs/glib-2.32
	dev-util/intltool
	sys-devel/gettext
	virtual/os-headers
	virtual/pkgconfig
	qt5? ( dev-qt/linguist-tools:5 )
	xfs? ( sys-fs/xfsprogs )"

REQUIRED_USE="ayatana? ( gtk )"

DOCS=( AUTHORS NEWS qt/README.txt )

PATCHES=(
	"${FILESDIR}"/libsystemd.patch
)

src_prepare() {
	sed -i -e '/CFLAGS/s:-ggdb3::' configure.ac || die

	# Trick to avoid automagic dependency
	if ! use ayatana ; then
		sed -i -e '/^LIBAPPINDICATOR_MINIMUM/s:=.*:=9999:' configure.ac || die
	fi

	# http://trac.transmissionbt.com/ticket/4324
	sed -i -e 's|noinst\(_PROGRAMS = $(TESTS)\)|check\1|' libtransmission/Makefile.am || die

	# Prevent m4_copy error when running aclocal
	# m4_copy: won't overwrite defined macro: glib_DEFUN
	rm m4/glib-gettext.m4 || die

	default
	eautoreconf
}

src_configure() {
	export ac_cv_header_xfs_xfs_h=$(usex xfs)

	# https://bugs.gentoo.org/577528
	append-lfs-flags

	econf \
		--enable-external-natpmp \
		$(use_enable lightweight) \
		$(use_with systemd systemd-daemon) \
		$(use_with gtk)

	if use qt5; then
		pushd qt >/dev/null || die
		eqmake5 qtr.pro
		popd >/dev/null || die
	fi
}

src_compile() {
	emake

	if use qt5; then
		emake -C qt
		$(qt5_get_bindir)/lrelease qt/translations/*.ts || die
	fi
}

src_install() {
	default

	rm "${ED%/}"/usr/share/transmission/web/LICENSE || die

	newinitd "${FILESDIR}"/transmission-daemon.initd.10 transmission-daemon
	newconfd "${FILESDIR}"/transmission-daemon.confd.4 transmission-daemon
	systemd_dounit daemon/transmission-daemon.service
	systemd_install_serviced "${FILESDIR}"/transmission-daemon.service.conf

	if use qt5; then
		pushd qt >/dev/null || die
		emake INSTALL_ROOT="${ED%/}"/usr install

		domenu transmission-qt.desktop

		local res
		for res in 16 22 24 32 48 64 72 96 128 192 256; do
			doicon -s ${res} icons/hicolor/${res}x${res}/transmission-qt.png
		done
		doicon -s scalable icons/hicolor/scalable/transmission-qt.svg

		insinto /usr/share/qt5/translations
		doins translations/*.qm
		popd >/dev/null || die
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update

	enewgroup transmission
	enewuser transmission -1 -1 /var/lib/transmission transmission

	if [[ ! -e "${EROOT%/}"/var/lib/transmission ]]; then
		mkdir -p "${EROOT%/}"/var/lib/transmission || die
		chown transmission:transmission "${EROOT%/}"/var/lib/transmission || die
	fi

	elog "If you use transmission-daemon, please, set 'rpc-username' and"
	elog "'rpc-password' (in plain text, transmission-daemon will hash it on"
	elog "start) in settings.json file located at /var/lib/transmission/config or"
	elog "any other appropriate config directory."
	elog
	elog "Since µTP is enabled by default, transmission needs large kernel buffers for"
	elog "the UDP socket. You can append following lines into /etc/sysctl.conf:"
	elog " net.core.rmem_max = 4194304"
	elog " net.core.wmem_max = 1048576"
	elog "and run sysctl -p"
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
