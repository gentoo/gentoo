# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/ipaex/ipaex-002.01.ebuild,v 1.2 2015/04/28 09:59:36 yngwin Exp $

EAPI=5
inherit font

MY_P="IPAexfont${PV/.}"

DESCRIPTION="Japanese IPA extended TrueType fonts"
HOMEPAGE="http://ipafont.ipa.go.jp/"
SRC_URI="http://dl.ipafont.ipa.go.jp/IPAexfont/${MY_P}.zip"

LICENSE="IPAfont"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""
RESTRICT="binchecks strip test"

DEPEND="app-arch/unzip"
RDEPEND=""
S="${WORKDIR}/${MY_P}"

FONT_SUFFIX="ttf"
FONT_S="${S}"
FONT_CONF=( "${FILESDIR}"/66-${PN}.conf )
DOCS=( "Readme_${MY_P}.txt" )
