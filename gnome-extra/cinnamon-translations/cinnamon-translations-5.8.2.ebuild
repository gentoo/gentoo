# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PLOCALES="aa af am an ar ary as ast ay az be be@latin ber bg bn bn_IN br bs ca ca@valencia crh cs csb cy da de dz el en@shaw en_AU en_CA en_GB en_IE en_NZ en_ZA eo es es_AR et eu fa fi fil fo fr fr_CA frp fur fy ga gd gl gu ha he hi hr hsb hu hy ia id ie ig is it ja jv ka kab kk km kn ko ksw ku ky la li lmo lo lt lv mai mg mi mk ml mn mnw mo mr ms my nap nb nds ne nl nn no nso oc om or pa pap pl ps pt pt_BR qu ro ru rue rw sa sc sco shn si sk sl so sq sr sr@ijekavian sr@ijekavianlatin sr@latin sv sw szl ta te tg th tk tl tlh tpi tr ts tt ug uk ur uz uz@cyrillic vi wa xh yi yo zgh zh_CN zh_HK zh_TW zu"

inherit plocale

DESCRIPTION="Translation data for Cinnamon"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/cinnamon-translations"
SRC_URI="https://github.com/linuxmint/cinnamon-translations/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

BDEPEND="sys-devel/gettext"

src_configure() { :; }

src_install() {
	# Cannot run before since locales are not in the expected place for this to work
	plocale_find_changes "${S}"/usr/share/locale "" ""

	install_locale() {
		insinto /usr/share/locale
		doins -r usr/share/locale/${1}
	}
	plocale_for_each_locale install_locale
}
