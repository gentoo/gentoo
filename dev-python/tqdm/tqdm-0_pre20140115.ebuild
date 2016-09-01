# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Add a progress meter to your loops in a second."
HOMEPAGE="https://github.com/noamraph/tqdm"
COMMIT="da5fdbf7c05a9127f04ac5887292457e8335f480"
SRC_URI="https://github.com/noamraph/${PN}/tarball/${COMMIT} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

