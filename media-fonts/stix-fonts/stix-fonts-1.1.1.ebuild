# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Comprehensive OpenType font set of mathematical symbols and alphabets"
HOMEPAGE="https://www.stixfonts.org/"
SRC_URI="mirror://sourceforge/${PN/-/}/STIXv${PV}-word.zip"
S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE=""

RESTRICT="binchecks strip test"

BDEPEND="app-arch/unzip"

DOCS=( "STIX Font ${PV} Release Documentation.pdf" )

FONT_CONF=( "${FILESDIR}"/61-stix.conf )
FONT_SUFFIX="otf"
FONT_S="${S}/Fonts/STIX-Word"
