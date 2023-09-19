# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg

if [[ ${PV} == "99999999" ]] ; then
	EGIT_REPO_URI="https://github.com/Winetricks/${PN}.git"
	inherit git-r3
	SRC_URI=""
else
	SRC_URI="https://github.com/Winetricks/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

wtg="winetricks-gentoo-2012.11.24"

SRC_URI="${SRC_URI}
	gtk? ( https://dev.gentoo.org/~chiitoo/distfiles/${wtg}.tar.bz2 )
	kde? ( https://dev.gentoo.org/~chiitoo/distfiles/${wtg}.tar.bz2 )
"

DESCRIPTION="Easy way to install DLLs needed to work around problems in Wine"
HOMEPAGE="https://github.com/Winetricks/winetricks https://wiki.winehq.org/Winetricks"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="gtk kde rar test"
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
DEPEND=""
RDEPEND="${DEPEND}
	app-arch/cabextract
	app-arch/p7zip
	app-arch/unzip
	net-misc/wget
	virtual/wine
	x11-misc/xdg-utils
	gtk? ( gnome-extra/zenity )
	kde? ( kde-apps/kdialog )
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
	if [[ ${PV} == "99999999" ]]; then
		git-r3_src_unpack

		if use gtk || use kde; then
			unpack ${wtg}.tar.bz2
		fi

	else
		default
	fi
}

src_test() {
	./tests/shell-checks || die "Test(s) failed."
}

src_install() {
	default

	if ! use gtk && ! use kde; then
		rm -r "${ED}"/usr/share/applications || die
		rm -r "${ED}"/usr/share/icons || die
	fi
}
