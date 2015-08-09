# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Metapackage containing all ready-to-use LeechCraft plugins"
HOMEPAGE="http://leechcraft.org/"

SLOT="0"
KEYWORDS=" ~amd64 ~x86"
LICENSE="GPL-3"
IUSE="de"

RDEPEND="
		~app-leechcraft/lc-blogique-${PV}
		~app-leechcraft/lc-eleeminator-${PV}
		~app-leechcraft/lc-popishu-${PV}
		~app-leechcraft/lc-monocle-${PV}
		~app-leechcraft/lc-hotstreams-${PV}
		~app-leechcraft/lc-lmp-${PV}
		~app-leechcraft/lc-lastfmscrobble-${PV}
		~app-leechcraft/lc-musiczombie-${PV}
		~app-leechcraft/lc-touchstreams-${PV}
		~app-leechcraft/lc-networkmonitor-${PV}
		~app-leechcraft/lc-azoth-${PV}
		~app-leechcraft/lc-advancednotifications-${PV}
		~app-leechcraft/lc-anhero-${PV}
		~app-leechcraft/lc-auscrie-${PV}
		~app-leechcraft/lc-core-${PV}
		~app-leechcraft/lc-cstp-${PV}
		~app-leechcraft/lc-dbusmanager-${PV}
		~app-leechcraft/lc-gacts-${PV}
		~app-leechcraft/lc-glance-${PV}
		~app-leechcraft/lc-historyholder-${PV}
		~virtual/leechcraft-notifier-${PV}
		~app-leechcraft/lc-knowhow-${PV}
		~app-leechcraft/lc-imgaste-${PV}
		~app-leechcraft/lc-lackman-${PV}
		~app-leechcraft/lc-launchy-${PV}
		~app-leechcraft/lc-lemon-${PV}
		~app-leechcraft/lc-liznoo-${PV}
		~app-leechcraft/lc-newlife-${PV}
		~app-leechcraft/lc-netstoremanager-${PV}
		~app-leechcraft/lc-otlozhu-${PV}
		~app-leechcraft/lc-qrosp-${PV}
		~app-leechcraft/lc-pintab-${PV}
		~app-leechcraft/lc-secman-${PV}
		~app-leechcraft/lc-scroblibre-${PV}
		~app-leechcraft/lc-summary-${PV}
		~app-leechcraft/lc-tabslist-${PV}
		~app-leechcraft/lc-tabsessmanager-${PV}
		~app-leechcraft/lc-aggregator-${PV}
		~app-leechcraft/lc-bittorrent-${PV}
		~app-leechcraft/lc-xproxy-${PV}
		~app-leechcraft/lc-vrooby-${PV}
		~virtual/leechcraft-trayarea-${PV}
		~app-leechcraft/lc-deadlyrics-${PV}
		~app-leechcraft/lc-dolozhee-${PV}
		~app-leechcraft/lc-poshuku-${PV}
		~app-leechcraft/lc-vgrabber-${PV}
		~app-leechcraft/lc-pogooglue-${PV}
		~app-leechcraft/lc-seekthru-${PV}
		~app-leechcraft/lc-tpi-${PV}
		~app-leechcraft/lc-gmailnotifier-${PV}
		~app-leechcraft/lc-nacheku-${PV}
		~app-leechcraft/lc-xtazy-${PV}
		~app-leechcraft/lc-htthare-${PV}
		de? (
			~app-leechcraft/lc-devmon-${PV}
			~app-leechcraft/lc-fenet-${PV}
			~app-leechcraft/lc-kbswitch-${PV}
			~app-leechcraft/lc-krigstask-${PV}
			~app-leechcraft/lc-laughty-${PV}
			~app-leechcraft/lc-mellonetray-${PV}
			~app-leechcraft/lc-sysnotify-${PV}
		)
		"
DEPEND=""
