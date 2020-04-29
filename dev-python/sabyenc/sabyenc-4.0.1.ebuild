# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Module providing raw yEnc encoding/decoding for SABnzbd"
HOMEPAGE="https://github.com/sabnzbd/sabyenc"
SRC_URI="https://github.com/sabnzbd/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( CHANGES.md README.md doc/yenc-draft.1.3.txt )

distutils_enable_tests pytest
