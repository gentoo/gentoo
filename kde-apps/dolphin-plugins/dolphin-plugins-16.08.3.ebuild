# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="false"
inherit kde5

DESCRIPTION="Extra Dolphin plugins"
KEYWORDS="~amd64 ~x86"
IUSE="bazaar dropbox git mercurial subversion"

# FIXME: required in root CMakeLists.txt, but:
# kdelibs4support only required by git?
# kxmlgui, qtnetwork only required by dropbox?
COMMON_DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep kxmlgui)
	$(add_kdeapps_dep dolphin)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtwidgets)
	git? (
		$(add_frameworks_dep kcompletion)
		$(add_frameworks_dep kconfig)
		$(add_frameworks_dep ktextwidgets)
	)
	mercurial? (
		$(add_frameworks_dep kcompletion)
		$(add_frameworks_dep kconfig)
		$(add_frameworks_dep kservice)
		$(add_frameworks_dep ktexteditor)
		$(add_frameworks_dep ktextwidgets)
		$(add_frameworks_dep kwidgetsaddons)
	)
"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
"
RDEPEND="${COMMON_DEPEND}
	$(add_kdeapps_dep kompare)
	bazaar? ( dev-vcs/bzr )
	dropbox? ( net-misc/dropbox-cli )
	git? ( dev-vcs/git )
	subversion? ( dev-vcs/subversion )
"

src_configure() {
	local mycmakeargs=(
		-DBUILD_bazaar=$(usex bazaar)
		-DBUILD_dropbox=$(usex dropbox)
		-DBUILD_git=$(usex git)
		-DBUILD_hg=$(usex mercurial)
		-DBUILD_svn=$(usex subversion)
	)

	kde5_src_configure
}

src_install() {
	{ use bazaar || use dropbox || use git || use subversion || use mercurial; } && kde5_src_install
}

pkg_postinst() {
	if ! use bazaar && ! use dropbox && ! use git && ! use subversion && ! use mercurial; then
		einfo
		einfo "You have disabled all plugin use flags. If you want to have vcs"
		einfo "integration in dolphin, enable those of your needs."
		einfo
	fi
}
