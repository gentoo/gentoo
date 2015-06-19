# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/kergen/kergen-0.1.1.ebuild,v 1.1 2015/04/17 07:03:48 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python3_{3,4} )

inherit distutils-r1

DESCRIPTION="Kernel config generator"
HOMEPAGE="https://github.com/nichoski/kergen"
SRC_URI="http://whatishacking.org/${PN}/downloads/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
