# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools desktop flag-o-matic systemd toolchain-funcs

DESCRIPTION="Multi-network P2P application written in Ocaml, with Gtk, web & telnet interface"
HOMEPAGE="http://mldonkey.sourceforge.net/ https://github.com/ygrek/mldonkey"
SRC_URI="https://github.com/ygrek/mldonkey/releases/download/release-${PV//./-}-2/${P}-2.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86"

IUSE="bittorrent doc fasttrack gd gnutella gtk guionly magic +ocamlopt upnp"

REQUIRED_USE="guionly? ( gtk )"

RDEPEND="dev-lang/perl
	dev-ml/camlp4:=
	gd? ( media-libs/gd:2=[truetype] )
	gtk? (
		dev-libs/glib:2
		dev-ml/lablgtk:2=[svg]
		gnome-base/librsvg:2
		media-libs/libpng:=
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2
		x11-libs/libX11
		x11-libs/pango
	)
	guionly? (
		dev-libs/glib:2
		dev-ml/lablgtk:2=[svg]
		gnome-base/librsvg:2
		media-libs/libpng:=
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:2
		x11-libs/libX11
		x11-libs/pango
	)
	magic? ( sys-apps/file )
	upnp? (
		net-libs/libnatpmp
		net-libs/miniupnpc:=
	)
	!guionly? ( acct-user/p2p )
	app-arch/bzip2
	sys-libs/zlib
"
# Can't yet use newer OCaml
# -unsafe-string usage:
# https://github.com/ygrek/mldonkey/issues/46
DEPEND="${RDEPEND}
	<dev-lang/ocaml-4.10:=[ocamlopt?]
	bittorrent? (
		|| (
			<dev-lang/ocaml-4.06[ocamlopt?]
			dev-ml/num
		)
	)"

RESTRICT="!ocamlopt? ( strip )"

PATCHES=( "${FILESDIR}/cpp17-byte-namespace.patch" )

S="${WORKDIR}/${P}-2"

pkg_setup() {
	if use gtk; then
		echo ""
		einfo "If the compile with gui fails, and you have updated Ocaml"
		einfo "recently, you may have forgotten that you need to run"
		einfo "/usr/portage/dev-lang/ocaml/files/ocaml-rebuild.sh"
		einfo "to learn which ebuilds you need to recompile"
		einfo "each time you update Ocaml to a different version"
		einfo "see the Ocaml ebuild for details"
		echo ""
	fi

	# dev-lang/ocaml creates its own objects but calls gcc for linking, which will
	# results in relocations if gcc wants to create a PIE executable
	if gcc-specs-pie ; then
		append-ldflags -nopie
		ewarn "Ocaml generates its own native asm, you're using a PIE compiler"
		ewarn "We have appended -nopie to ocaml build options"
		ewarn "because linking an executable with pie while the objects are not pic will not work"
	fi
}

src_prepare() {
	cd config || die
	eautoconf
	cd .. || die
	if ! use ocamlopt; then
		sed -i -e "s/ocamlopt/idontwantocamlopt/g" "${S}/config/configure" || die "failed to disable ocamlopt"
	fi

	default
}

src_configure() {
	local myconf=()

	if use gtk; then
		myconf+=( --enable-gui=newgui2 )
	else
		myconf+=( --disable-gui )
	fi

	if use guionly; then
		myconf+=( --disable-multinet --disable-donkey )
	fi

	local my_extra_libs
	if use gd; then
		my_extra_libs="-lpng"
	fi

	econf LIBS="${my_extra_libs}"\
		--sysconfdir=/etc/mldonkey \
		--sharedstatedir=/var/mldonkey \
		--localstatedir=/var/mldonkey \
		--enable-checks \
		--disable-batch \
		$(use_enable bittorrent) \
		$(use_enable fasttrack) \
		$(use_enable gnutella) \
		$(use_enable gnutella gnutella2) \
		$(use_enable gd) \
		$(use_enable magic) \
		$(use_enable upnp upnp-natpmp) \
		--disable-force-upnp-natpmp \
		${myconf[@]}
}

src_compile() {
	export OCAMLRUNPARAM="l=256M"
	emake -j1 # Upstream bug #48

	if ! use guionly; then
		emake utils
	fi
}

src_install() {
	local myext i
	use ocamlopt || myext=".byte"
	if ! use guionly; then
		for i in mlnet mld_hash get_range copysources subconv; do
			newbin "${i}${myext}" "${i}"
		done
		use bittorrent && newbin "make_torrent${myext}" make_torrent

		systemd_dounit "${FILESDIR}/${PN}.service"
		newconfd "${FILESDIR}/mldonkey.confd" mldonkey
		newinitd "${FILESDIR}/mldonkey.initd" mldonkey
	fi

	if use gtk; then
		for i in mlgui mlguistarter; do
			newbin "${i}${myext}" "${i}"
		done
		make_desktop_entry mlgui "MLDonkey GUI" mldonkey "Network;P2P"
		newicon "${S}"/packages/rpm/mldonkey-icon-48.png "${PN}.png"
	fi

	if use doc ; then
		docompress -x "/usr/share/doc/${PF}/scripts" "/usr/share/doc/${PF}/html"

		dodoc distrib/ChangeLog distrib/*.txt docs/*.txt docs/*.tex docs/*.pdf docs/developers/*.{txt,tex}

		docinto scripts
		dodoc distrib/{kill_mldonkey,mldonkey_command,mldonkey_previewer,make_buginfo}

		docinto html
		dodoc docs/*.html

		docinto html/images
		dodoc docs/images/*
	fi
}

pkg_postinst() {
	if [ -f /etc/conf.d/mldonkey ] && grep -qE "^(BASEDIR|SUBDIR|LOW_DOWN|LOW_UP|HIGH_DOWN|HIGH_UP|SERVER|PORT|TELNET_PORT|USERNAME|PASSWORD|MLDONKEY_TIMEOUT)=" /etc/conf.d/mldonkey; then
		ewarn "The following settings are deprecated and will be ignored,"
		ewarn "please remove them from /etc/conf.d/mldonkey:"
		ewarn "LOW_DOWN LOW_UP HIGH_DOWN HIGH_UP SERVER PORT TELNET_PORT USERNAME PASSWORD MLDONKEY_TIMEOUT"
	fi
}
