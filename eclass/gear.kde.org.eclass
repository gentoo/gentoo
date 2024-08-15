# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gear.kde.org.eclass
# @MAINTAINER:
# kde@gentoo.org
# @SUPPORTED_EAPIS: 8
# @PROVIDES: kde.org
# @BLURB: Support eclass for KDE Gear packages.
# @DESCRIPTION:
# This eclass extends kde.org.eclass for KDE Gear release group to assemble
# default SRC_URI for tarballs, set up git-r3.eclass for stable/master branch
# versions or restrict access to unreleased (packager access only) tarballs
# in Gentoo KDE overlay.
#
# This eclass unconditionally inherits kde.org.eclass and all its public
# variables and helper functions (not phase functions) may be considered as
# part of this eclass's API.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_GEAR_KDE_ORG_ECLASS} ]]; then
_GEAR_KDE_ORG_ECLASS=1

# @ECLASS_VARIABLE: KDE_PV_UNRELEASED
# @INTERNAL
# @DESCRIPTION:
# For proper description see kde.org.eclass manpage.
KDE_PV_UNRELEASED=( )

inherit kde.org

HOMEPAGE="https://apps.kde.org/"

# @ECLASS_VARIABLE: KDE_ORG_SCHEDULE_URI
# @INTERNAL
# @DESCRIPTION:
# For proper description see kde.org.eclass manpage.
KDE_ORG_SCHEDULE_URI+="/KDE_Gear_${PV:0:5}_Schedule"

# @ECLASS_VARIABLE: _KDE_SRC_URI
# @INTERNAL
# @DESCRIPTION:
# Helper variable to construct release group specific SRC_URI.
_KDE_SRC_URI="mirror://kde/"

if [[ ${KDE_BUILD_TYPE} == live ]]; then
	if [[ ${PV} == ??.??.49.9999 ]]; then
		EGIT_BRANCH="release/$(ver_cut 1-2)"
	fi
elif [[ -z ${KDE_ORG_COMMIT} ]]; then
	case ${PV} in
		??.??.[6-9]? )
			_KDE_SRC_URI+="unstable/release-service/${PV}/src/"
			RESTRICT+=" mirror"
			;;
		*) _KDE_SRC_URI+="stable/release-service/${PV}/src/" ;;
	esac

	SRC_URI="${_KDE_SRC_URI}${KDE_ORG_TAR_PN}-${PV}.tar.xz"
fi

# list of applications ported to KF6 in SLOT=6 having to block SLOT=5
if $(ver_test -gt 24.01.75); then
	case ${PN} in
		akonadi | \
		akonadi-calendar | \
		akonadi-contacts | \
		akonadi-import-wizard | \
		akonadi-mime | \
		akonadi-notes | \
		akonadi-search | \
		akonadiconsole | \
		akregator | \
		analitza | \
		ark | \
		audiocd-kio | \
		baloo-widgets | \
		blinken | \
		bomber | \
		bovo | \
		calendarjanitor | \
		calendarsupport | \
		colord-kde | \
		dolphin | \
		dolphin-plugins-dropbox | \
		dolphin-plugins-git | \
		dolphin-plugins-mercurial | \
		dolphin-plugins-mountiso | \
		dolphin-plugins-subversion | \
		dragon | \
		elisa | \
		eventviews | \
		ffmpegthumbs | \
		filelight | \
		granatier | \
		grantlee-editor | \
		grantleetheme | \
		gwenview | \
		incidenceeditor | \
		isoimagewriter | \
		juk | \
		kaccounts-integration | \
		kaccounts-providers | \
		kaddressbook | \
		kajongg | \
		kalarm | \
		kalgebra | \
		kamera | \
		kanagram | \
		kapman | \
		kapptemplate | \
		kate | \
		kate-addons | \
		kate-lib | \
		katomic | \
		kbackup | \
		kblackbox | \
		kblocks | \
		kbounce | \
		kbreakout | \
		kbruch | \
		kcachegrind | \
		kcalc | \
		kcalutils | \
		kcharselect | \
		kcolorchooser | \
		kcron | \
		kde-dev-utils | \
		kdebugsettings | \
		kdeconnect | \
		kdenetwork-filesharing | \
		kdenlive | \
		kdepim-addons | \
		kdepim-runtime | \
		kdf | \
		kdialog | \
		kdiamond | \
		keditbookmarks | \
		kfind | \
		kfourinline | \
		kgeography | \
		kget | \
		kgoldrunner | \
		kgpg | \
		khangman | \
		khelpcenter | \
		kidentitymanagement | \
		kigo | \
		killbots | \
		kimap | \
		kiriki | \
		kiten | \
		kitinerary | \
		kjumpingcube | \
		kldap | \
		kleopatra | \
		klettres | \
		klickety | \
		klines | \
		kmag | \
		kmahjongg | \
		kmail | \
		kmail-account-wizard | \
		kmailtransport | \
		kmbox | \
		kmime | \
		kmines | \
		kmousetool | \
		kmouth | \
		knavalbattle | \
		knetwalk | \
		knights | \
		knotes | \
		kolf | \
		kollision | \
		konqueror | \
		konquest | \
		konsole | \
		konsolekalendar | \
		kontact | \
		kontactinterface | \
		kontrast | \
		konversation | \
		korganizer | \
		kopeninghours | \
		kosmindoormap | \
		kpat | \
		kpimtextedit | \
		kpkpass | \
		kpmcore | \
		kpublictransport | \
		kreversi | \
		krfb | \
		kruler | \
		kshisen | \
		ksirk | \
		ksmtp | \
		ksnakeduel | \
		kspaceduel | \
		ksquares | \
		ksudoku | \
		ksystemlog | \
		kteatime | \
		ktimer | \
		ktorrent | \
		ktuberling | \
		kturtle | \
		kubrick | \
		kwalletmanager | \
		kweather | \
		kwordquiz | \
		kwrite | \
		libgravatar | \
		libkeduvocdocument | \
		libkdegames | \
		libkdepim | \
		libkleo | \
		libkmahjongg | \
		libksieve | \
		libktnef | \
		libktorrent | \
		lskat | \
		mailcommon | \
		mailimporter | \
		markdownpart | \
		mbox-importer | \
		merkuro | \
		messagelib | \
		okular | \
		palapeli | \
		parley | \
		partitionmanager | \
		picmi | \
		pim-data-exporter | \
		pim-sieve-editor | \
		pimcommon | \
		skanpage | \
		spectacle | \
		svgpart | \
		sweeper | \
		yakuake | \
		zanshin)
			RDEPEND+=" !${CATEGORY}/${PN}:5" ;;
		*) ;;
	esac
fi

# list of applications ported to KF6 post-24.02 in SLOT=6 having to block SLOT=5
if $(ver_test -gt 24.04.75); then
	case ${PN} in
		audex | \
		itinerary | \
		kio-perldoc | \
		kolourpaint | \
		signon-kwallet-extension)
			RDEPEND+=" !${CATEGORY}/${PN}:5" ;;
		*) ;;
	esac
fi

fi
