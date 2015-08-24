# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
PYTHON_DEPEND="2"

inherit python

MY_P="${P/-/_}_20100303"
DESCRIPTION="IMAP Spam Begone: a script that makes it easy to scan an IMAP inbox for spam using SpamAssassin"
HOMEPAGE="http://redmine.ookook.fr/projects/isbg"
SRC_URI="https://github.com/downloads/ook/${PN}/${MY_P}.tgz"

# upstream says:
# You may use isbg under any OSI approved open source license
# such as those listed at http://opensource.org/licenses/alphabetical
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	mail-filter/spamassassin
"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	python_convert_shebangs 2 isbg.py
}

src_install() {
	dobin isbg.py || die "script installation failed"
	dodoc CHANGELOG CONTRIBUTORS README || die "doc installation failed"
}
