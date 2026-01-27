# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

DESCRIPTION="Easy way to install DLLs needed to work around problems in Wine"
HOMEPAGE="https://github.com/Winetricks/winetricks https://wiki.winehq.org/Winetricks"

if [[ ${PV} == *99999999* ]] ; then
	EGIT_REPO_URI="https://github.com/Winetricks/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Winetricks/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="gui rar"
RESTRICT="test"

RDEPEND="
	app-arch/cabextract
	|| (
		>=app-arch/7zip-24.09[symlink(+)]
		app-arch/p7zip
	)
	app-arch/unzip
	net-misc/wget
	virtual/wine
	x11-misc/xdg-utils
	gui? ( || (
		gnome-extra/zenity
		kde-apps/kdialog:*
	) )
	rar? ( app-arch/unrar )
"

src_unpack() {
	case ${PV} in
		*99999999*) git-r3_src_unpack ;&
		*) default ;;
	esac
}

src_install() {
	default

	if ! use gui; then
		rm -r "${ED}"/usr/share/{applications,icons} || die
	fi
}
