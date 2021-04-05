# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit python-single-r1

DESCRIPTION="A toolkit for dealing with the qmail queue directory structure"
HOMEPAGE="http://pyropus.ca/software/queue-repair/"
SRC_URI="http://pyropus.ca/software/queue-repair/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="test" # no tests

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

DOCS=( BLURB TODO CHANGELOG )

src_prepare() {
	eapply_user

	2to3 -n -w --no-diffs queue_repair.py || die
}

src_install() {
	python_newscript queue_repair.py queue-repair.py
	dosym queue-repair.py /usr/bin/queue-repair
	einstalldocs
}
