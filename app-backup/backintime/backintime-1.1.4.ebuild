# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python3_2 python3_3 python3_4 )

inherit eutils python-single-r1

DESCRIPTION="Backup system inspired by TimeVault and FlyBack, with a GUI for GNOME and KDE4"
HOMEPAGE="http://backintime.le-web.org/"
SRC_URI="http://${PN}.le-web.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="qt4"

RDEPEND="${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/keyring[${PYTHON_USEDEP}]
	net-misc/openssh
	net-misc/rsync[xattr,acl]"

DEPEND="${RDEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-python-version-stderr.patch

	#fix doc install location
	sed -e "s:/doc/${PN}-common:/doc/${PF}:g" \
		-i common/Makefile.template || die
	sed -e "s:/doc/${PN}-qt4:/doc/${PF}:g" \
		-i qt4/Makefile.template || die
	sed -e "/\/VERSION/d" -e "/\/LICENSE/d" -e "/\/copyright/d" \
		-i {qt4,common}/Makefile.template || die

	if [ -n ${LINGUAS+x} ] ; then
		cd common/po || die
		for po in *.po ; do
			if ! has ${po/.po} ${LINGUAS} ; then
				rm ${po} || die
			fi
		done
	fi
}

src_configure() {
	cd "${S}"/common || die
	./configure --python3 --no-fuse-group || die
	if use qt4 ; then
		cd "${S}"/qt4 || die
		./configure --python3 || die
	fi
}

src_compile() {
	cd "${S}"/common || die
	emake
	if use qt4 ; then
		cd "${S}"/qt4 || die
		emake
	fi
}

src_install() {
	cd "${S}"/common || die
	emake DESTDIR="${D}" install
	if use qt4 ; then
		cd "${S}"/qt4 || die
		emake DESTDIR="${D}" install
	fi

	python_optimize "${D}"
}
