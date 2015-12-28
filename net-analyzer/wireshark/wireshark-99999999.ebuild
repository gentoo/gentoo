# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils fcaps flag-o-matic git-r3 multilib qmake-utils qt4-r2 user

DESCRIPTION="A network protocol analyzer formerly known as ethereal"
HOMEPAGE="http://www.wireshark.org/"
EGIT_REPO_URI="https://code.wireshark.org/review/wireshark"

LICENSE="GPL-2"
SLOT="0/${PV}"
KEYWORDS=""
IUSE="
	adns androiddump +caps cpu_flags_x86_sse4_2 crypt doc doc-pdf geoip +gtk3
	ipv6 kerberos lua +netlink +pcap portaudio +qt4 qt5 sbc selinux smi ssl
	tfshark zlib
"
REQUIRED_USE="
	ssl? ( crypt )
	?? ( qt4 qt5 )
"

GTK_COMMON_DEPEND="
	x11-libs/gdk-pixbuf
	x11-libs/pango
	x11-misc/xdg-utils
"
CDEPEND="
	>=dev-libs/glib-2.14:2
	netlink? ( dev-libs/libnl:3 )
	adns? ( >=net-dns/c-ares-1.5 )
	crypt? ( dev-libs/libgcrypt:0 )
	caps? ( sys-libs/libcap )
	geoip? ( dev-libs/geoip )
	gtk3? (
		${GTK_COMMON_DEPEND}
		x11-libs/gtk+:3
	)
	kerberos? ( virtual/krb5 )
	lua? ( >=dev-lang/lua-5.1:* )
	pcap? ( net-libs/libpcap )
	portaudio? ( media-libs/portaudio )
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4[accessibility]
		x11-misc/xdg-utils
		)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtprintsupport:5
		dev-qt/qtwidgets:5
		x11-misc/xdg-utils
	)
	sbc? ( media-libs/sbc )
	smi? ( net-libs/libsmi )
	ssl? ( net-libs/gnutls )
	zlib? ( sys-libs/zlib !=sys-libs/zlib-1.2.4 )
"
# We need perl for `pod2html`.  The rest of the perl stuff is to block older
# and broken installs. #455122
DEPEND="
	${CDEPEND}
	dev-lang/perl
	!<virtual/perl-Pod-Simple-3.170
	!<perl-core/Pod-Simple-3.170
	doc? (
		app-doc/doxygen
		app-text/asciidoc
		dev-libs/libxml2
		dev-libs/libxslt
		doc-pdf? ( dev-java/fop )
		www-client/lynx
	)
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"
RDEPEND="
	${CDEPEND}
	gtk3? ( virtual/freedesktop-icon-theme )
	qt4? ( virtual/freedesktop-icon-theme )
	qt5? ( virtual/freedesktop-icon-theme )
	selinux? ( sec-policy/selinux-wireshark )
"

pkg_setup() {
	enewgroup wireshark
}

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-1.6.13-ldflags.patch \
		"${FILESDIR}"/${PN}-1.11.0-oldlibs.patch \
		"${FILESDIR}"/${PN}-99999999-pkgconfig.patch \
		"${FILESDIR}"/${PN}-1.99.8-qtchooser.patch \
		"${FILESDIR}"/${PN}-2.1.0-sse4_2.patch

	epatch_user

	eautoreconf
}

src_configure() {
	local myconf

	# Workaround bug #213705. If krb5-config --libs has -lcrypto then pass
	# --with-ssl to ./configure. (Mimics code from acinclude.m4).
	if use kerberos; then
		case $(krb5-config --libs) in
			*-lcrypto*)
				ewarn "Kerberos was built with ssl support: linkage with openssl is enabled."
				ewarn "Note there are annoying license incompatibilities between the OpenSSL"
				ewarn "license and the GPL, so do your check before distributing such package."
				myconf+=( "--with-ssl" )
				;;
		esac
	fi

	# Enable wireshark binary with any supported GUI toolkit (bug #473188)
	if use gtk3 || use qt4 || use qt5; then
		myconf+=( "--enable-wireshark" )
	else
		myconf+=( "--disable-wireshark" )
	fi

	use qt4 && export QT_MIN_VERSION=4.6.0

	if use qt5; then
		export QT_MIN_VERSION=5.3.0
		append-cxxflags -fPIC -DPIC
	fi

	# Hack around inability to disable doxygen/fop doc generation
	use doc || export ac_cv_prog_HAVE_DOXYGEN=false
	use doc-pdf || export ac_cv_prog_HAVE_FOP=false

	if use qt4; then
		myconf+=" --with-qt=4"
	elif use qt5; then
		myconf+=" --with-qt=5"
	else
		myconf+=" --with-qt=no"
	fi

	# dumpcap requires libcap
	# --disable-profile-build bugs #215806, #292991, #479602
	econf \
		$(use androiddump && use pcap && echo --enable-androiddump-use-libpcap=yes) \
		$(use_enable androiddump) \
		$(use_enable ipv6) \
		$(use_enable tfshark) \
		$(use_with adns c-ares) \
		$(use_with caps libcap) \
		$(use_with crypt gcrypt) \
		$(use_with geoip) \
		$(use_with gtk3) \
		$(use_with kerberos krb5) \
		$(use_with lua) \
		$(use_with pcap dumpcap-group wireshark) \
		$(use_with pcap) \
		$(use_with portaudio) \
		$(usex qt4 MOC=$(qt4_get_bindir)/moc '') \
		$(usex qt4 RCC=$(qt4_get_bindir)/rcc '') \
		$(usex qt4 UIC=$(qt4_get_bindir)/uic '') \
		$(usex qt5 MOC=$(qt5_get_bindir)/moc '') \
		$(usex qt5 RCC=$(qt5_get_bindir)/rcc '') \
		$(usex qt5 UIC=$(qt5_get_bindir)/uic '') \
		$(use_with sbc) \
		$(use_with smi libsmi) \
		$(use_with ssl gnutls) \
		$(use_with zlib) \
		$(usex netlink --with-libnl=3 --without-libnl) \
		$(usex cpu_flags_x86_sse4_2 --enable-sse4_2 '') \
		--disable-profile-build \
		--disable-usr-local \
		--disable-warnings-as-errors \
		--sysconfdir="${EPREFIX}"/etc/wireshark \
		--without-adns \
		${myconf[@]}
}

src_compile() {
	default
	if use doc; then
		use doc-pdf && addpredict "/root/.java"
		emake -j1 -C docbook
	fi
}

src_install() {
	default
	if use doc; then
		dohtml -r docbook/{release-notes.html,ws{d,u}g_html{,_chunked}}
		if use doc-pdf; then
			insinto /usr/share/doc/${PF}/pdf/
			doins docbook/{developer,user}-guide-{a4,us}.pdf docbook/release-notes.pdf
		fi
	fi

	# FAQ is not required as is installed from help/faq.txt
	dodoc AUTHORS ChangeLog NEWS README{,.bsd,.linux,.macos,.vmware} \
		doc/{randpkt.txt,README*}

	# install headers
	local wsheader
	for wsheader in \
		color.h \
		config.h \
		epan/*.h \
		epan/crypt/*.h \
		epan/dfilter/*.h \
		epan/dissectors/*.h \
		epan/ftypes/*.h \
		epan/wmem/*.h \
		register.h \
		wiretap/*.h \
		ws_symbol_export.h \
		wsutil/*.h
	do
		insinto /usr/include/wireshark/$( dirname ${wsheader} )
		doins ${wsheader}
	done

	#with the above this really shouldn't be needed, but things may be looking in wiretap/ instead of wireshark/wiretap/
	insinto /usr/include/wiretap
	doins wiretap/wtap.h

	if use gtk3 || use qt4 || use qt5; then
		local c d
		for c in hi lo; do
			for d in 16 32 48; do
				insinto /usr/share/icons/${c}color/${d}x${d}/apps
				newins image/${c}${d}-app-wireshark.png wireshark.png
			done
		done
		for d in 16 24 32 48 64 128 256 ; do
			insinto /usr/share/icons/hicolor/${d}x${d}/mimetypes
			newins image/WiresharkDoc-${d}.png application-vnd.tcpdump.pcap.png
		done
	fi

	if use gtk3; then
		domenu wireshark.desktop
	fi

	if use qt4 || use qt5; then
		sed \
			-e '/Exec=/s|wireshark|&-qt|g' \
			-e 's|^Name.*=Wireshark|& (Qt)|g' \
			wireshark.desktop > wireshark-qt.desktop \
			|| die
		domenu wireshark-qt.desktop
	fi

	prune_libtool_files
}

pkg_postinst() {
	# Add group for users allowed to sniff.
	enewgroup wireshark

	if use pcap; then
		fcaps -o 0 -g wireshark -m 4710 -M 0710 \
			cap_dac_read_search,cap_net_raw,cap_net_admin \
			"${EROOT}"/usr/bin/dumpcap
	fi

	ewarn "NOTE: To capture traffic with wireshark as normal user you have to"
	ewarn "add yourself to the wireshark group. This security measure ensures"
	ewarn "that only trusted users are allowed to sniff your traffic."
}
