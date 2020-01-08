# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Some nice themes for Sawfish"
HOMEPAGE="http://themes.freshmeat.net/"
THEME_URI="http://download.freshmeat.net/themes/"
SRC_URI="
	${THEME_URI}/absolutedarkness/absolutedarkness-0.30.tar.gz
	${THEME_URI}/adaptblue/adaptblue-0.30.tar.gz
	${THEME_URI}/ampullacu/ampullacu-0.30.tar.gz
	${THEME_URI}/antarctic_/antarctic_-0.30.tar.gz
	${THEME_URI}/aquagraphite_/aquagraphite_-0.30.tar.gz
	${THEME_URI}/aquaified/aquaified-0.30.tar.gz
	${THEME_URI}/aquax/aquax-0.30.tar.gz
	${THEME_URI}/arctic___/arctic___-0.30.tar.gz
	${THEME_URI}/bedoon_ism_bordered/bedoon_ism_bordered-0.30.tar.gz
	${THEME_URI}/blueberry/blueberry-0.30.tar.gz
	${THEME_URI}/c2h8/c2h8-0.30.tar.gz
	${THEME_URI}/circles/circles-0.30.tar.gz
	${THEME_URI}/clean__/clean__-0.30.tar.gz
	${THEME_URI}/coral/coral-0.30.tar.gz
	${THEME_URI}/cyrus__/cyrus__-0.30.tar.gz
	${THEME_URI}/dirtchamber/dirtchamber-0.30.tar.gz
	${THEME_URI}/doublehelix/doublehelix-0.30.tar.gz
	${THEME_URI}/dragdome/dragdome-0.30.tar.gz
	${THEME_URI}/eazel/eazel-0.30.tar.gz
	${THEME_URI}/eazelblue/eazelblue-0.30.tar.gz
	${THEME_URI}/flatgnome/flatgnome-0.30.tar.gz
	${THEME_URI}/flatsaw/flatsaw-0.30.tar.gz
	${THEME_URI}/friday/friday-0.30.tar.gz
	${THEME_URI}/gets/gets-0.30.tar.gz
	${THEME_URI}/glass__/glass__-0.30.tar.gz
	${THEME_URI}/gleam/gleam-0.30.tar.gz
	${THEME_URI}/greyneon/greyneon-0.30.tar.gz
	${THEME_URI}/latem/latem-0.30.tar.gz
	${THEME_URI}/lines_/lines_-0.30.tar.gz
	${THEME_URI}/liquidgraphite/liquidgraphite-0.30.tar.gz
	${THEME_URI}/lunatic/lunatic-0.30.tar.gz
	${THEME_URI}/marble___/marble___-0.30.tar.gz
	${THEME_URI}/moonice_/moonice_-0.30.tar.gz
	${THEME_URI}/mozillamodern_/mozillamodern_-0.30.tar.gz
	${THEME_URI}/omonster/omonster-0.30.tar.gz
	${THEME_URI}/openstep/openstep-0.30.tar.gz
	${THEME_URI}/origami/origami-0.30.tar.gz
	${THEME_URI}/platinum_/platinum_-0.30.tar.gz
	${THEME_URI}/qnx11/qnx11-0.30.tar.gz
	${THEME_URI}/roman_/roman_-0.30.tar.gz
	${THEME_URI}/sawbench/sawbench-0.30.tar.gz
	${THEME_URI}/shinyfusion/shinyfusion-0.30.tar.gz
	${THEME_URI}/simpleelegant_/simpleelegant_-0.30.tar.gz
	${THEME_URI}/stirling/stirling-0.30.tar.gz
	${THEME_URI}/stpflat/stpflat-0.30.tar.gz
	http://themes.freshmeat.net/redir/surgical/29103/url_tgz/surgical-0.1.tar.gz
	${THEME_URI}/titanium__/titanium__-0.30.tar.gz
	${THEME_URI}/triangle/triangle-0.30.tar.gz
	${THEME_URI}/twm/twm-0.30.tar.gz
	${THEME_URI}/ultraclean/ultraclean-0.30.tar.gz
	${THEME_URI}/whistlerk_/whistlerk_-0.30.tar.gz
	${THEME_URI}/win98/win98-0.30.tar.gz"

LICENSE="GPL-2"
SLOT="1"
KEYWORDS="alpha ~amd64 ia64 ppc ~ppc64 sparc x86"
IUSE=""

RDEPEND="=x11-wm/sawfish-1*"

S="${WORKDIR}"

src_compile() { :; }

src_install() {
	insinto /usr/share/sawfish/themes
	doins -r .
}
