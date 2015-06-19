# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/fetchcommandwrapper/fetchcommandwrapper-0.7.2.ebuild,v 1.1 2014/11/21 15:54:58 sping Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Wrapper integrating aria2 into portage's FETCHCOMMAND"
HOMEPAGE="https://github.com/gentoo/fetchcommandwrapper"
SRC_URI="http://www.hartwork.org/public/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=net-misc/aria2-1.10.2"

pkg_postinst() {
	ewarn 'You need to append'
	ewarn '   source /usr/share/fetchcommandwrapper/make.conf'
	ewarn 'to /etc/portage/make.conf in order to integrate fetchcommandwrapper.'
}
