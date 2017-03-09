# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

MY_P="${PN}${PV/./-}"
DESCRIPTION="Simple Perl/Tk GUI to manage a small certification authority"
HOMEPAGE="https://opsec.eu/src/tinyca/"
SRC_URI="http://tinyca.sm-zone.net/${MY_P}.tar.bz2"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="libressl"
LANGS="en de cs es sv"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	dev-perl/Locale-gettext
	>=virtual/perl-MIME-Base64-2.12
	>=dev-perl/gtk2-perl-1.072"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.7.3-compositefix.patch"
	"${FILESDIR}/${P}-openssl-1.patch"
	"${FILESDIR}/${P}-perl-5.18.patch"
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	sed -i -e 's:./lib:/usr/share/tinyca/lib:g' \
		-e 's:./templates:/usr/share/tinyca/templates:g' \
		-e 's:./locale:/usr/share/locale:g' "${S}/tinyca2" || die
}

src_compile() {
	emake -C po
}

locale_install() {
	insinto /usr/share/locale/$@/LC_MESSAGES/
	doins locale/$@/LC_MESSAGES/tinyca2.mo
}

src_install() {
	einstalldocs
	newbin tinyca2 tinyca
	insinto /usr/share/tinyca/lib
	doins lib/*.pm
	insinto /usr/share/tinyca/lib/GUI
	doins lib/GUI/*.pm
	insinto /usr/share/tinyca/templates
	doins templates/*
	insinto /usr/share/
	strip-linguas ${LANGS}
	local l
	for l in ${LANGS}; do
		if [ "$l" != "en" ]; then
			use linguas_$l && locale_install $l
		fi
	done
}
