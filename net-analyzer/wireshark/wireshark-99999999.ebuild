# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )
inherit fcaps flag-o-matic git-r3 multilib python-any-r1 qmake-utils user xdg-utils cmake-utils

DESCRIPTION="A network protocol analyzer formerly known as ethereal"
HOMEPAGE="https://www.wireshark.org/"
EGIT_REPO_URI="https://code.wireshark.org/review/wireshark"
LICENSE="GPL-2"

SLOT="0/${PV}"
KEYWORDS=""
IUSE="
	androiddump bcg729 brotli +capinfos +captype ciscodump +dftest doc dpauxmon
	+dumpcap +editcap http2 kerberos libxml2 lua lz4 maxminddb +mergecap
	+minizip +netlink +plugins plugin-ifdemo +pcap +qt5 +randpkt +randpktdump
	+reordercap sbc selinux +sharkd smi snappy spandsp sshdump ssl sdjournal
	+text2pcap tfshark +tshark +udpdump zlib
"
S=${WORKDIR}/${P/_/}

CDEPEND="
	>=dev-libs/glib-2.32:2
	>=net-dns/c-ares-1.5
	dev-libs/libgcrypt:0
	bcg729? ( media-libs/bcg729 )
	brotli? ( app-arch/brotli )
	ciscodump? ( >=net-libs/libssh-0.6 )
	filecaps? ( sys-libs/libcap )
	http2? ( net-libs/nghttp2 )
	kerberos? ( virtual/krb5 )
	libxml2? ( dev-libs/libxml2 )
	lua? ( >=dev-lang/lua-5.1:* )
	lz4? ( app-arch/lz4 )
	maxminddb? ( dev-libs/libmaxminddb )
	minizip? ( sys-libs/zlib[minizip] )
	netlink? ( dev-libs/libnl:3 )
	pcap? ( net-libs/libpcap )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
		x11-misc/xdg-utils
	)
	sbc? ( media-libs/sbc )
	sdjournal? ( sys-apps/systemd )
	smi? ( net-libs/libsmi )
	snappy? ( app-arch/snappy )
	spandsp? ( media-libs/spandsp )
	sshdump? ( >=net-libs/libssh-0.6 )
	ssl? ( net-libs/gnutls:= )
	zlib? ( sys-libs/zlib )
"
# We need perl for `pod2html`. The rest of the perl stuff is to block older
# and broken installs. #455122
DEPEND="
	${CDEPEND}
	${PYTHON_DEPS}
"
BDEPEND="
	dev-lang/perl
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-ruby/asciidoctor
	)
	qt5? (
		dev-qt/linguist-tools:5
	)
"
RDEPEND="
	${CDEPEND}
	qt5? ( virtual/freedesktop-icon-theme )
	selinux? ( sec-policy/selinux-wireshark )
"
REQUIRED_USE="
	plugin-ifdemo? ( plugins )
"
PATCHES=(
	"${FILESDIR}"/${PN}-2.4-androiddump.patch
	"${FILESDIR}"/${PN}-2.6.0-redhat.patch
	"${FILESDIR}"/${PN}-2.9.0-tfshark-libm.patch
	"${FILESDIR}"/${PN}-99999999-androiddump-wsutil.patch
	"${FILESDIR}"/${PN}-99999999-qtsvg.patch
	"${FILESDIR}"/${PN}-99999999-ui-needs-wiretap.patch
)

pkg_setup() {
	enewgroup wireshark
}

src_configure() {
	local mycmakeargs

	# Workaround bug #213705. If krb5-config --libs has -lcrypto then pass
	# --with-ssl to ./configure. (Mimics code from acinclude.m4).
	if use kerberos; then
		case $(krb5-config --libs) in
			*-lcrypto*)
				ewarn "Kerberos was built with ssl support: linkage with openssl is enabled."
				ewarn "Note there are annoying license incompatibilities between the OpenSSL"
				ewarn "license and the GPL, so do your check before distributing such package."
				mycmakeargs+=( -DENABLE_GNUTLS=$(usex ssl) )
				;;
		esac
	fi

	if use qt5; then
		export QT_MIN_VERSION=5.3.0
		append-cxxflags -fPIC -DPIC
	fi

	python_setup

	mycmakeargs+=(
		$(use androiddump && use pcap && echo -DEXTCAP_ANDROIDDUMP_LIBPCAP=yes)
		$(usex qt5 LRELEASE=$(qt5_get_bindir)/lrelease '')
		$(usex qt5 MOC=$(qt5_get_bindir)/moc '')
		$(usex qt5 RCC=$(qt5_get_bindir)/rcc '')
		$(usex qt5 UIC=$(qt5_get_bindir)/uic '')
		-DBUILD_androiddump=$(usex androiddump)
		-DBUILD_capinfos=$(usex capinfos)
		-DBUILD_captype=$(usex captype)
		-DBUILD_ciscodump=$(usex ciscodump)
		-DBUILD_dftest=$(usex dftest)
		-DBUILD_dpauxmon=$(usex dpauxmon)
		-DBUILD_dumpcap=$(usex dumpcap)
		-DBUILD_editcap=$(usex editcap)
		-DBUILD_mergecap=$(usex mergecap)
		-DBUILD_mmdbresolve=$(usex maxminddb)
		-DBUILD_randpkt=$(usex randpkt)
		-DBUILD_randpktdump=$(usex randpktdump)
		-DBUILD_reordercap=$(usex reordercap)
		-DBUILD_sdjournal=$(usex sdjournal)
		-DBUILD_sharkd=$(usex sharkd)
		-DBUILD_sshdump=$(usex sshdump)
		-DBUILD_text2pcap=$(usex text2pcap)
		-DBUILD_tfshark=$(usex tfshark)
		-DBUILD_tshark=$(usex tshark)
		-DBUILD_udpdump=$(usex udpdump)
		-DBUILD_wireshark=$(usex qt5)
		-DCMAKE_INSTALL_DOCDIR="${EROOT}/usr/share/doc/${PF}"
		-DDISABLE_WERROR=yes
		-DENABLE_BCG729=$(usex bcg729)
		-DENABLE_BROTLI=$(usex brotli)
		-DENABLE_CAP=$(usex filecaps caps)
		-DENABLE_GNUTLS=$(usex ssl)
		-DENABLE_KERBEROS=$(usex kerberos)
		-DENABLE_LIBXML2=$(usex libxml2)
		-DENABLE_LUA=$(usex lua)
		-DENABLE_LZ4=$(usex lz4)
		-DENABLE_MINIZIP=$(usex minizip)
		-DENABLE_NETLINK=$(usex netlink)
		-DENABLE_NGHTTP2=$(usex http2)
		-DENABLE_PCAP=$(usex pcap)
		-DENABLE_PLUGINS=$(usex plugins)
		-DENABLE_PLUGIN_IFDEMO=$(usex plugin-ifdemo)
		-DENABLE_SBC=$(usex sbc)
		-DENABLE_SMI=$(usex smi)
		-DENABLE_SNAPPY=$(usex snappy)
		-DENABLE_SPANDSP=$(usex spandsp)
		-DENABLE_ZLIB=$(usex zlib)
	)

	cmake-utils_src_configure
}

src_test() {
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install

	# FAQ is not required as is installed from help/faq.txt
	dodoc AUTHORS ChangeLog NEWS README* doc/randpkt.txt doc/README*

	# install headers
	insinto /usr/include/wireshark
	doins ws_diag_control.h ws_symbol_export.h \
		"${BUILD_DIR}"/config.h "${BUILD_DIR}"/version.h

	local dir dirs=(
		epan
		epan/crypt
		epan/dfilter
		epan/dissectors
		epan/ftypes
		epan/wmem
		wiretap
		wsutil
	)
	for dir in "${dirs[@]}"
	do
		insinto /usr/include/wireshark/${dir}
		doins ${dir}/*.h
	done

	#with the above this really shouldn't be needed, but things may be looking
	# in wiretap/ instead of wireshark/wiretap/
	insinto /usr/include/wiretap
	doins wiretap/wtap.h

	if use qt5; then
		local s
		for s in 16 32 48 64 128 256 512 1024; do
			insinto /usr/share/icons/hicolor/${s}x${s}/apps
			newins image/wsicon${s}.png wireshark.png
		done
		for s in 16 24 32 48 64 128 256 ; do
			insinto /usr/share/icons/hicolor/${s}x${s}/mimetypes
			newins image/WiresharkDoc-${s}.png application-vnd.tcpdump.pcap.png
		done
	fi
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update

	# Add group for users allowed to sniff.
	enewgroup wireshark
	chgrp wireshark "${EROOT}"/usr/bin/dumpcap

	if use dumpcap && use pcap; then
		fcaps -o 0 -g wireshark -m 4710 -M 0710 \
			cap_dac_read_search,cap_net_raw,cap_net_admin \
			"${EROOT}"/usr/bin/dumpcap
	fi

	ewarn "NOTE: To capture traffic with wireshark as normal user you have to"
	ewarn "add yourself to the wireshark group. This security measure ensures"
	ewarn "that only trusted users are allowed to sniff your traffic."
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
