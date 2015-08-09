# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

[[ ${PV} = *9999* ]] && VCS_ECLASS="git" || VCS_ECLASS=""
inherit autotools systemd toolchain-funcs ${VCS_ECLASS}

DESCRIPTION="Simple FastCGI wrapper for CGI scripts (CGI support for nginx)"
HOMEPAGE="http://nginx.localdomain.pl/wiki/FcgiWrap"

LICENSE="BSD"
SLOT="0"
IUSE="systemd"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="git://github.com/gnosek/${PN}.git"

	KEYWORDS=""
else
	SRC_URI="https://github.com/gnosek/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm x86"
fi

RDEPEND="dev-libs/fcgi"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( README.rst )

src_prepare() {
	sed -e "s/-Werror//" \
		-i configure.ac || die "sed failed"

	sed -e '/man8dir = $(DESTDIR)/s/@prefix@//' \
		-i Makefile.in || die "sed failed"
	tc-export CC

	# Fix systemd units for Gentoo
	sed -i -e '/User/d' systemd/fcgiwrap.service || die
	sed -i -e '/Group/d' systemd/fcgiwrap.service || die

	eautoreconf
}

src_configure() {
	econf \
		$(use_with systemd) \
		"$(systemd_with_unitdir)"
}

pkg_postinst() {
	einfo 'You may want to install www-servers/spawn-fcgi to use with fcgiwrap.'
}
