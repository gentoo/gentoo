# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: f817d96e09d5ad0b706abaadace1af19614d1acd $

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Module providing raw yEnc encoding/decoding for SABnzbd"
HOMEPAGE="https://github.com/sabnzbd/sabyenc/"
SRC_URI="https://github.com/sabnzbd/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Remove forced CFLAG on setup.py
PATCHES=( "${FILESDIR}"/0001-remove-hardcoded-cflags.patch )
DOCS=( CHANGES.md README.md doc/yenc-draft.1.3.txt )

python_test() {
	"${PYTHON}" test/test.py || die "Test failed."
}
