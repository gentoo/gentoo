# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils gnome.org mono

DESCRIPTION="Tasky is a simple task management app (TODO list) for the Linux Desktop"
HOMEPAGE="https://live.gnome.org/Tasque"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+rememberthemilk +sqlite hiveminder debug"

RDEPEND=">=dev-dotnet/gtk-sharp-2.12.7-r5
	>=dev-dotnet/gnome-sharp-2.24.0
	>=dev-dotnet/notify-sharp-0.4.0_pre20080912
	>=dev-dotnet/ndesk-dbus-0.6
	>=dev-dotnet/ndesk-dbus-glib-0.4
	sqlite? ( dev-db/sqlite:3 )
	"

DEPEND="${RDEPEND}"

pkg_setup() {
	BACKEND=false
	for usef in sqlite hiveminder rememberthemilk
	do
		use $usef && BACKEND=true
	done
	if [[ "${BACKEND}" != "true" ]]
	then
		eerror "You must select one of the following backends by enabling their useflag:"
		eerror "sqlite		( uses a local, file-backed database to keep track of your TODO list )"
		eerror "rememberthemilk	( integrates with www.rememberthemilk.com )"
		eerror "hiveminder		( integrates with www.hiveminder.com )"
		die "Please select a backend"
	fi
}

src_configure() {
	#https://bugzilla.gnome.org/show_bug.cgi?id=568910
	export	GTK_DOTNET_20_LIBS=" " \
		GTK_DOTNET_20_CFLAGS=" "
	econf	--disable-backend-icecore \
		--disable-backend-eds \
		--disable-appindicator \
		--enable-backend-rtm \
		$(use_enable sqlite backend-sqlite) \
		$(use_enable hiveminder backend-hiveminder) \
		$(use_enable debug)
}

src_install() {
	make DESTDIR="${D}" install || die "emake failed"
	dodoc NEWS TODO README AUTHORS || die "docs installation failed"
	mv_command="cp -pPR" mono_multilib_comply
}
