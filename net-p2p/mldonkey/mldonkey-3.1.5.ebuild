# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
WANT_AUTOCONF=2.5

inherit flag-o-matic eutils autotools toolchain-funcs user

IUSE="bittorrent doc fasttrack gd gnutella gtk guionly magic +ocamlopt"

DESCRIPTION="A multi-network P2P application written in Ocaml, with its own Gtk GUI, web and telnet interface"
HOMEPAGE="http://mldonkey.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ppc ~sparc x86 ~x86-fbsd"

RDEPEND="dev-lang/perl
	dev-ml/camlp4:=
	guionly? ( >=gnome-base/librsvg-2.4.0
			>=dev-ml/lablgtk-2.6 )
	gtk? ( >=gnome-base/librsvg-2.4.0
			>=dev-ml/lablgtk-2.6[svg] )
	gd? ( >=media-libs/gd-2.0.28[truetype] )
	magic? ( sys-apps/file )"

DEPEND="${RDEPEND}
	>=dev-lang/ocaml-3.10.2[ocamlopt?]"

MLUSER="p2p"

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
	cd "${S}"/config
	eautoconf
	cd "${S}"
	use ocamlopt || sed -i -e "s/ocamlopt/idontwantocamlopt/g" "${S}/config/configure" || die "failed to disable ocamlopt"
	epatch "${FILESDIR}/ocaml4.patch"
}

src_configure() {
	# the dirs are not (yet) used, but it doesn't hurt to specify them anyway

	# onlygui	Disable all nets support, build only chosen GUI

	if use gtk || use guionly; then
		myconf="--enable-gui=newgui2"
	else
		myconf="--disable-gui"
	fi

	if use guionly; then
		myconf="${myconf} --disable-multinet --disable-donkey"
	fi

	cd "${S}"

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
		${myconf}
}

src_compile() {
	export OCAMLRUNPARAM="l=256M"
	emake

	if ! use guionly; then
		emake utils
	fi;
}

src_install() {
	local myext=""
	use ocamlopt || myext=".byte"
	use ocamlopt || export STRIP_MASK="*/bin/*"
	if ! use guionly; then
		for i in mlnet mld_hash get_range copysources subconv; do
			newbin $i$myext $i
		done
		use bittorrent && newbin make_torrent$myext make_torrent

		newconfd "${FILESDIR}/mldonkey.confd-2.8" mldonkey
		fperms 600 /etc/conf.d/mldonkey
		newinitd "${FILESDIR}/mldonkey.initd" mldonkey
	fi

	if use gtk; then
		for i in mlgui mlguistarter; do
			newbin $i$myext $i
		done
		make_desktop_entry mlgui "MLDonkey GUI" mldonkey "Network;P2P"
		newicon "${S}"/packages/rpm/mldonkey-icon-48.png ${PN}.png
	fi

	if use doc ; then
		cd "${S}"/distrib
		dodoc ChangeLog *.txt

		insinto /usr/share/doc/${PF}/scripts
		doins kill_mldonkey mldonkey_command mldonkey_previewer make_buginfo

		cd "${S}"/docs
		dodoc *.txt *.tex *.pdf
		dohtml *.html

		cd "${S}"/docs/developers
		dodoc *.txt *.tex

		cd "${S}"/docs/images
		insinto /usr/share/doc/${PF}/html/images
		doins *
	fi
}

pkg_preinst() {
	if ! use guionly; then
		enewuser ${MLUSER} -1 -1 /home/p2p users
	fi
}

pkg_postinst() {
	if ! use guionly; then
		echo
		einfo "If you want to start MLDonkey as a system service, use"
		einfo "the /etc/init.d/mldonkey script. To control bandwidth, use"
		einfo "the 'slow' and 'fast' arguments. Be sure to have a look at"
		einfo "/etc/conf.d/mldonkey also."
		echo
	else
		echo
		einfo "Simply run mlgui to start the chosen MLDonkey gui."
		einfo "It puts its config files into ~/.mldonkey"
	fi
}
