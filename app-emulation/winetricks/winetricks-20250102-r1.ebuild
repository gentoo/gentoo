# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WTG="winetricks-gentoo-2012.11.24"
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

SRC_URI+=" gui? ( https://dev.gentoo.org/~chiitoo/distfiles/${WTG}.tar.bz2 )"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="gui rar test"
RESTRICT="!test? ( test )"

# dev-util/shellcheck is not available for x86
RESTRICT+=" x86? ( test )"

BDEPEND="
	test? (
		dev-python/bashate
		dev-util/checkbashisms
		|| (
			dev-util/shellcheck-bin
			dev-util/shellcheck
		)
	)
"
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

# Test targets include syntax checks only, not the "heavy duty" tests
# that would require a lot of disk space, as well as network access.

# This uses a non-standard "Wine" category, which is provided by
# '/etc/xdg/menus/applications-merged/wine.menu' from the
# 'app-emulation/wine-desktop-common' package.
# https://bugs.gentoo.org/451552
QA_DESKTOP_FILE="usr/share/applications/winetricks.desktop"

src_unpack() {
	case ${PV} in
		*99999999*) git-r3_src_unpack ;&
		*) default ;;
	esac
}

src_test() {
	./tests/shell-checks || die "Test(s) failed."
}

src_install() {
	default

	if ! use gui; then
		rm -r "${ED}"/usr/share/{applications,icons} || die
	fi
}
