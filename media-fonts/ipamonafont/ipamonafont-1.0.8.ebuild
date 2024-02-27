# Copyright 2005-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_P="opfc-ModuleHP-1.1.1_withIPAMonaFonts-${PV}"

DESCRIPTION="Hacked version of IPA fonts, which is suitable for browsing 2ch"
HOMEPAGE="https://web.archive.org/web/20190326123924/http://www.geocities.jp/ipa_mona/"
SRC_URI="http://distcache.freebsd.org/local-distfiles/hrs/${MY_P}.tar.gz"
S="${WORKDIR}"

LICENSE="grass-ipafonts mplus-fonts public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"
IUSE=""
RESTRICT="mirror"

FONT_SUFFIX="ttf"
FONT_S="${S}/${MY_P}/fonts"
