# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils gnome.org mono

DESCRIPTION="Simple task management app (TODO list) for the Linux Desktop"
HOMEPAGE="https://live.gnome.org/Tasque"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+rememberthemilk +sqlite hiveminder debug"

LANGS="ca ca@valencia cs da de el en_GB eo es et fi fr gl hu id it ja lv nb nds nl pl
	pt pt_BR ro ru sl sr sr@latin sv th tr zh_CN zh_TW"

REQUIRED_USE="|| ( rememberthemilk sqlite hiveminder )"

RDEPEND=">=dev-dotnet/gtk-sharp-2.12.7-r5
	>=dev-dotnet/notify-sharp-0.4.0_pre20080912
	dev-dotnet/dbus-sharp:1.0
	dev-dotnet/dbus-sharp-glib:1.0
	sqlite? ( dev-db/sqlite:3 )"
DEPEND="${RDEPEND}"

src_configure() {
	econf	--disable-backend-icecore \
		--disable-backend-eds \
		--disable-appindicator \
		--enable-backend-rtm \
		$(use_enable sqlite backend-sqlite) \
		$(use_enable hiveminder backend-hiveminder) \
		$(use_enable debug)
}

src_install() {
	default
	mv_command="cp -pPR" mono_multilib_comply

	if [[ -n ${LINGUAS+set} ]]; then
		einfo "Cleaning up locales..."
		for lang in ${LANGS}; do
			if has ${lang} ${LINGUAS}; then
				einfo "- keeping ${lang}"
			else
				rm -Rf "${D}"/usr/share/locale/"${lang}" || die
			fi
		done
	fi
}
