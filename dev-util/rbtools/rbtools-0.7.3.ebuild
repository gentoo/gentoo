# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/rbtools/rbtools-0.7.3.ebuild,v 1.1 2015/05/28 19:26:07 kensington Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 versionator

MY_PN="RBTools"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Command line tools for use with Review Board"
HOMEPAGE="http://www.reviewboard.org/"
SRC_URI="http://downloads.reviewboard.org/releases/${MY_PN}/$(get_version_component_range 1-2)/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/six-1.8.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

DOCS=( AUTHORS NEWS README )

S=${WORKDIR}/${MY_P}
