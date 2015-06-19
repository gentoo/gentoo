# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/alot/alot-0.3.6.ebuild,v 1.2 2014/08/07 19:44:13 aidecoe Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Experimental terminal UI for net-mail/notmuch written in Python"
HOMEPAGE="https://github.com/pazz/alot"
SRC_URI="${HOMEPAGE}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	"
RDEPEND="
	>=dev-python/configobj-4.6.0[${PYTHON_USEDEP}]
	dev-python/pygpgme[${PYTHON_USEDEP}]
	>=dev-python/twisted-core-10.2.0
	>=dev-python/urwid-1.1.0[${PYTHON_USEDEP}]
	net-mail/mailbase
	>=net-mail/notmuch-0.13[crypt,python]
	sys-apps/file[python]
	"

ALOT_UPDATE=""

pkg_setup() {
	if has_version "<${CATEGORY}/${PN}-0.3.2"; then
		ALOT_UPDATE="yes"
	fi
}

src_prepare() {
	find "${S}" -name '*.py' -print0 | xargs -0 -- sed \
		-e '1i# -*- coding: utf-8 -*-' -i || die

	distutils-r1_src_prepare

	local md
	for md in *.md; do
		mv "${md}" "${md%.md}"
	done
}

src_compile() {
	distutils-r1_src_compile

	if use doc; then
		pushd docs || die
		emake html
		popd || die
	fi
}

src_install() {
	distutils-r1_src_install

	dodir /usr/share/alot
	insinto /usr/share/alot
	doins -r extra

	if use doc; then
		dohtml -r docs/build/html/*
	fi
}

pkg_postinst() {
	if [[ ${ALOT_UPDATE} = yes ]]; then
		ewarn "The syntax of theme-files and custom tags-sections of the config"
		ewarn "has been changed.  You have to revise your config.  There are"
		ewarn "converter scripts in /usr/share/alot/extra to help you out with"
		ewarn "this:"
		ewarn ""
		ewarn "  * tagsections_convert.py for your ~/.config/alot/config"
		ewarn "  * theme_convert.py to update your custom theme files"
	fi
}
