# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1

DEBIAN_PV="2.65"

DESCRIPTION="A python script that converts RSS/Atom newsfeeds to email"
HOMEPAGE="http://www.allthingsrss.com/rss2email"
SRC_URI="http://www.allthingsrss.com/${PN}/${P}.tar.gz
	mirror://debian/pool/main/r/${PN}/${PN}_${DEBIAN_PV}-1.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="dev-util/patchutils"
RDEPEND=">=dev-python/feedparser-5.0.1
	>=dev-python/html2text-3.01"

src_unpack() {
	# Tarball has zero permissions inside
	tar xf "${DISTDIR}"/${P}.tar.gz || die
	chmod 0755 ${P} || die
	chmod 0644 ${P}/* || die
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.69-config-location.patch

	# Extract man page from Debian patch
	zcat "${DISTDIR}"/${PN}_${DEBIAN_PV}-1.diff.gz \
		| filterdiff -i '*/r2e.1' \
		> "${S}"/r2e.1.patch || die
	EPATCH_OPTS="-p1" epatch r2e.1.patch
}

src_install() {
	my_install() {
		insinto "$(python_get_sitedir)"/${PN}
		newins rss2email.py main.py || die
	}
	python_foreach_impl my_install

	insinto /etc/${PN}
	doins config.py.example || die

	dodoc CHANGELOG readme.html || die
	doman r2e.1 || die

	# Replace r2e wrapper
	cat <<-"EOF" >r2e
		#! /bin/sh
		SITE_PACKAGES=`python2 -c "from distutils.sysconfig import get_python_lib; print get_python_lib()"`
		CONF_DIR=${HOME}/.rss2email
		mkdir -p "${CONF_DIR}"
		exec python2 "${SITE_PACKAGES}"/rss2email/main.py "${CONF_DIR}"/feeds.dat $*
	EOF

	dobin r2e || die
}
