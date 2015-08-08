# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

[[ ${PV} = *9999* ]] && VCS_ECLASS="git-2" || VCS_ECLASS=""
inherit autotools ${VCS_ECLASS}

DESCRIPTION="Simple FastCGI wrapper for CGI scripts (CGI support for nginx)"
HOMEPAGE="http://nginx.localdomain.pl/wiki/FcgiWrap"

LICENSE="BSD"
SLOT="0"
IUSE=""

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="git://github.com/gnosek/${PN}.git"

	KEYWORDS=""
else
	MY_REV="58ec209"
	#SRC_URI="http://download.github.com/gnosek-${P}-4-g${MY_REV}.tar.gz"
	SRC_URI="mirror://gentoo/${P}.tar.gz"
	S="${WORKDIR}/gnosek-${PN}-${MY_REV}"

	KEYWORDS="~amd64 ~x86"
fi

DEPEND="dev-libs/fcgi"
RDEPEND="${DEPEND}"

DOCS=( README.rst )

src_prepare() {
	sed -e "s/-Werror//" \
		-i configure.ac || die "sed failed"

	sed -e '/man8dir = $(DESTDIR)/s/@prefix@//' \
		-i Makefile.in || die "sed failed"

	eautoreconf
}

pkg_postinst() {
	einfo 'You may want to install www-servers/spawn-fcgi to use with fcgiwrap.'
}
