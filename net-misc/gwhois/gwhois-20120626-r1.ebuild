# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit readme.gentoo-r1

MY_P="${P/_p/.}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Generic whois"
HOMEPAGE="https://julijane.de/gwhois/"
# Debian is still maintaining it
#SRC_URI="http://gwhois.de/gwhois/${MY_P/-/_}.tar.gz"

DEBIAN_VER="1.2"
SRC_URI="mirror://debian/pool/main/g/${PN}/${MY_P/-/_}-${DEBIAN_VER}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 sparc ~x86"
IUSE=""

RDEPEND="
	www-client/lynx
	net-misc/curl
	dev-lang/perl:=
	dev-perl/libwww-perl
	dev-perl/Net-LibIDN
"
DEPEND=""

DOC_CONTENTS="
	See included gwhois.xinetd for an example on how to
	use gwhois as a whois proxy using xinetd.
	Just copy gwhois.xinetd to /etc/xinetd.d/gwhois
	and reload xinetd.
"

src_install() {
	dodir /etc/gwhois
	insinto /etc/gwhois
	doins pattern
	dobin gwhois
	doman gwhois.1
	dodoc TODO "${FILESDIR}/gwhois.xinetd" README.RIPE
	readme.gentoo_create_doc
}

pkg_postinst() {
	if [ -f /etc/gwhois/pattern.ripe ]; then
		ewarn ""
		ewarn "Will move old /etc/gwhois/pattern.ripe to removethis-pattern.ripe"
		ewarn "as it causes malfunction with this version."
		ewarn "If you did not modify the file, just remove it."
		ewarn ""
		mv /etc/gwhois/pattern.ripe /etc/gwhois/removethis-pattern.ripe
	fi
	readme.gentoo_print_elog
}
