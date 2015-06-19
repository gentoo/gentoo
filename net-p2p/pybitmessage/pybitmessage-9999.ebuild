# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/pybitmessage/pybitmessage-9999.ebuild,v 1.3 2013/08/05 16:12:28 hasufell Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit eutils python-r1 gnome2-utils git-2

DESCRIPTION="P2P communications protocol"
HOMEPAGE="https://bitmessage.org"
EGIT_REPO_URI="https://github.com/Bitmessage/PyBitmessage.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-libs/openssl[-bindist]
	dev-python/PyQt4[${PYTHON_USEDEP}]"

src_compile() { :; }

src_install () {
	cat >> "${T}"/${PN}-wrapper <<-EOF
	#!/usr/bin/env python
	import os
	import sys
	sys.path.append("@SITEDIR@")
	os.chdir("@SITEDIR@")
	os.execl('@PYTHON@', '@EPYTHON@', '@SITEDIR@/bitmessagemain.py')
	EOF

	touch src/__init__.py || die

	install_python() {
		local python_moduleroot=${PN}
		python_domodule src/*
		sed \
			-e "s#@SITEDIR@#$(python_get_sitedir)/${PN}#" \
			-e "s#@EPYTHON@#${EPYTHON}#" \
			-e "s#@PYTHON@#${PYTHON}#" \
			"${T}"/${PN}-wrapper > ${PN} || die
		python_doscript ${PN}
	}

	python_foreach_impl install_python

	nonfatal dodoc README.md debian/changelog
	nonfatal doman man/*

	nonfatal newicon -s 24 desktop/icon24.png ${PN}.png
	nonfatal newicon -s scalable desktop/can-icon.svg ${PN}.svg
	nonfatal domenu desktop/${PN}.desktop
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
