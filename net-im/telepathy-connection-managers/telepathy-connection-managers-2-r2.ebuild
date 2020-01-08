# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Meta-package for Telepathy Connection Managers"
HOMEPAGE="https://telepathy.freedesktop.org/"
SRC_URI=""
LICENSE="metapackage"
SLOT="0"

KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-linux"

IUSE="gadu icq +irc meanwhile msn sip sipe +xmpp yahoo steam zeroconf"

DEPEND=""
# These version support the 0.24.0 Telepathy specification
# They work with Mission Control 5.14
RDEPEND="
	gadu? (
		net-im/pidgin[gadu]
		net-voip/telepathy-haze
	)
	icq? ( >=net-voip/telepathy-haze-0.6.0 )
	irc? ( >=net-irc/telepathy-idle-0.1.14 )
	meanwhile? (
		net-im/pidgin[meanwhile]
		net-voip/telepathy-haze
	)
	msn? ( >=net-voip/telepathy-gabble-0.16.4 )
	sip? ( >=net-voip/telepathy-rakia-0.7.4 )
	sipe? ( >=x11-plugins/pidgin-sipe-1.17.1[telepathy] )
	steam? (
		x11-plugins/pidgin-opensteamworks
		net-voip/telepathy-haze
	)
	xmpp? ( >=net-voip/telepathy-gabble-0.16.4 )
	yahoo? ( >=net-voip/telepathy-haze-0.6.0 )
	zeroconf? ( >=net-voip/telepathy-salut-0.8.1 )
"
