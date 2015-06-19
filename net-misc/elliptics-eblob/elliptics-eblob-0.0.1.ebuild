# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/elliptics-eblob/elliptics-eblob-0.0.1.ebuild,v 1.3 2013/08/15 03:34:26 patrick Exp $

EAPI=4
PYTHON_DEPEND="python? 2"

inherit eutils autotools python flag-o-matic

DESCRIPTION="The elliptics network - eblob backend"
HOMEPAGE="http://www.ioremap.net/projects/elliptics"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="python"
RDEPEND="dev-libs/openssl
	python? ( dev-libs/boost[python] )"
DEPEND="${RDEPEND}"

MY_PN="eblob"
SRC_URI="http://www.ioremap.net/archive/${MY_PN}/${MY_PN}-${PV}.tar.gz"

S=${WORKDIR}/${MY_PN}-${PV}

src_prepare(){
	use python || sed -i 's/SUBDIRS = .*/SUBDIRS = include library/' "${S}/Makefile.am"
	eautoreconf
}

src_configure(){
	# 'checking trying to link with boost::python... no' due '-Wl,--as-needed'
	use python && filter-ldflags -Wl,--as-needed
	econf \
		--with-libatomic-path=/dev/null \
		$(use_with python boost)
}

src_install(){
	emake install DESTDIR="${D}" || die
	find "${D}" -name '*.la' -exec rm -f {} +
}
