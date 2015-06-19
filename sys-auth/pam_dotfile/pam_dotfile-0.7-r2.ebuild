# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/pam_dotfile/pam_dotfile-0.7-r2.ebuild,v 1.4 2013/05/20 08:25:37 ago Exp $

EAPI=5

inherit eutils pam autotools autotools-utils

MY_P="${P/_beta/beta}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="pam module to allow password-storing in \$HOME/dotfiles"
HOMEPAGE="http://0pointer.de/lennart/projects/pam_dotfile/
	https://github.com/gentoo/pam_dotfile/"
SRC_URI="http://0pointer.de/lennart/projects/pam_dotfile/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc"

RDEPEND="virtual/pam"
DEPEND="${RDEPEND}
	doc? ( www-client/lynx )"

HTML_DOCS="doc"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable doc lynx)
		--with-pammoddir=$(getpam_mod_dir)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	# kill the libtool archives
	rm -rf "${D}"/$(getpam_mod_dir)/*.la
}
