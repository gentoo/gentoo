# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/overlint/overlint-0.5.3.ebuild,v 1.6 2015/04/25 16:25:44 floppym Exp $

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Simple tool for static analysis of overlays"
HOMEPAGE="http://cgit.gentoo.org/proj/overlint.git"
SRC_URI="http://www.hartwork.org/public/${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 arm x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="sys-apps/portage"
