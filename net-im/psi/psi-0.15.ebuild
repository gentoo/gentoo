# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/psi/psi-0.15.ebuild,v 1.6 2015/02/22 18:41:23 mgorny Exp $

EAPI=5

PLOCALES="be cs de fr it ja pl pt_BR ru sl sv ur_PK zh_TW"
inherit eutils l10n multilib gnome2-utils qt4-r2 readme.gentoo

DESCRIPTION="Qt4 Jabber client, with Licq-like interface"
HOMEPAGE="http://psi-im.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

for LNG in ${PLOCALES}; do
	SRC_URI="${SRC_URI}
		linguas_${LNG}? ( http://psi-im.org/download/lang/${PN}_${LNG}.qm -> ${P}_${LNG}.qm )"
done

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="crypt dbus debug doc jingle spell ssl xscreensaver whiteboarding"
RESTRICT="test"

RDEPEND="app-arch/unzip
	>=dev-qt/qtgui-4.7:4[qt3support]
	>=dev-qt/qt3support-4.7:4
	>=app-crypt/qca-2.0.2:2[qt4(+)]
	x11-libs/libX11
	dbus? ( >=dev-qt/qtdbus-4.7:4 )
	spell? ( >=app-text/enchant-1.3.0 )
	xscreensaver? ( x11-libs/libXScrnSaver )
	whiteboarding? ( dev-qt/qtsvg:4 )
	|| ( >=sys-libs/zlib-1.2.5.1-r2[minizip] <sys-libs/zlib-1.2.5.1-r1 )"

DEPEND="${RDEPEND}
	sys-devel/qconf
	doc? ( app-doc/doxygen )"

PDEPEND="crypt? ( app-crypt/qca:2[gpg] )
	jingle? ( net-im/psimedia
		app-crypt/qca:2[openssl] )
	ssl? ( app-crypt/qca:2[openssl] )"

DOC_CONTENTS='Psi+ support(USE="extras") was removed from ebuild since 0.15'
FORCE_PRINT_ELOG=1

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.14-drop-debug-cflags.patch"
	epatch_user

	qconf || die "Failed to create ./configure."
}

src_configure() {
	# unable to use econf because of non-standard configure script
	# disable growl as it is a MacOS X extension only
	local confcmd="./configure
			--prefix=/usr
			--qtdir=/usr
			--disable-growl
			$(use dbus || echo '--disable-qdbus')
			$(use debug && echo '--debug')
			$(use spell || echo '--disable-aspell')
			$(use spell || echo '--disable-enchant')
			$(use xscreensaver || echo '--disable-xss')
			$(use whiteboarding && echo '--enable-whiteboarding')"

	echo ${confcmd}
	${confcmd} || die "configure failed"
	# Makefile is not always created...
	[[ ! -f Makefile ]] && die "configure failed"
}

src_compile() {
	eqmake4

	emake

	if use doc; then
		cd doc || die
		mkdir -p api || die # 259632
		emake api_public
	fi
}

src_install() {
	install_locale() {
		newins "${DISTDIR}/${P}_${1}.qm" "${PN}_${1}.qm"
	}

	emake INSTALL_ROOT="${D}" install
	rm "${D}"/usr/share/psi/{COPYING,README} || die

	readme.gentoo_create_doc

	# this way the docs will be installed in the standard gentoo dir
	newdoc iconsets/roster/README README.roster
	newdoc iconsets/system/README README.system
	newdoc certs/README README.certs
	dodoc README

	if use doc; then
		cd doc || die
		dohtml -r api
	fi

	# install translations
	insinto /usr/share/${PN}
	l10n_for_each_locale_do install_locale
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	readme.gentoo_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
