# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygit2/pygit2-0.21.4-r1.ebuild,v 1.1 2015/03/19 07:23:25 radhermit Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 versionator

DESCRIPTION="Python bindings for libgit2"
HOMEPAGE="https://github.com/libgit2/pygit2"
SRC_URI="https://github.com/libgit2/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	=dev-libs/libgit2-$(get_version_component_range 1-2)*
	dev-python/cffi:=[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

python_test() {
	esetup.py test
}
