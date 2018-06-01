# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PLOCALES="af am an ar as ast az be be@latin bg bn bn_IN br bs ca ca@valencia crh cs csb cy da de dz el en@shaw en_AU en_CA en_GB eo es es_AR et eu fa fi fil fo fr fr_CA frp fy ga gd gl gu he hi hr hu hy ia id ii is it ja jv ka kk km kn ko ksw ku ky la li lo lt lv mai mg mk ml mn mr ms my nb nds ne nl nn nso oc om or pa pap pl ps pt pt_BR ro ru rue rw sa sc sco shn si sk sl so sq sr sr@ijekavianlatin sr@latin sv sw ta te tg th tl tlh tpi tr ts tt ug uk ur uz uz@cyrillic vi wa xh yi zh_CN zh_HK zh_TW zu"

inherit l10n

DESCRIPTION="Translation data for Cinnamon"
HOMEPAGE="http://cinnamon.linuxmint.com/"
SRC_URI="https://github.com/linuxmint/cinnamon-translations/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">gnome-extra/cinnamon-settings-daemon-3.6"
RDEPEND="${DEPEND}"
RESTRICT="test" # tests are for upstream translators and need network access

src_configure() { :; }

src_install() {
	# Cannot run before since locales are not in the expected place for this to work
	l10n_find_plocales_changes "${S}"/usr/share/locale "" ""

	install_locale() {
		dodir /usr/share/locale
		insinto /usr/share/locale
		doins -r usr/share/locale/${1}
	}
	l10n_for_each_locale_do install_locale
}
