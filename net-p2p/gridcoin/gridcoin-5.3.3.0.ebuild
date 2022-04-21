# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic desktop systemd

DESCRIPTION="Gridcoin Proof-of-Stake based crypto-currency that rewards BOINC computation"
HOMEPAGE="https://gridcoin.us/"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gridcoin/Gridcoin-Research.git"
	EGIT_BRANCH="development"
	PATCHES="${FILESDIR}/gridcoin-9999-desktop.patch"
else
	SRC_URI="https://github.com/gridcoin/Gridcoin-Research/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/Gridcoin-Research-${PV}"
fi

LICENSE="MIT"
SLOT="0"

IUSE_GUI="dbus gui"
IUSE_DAEMON="daemon"
IUSE_OPTIONAL="bench +boinc debug +hardened libraries pic qrcode static test upnp utils"
IUSE="${IUSE_GUI} ${IUSE_DAEMON} ${IUSE_OPTIONAL}"

RESTRICT="!test? ( test )"

REQUIRED_USE="|| ( daemon gui ) dbus? ( gui ) qrcode? ( gui )"

RDEPEND="
	acct-group/gridcoin
	acct-user/gridcoin
	>=dev-libs/boost-1.73.0:=
	dev-libs/libevent
	>=dev-libs/libzip-1.3.0:=
	>=dev-libs/openssl-1.1.1d:=
	net-misc/curl
	sys-libs/db:5.3[cxx]
	boinc? ( sci-misc/boinc )
	dbus? ( dev-qt/qtdbus:5 )
	gui? (
		dev-qt/linguist-tools:5
		dev-qt/qtcharts:5
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
	)
	qrcode? ( media-gfx/qrencode )
	upnp? ( >=net-libs/miniupnpc-1.9.20140401 )
	utils? ( net-p2p/bitcoin-cli dev-util/bitcoin-tx )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	BDB_VER="$(best_version sys-libs/db:5.3)"
	export BDB_CFLAGS="-I${ESYSROOT}/usr/include/db${BDB_VER:12:3}"
	export BDB_LIBS="-ldb_cxx-${BDB_VER:12:3}"
	append-flags -Wa,--noexecstack
	econf \
		$(use_enable bench) \
		$(use_enable debug) \
		$(use_enable hardened) \
		$(use_enable static) \
		$(use_enable test tests) \
		$(use_with daemon) \
		$(use_with dbus qtdbus) \
		$(use_with gui gui qt5) \
		$(use_with libraries libs) \
		$(use_with pic) \
		$(use_with qrcode qrencode) \
		$(use_with upnp miniupnpc) \
		$(use_with utils)
}

src_install() {
	# Live package is called staging and should *only* be used for testing purposes
	local suffix=""
	if [[ ${PV} == 9999 ]]; then
		local suffix="-staging"
	fi

	if use daemon; then
			newbin src/gridcoinresearchd gridcoinresearchd${suffix}
			newman doc/gridcoinresearchd.1 gridcoinresearchd${suffix}.1
			newinitd "${FILESDIR}"/gridcoin${suffix}.init gridcoin${suffix}
	fi
	if use gui; then
		newbin src/qt/gridcoinresearch gridcoinresearch${suffix}
		newman doc/gridcoinresearch.1 gridcoinresearch${suffix}.1
		newmenu contrib/gridcoinresearch.desktop gridcoinresearch${suffix}.desktop
		for size in 16 22 24 32 48 64 128 256 ; do
			newicon -s "${size}" "share/icons/hicolor/${size}x${size}/apps/gridcoinresearch.png" gridcoinresearch${suffix}.png
		done
		newicon -s scalable "share/icons/hicolor/scalable/apps/gridcoinresearch.svg" gridcoinresearch${suffix}.svg
	 fi

	systemd_dounit "${FILESDIR}"/gridcoin${suffix}.service
	newinitd "${FILESDIR}"/gridcoin${suffix}.init gridcoin${suffix}

	dodoc README.md CHANGELOG.md doc/build-unix.md

	diropts -o${PN} -g${PN}
	keepdir /var/lib/${PN}/.GridcoinResearch/
	newconfd "${FILESDIR}"/gridcoinresearch.conf gridcoinresearch
	fowners gridcoin:gridcoin /etc/conf.d/gridcoinresearch
	fperms 0660 /etc/conf.d/gridcoinresearch
	dosym -r /etc/conf.d/gridcoinresearch /var/lib/${PN}/.GridcoinResearch/gridcoinresearch.conf
}

pkg_postinst() {
	if use debug; then
		ewarn "You have enabled debug flags and macros during compilation."
		ewarn "For these to be useful, you should also have Portage retain debug symbols."
		ewarn "See https://wiki.gentoo.org/wiki/Debugging on configuring your environment"
		ewarn "and set your desired FEATURES before (re-)building this package."
	fi
	if [[ ${PV} == 9999 ]]; then
		ewarn "NB: This branch is only intended for debugging on the gridcoin testnet!"
		ewarn "	Only proceed if you know what you are doing."
		ewarn "	Testnet users must join Slack at https://teamgridcoin.slack.com #testnet"
		ewarn "\nAll generated binaries, services, and desktop files have the suffix '-staging'."
	fi
	elog "The daemon can be found at /usr/bin/gridcoinresearchd"
	use gui && elog "The graphical wallet can be found at /usr/bin/gridcoinresearch"
	elog
	elog "You need to configure this node with a few basic details to do anything"
	elog "useful with gridcoin. The wallet configuration file is located at:"
	elog "	/etc/conf.d/gridcoinresearch"
	elog "The wiki for this configuration file is located at:"
	elog "	http://wiki.gridcoin.us/Gridcoinresearch_config_file"
	elog
	if use boinc; then
		elog "To run your wallet as a researcher you should add gridcoin user to boinc group."
		elog "Run as root:"
		elog "gpasswd -a gridcoin boinc"
		elog
	fi
}
