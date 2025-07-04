# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit python-single-r1

DESCRIPTION="Toolkit for dealing with the qmail queue directory structure"
HOMEPAGE="https://pyropus.ca/software/queue-repair/"
SRC_URI="https://pyropus.ca/software/queue-repair/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="test" # no tests

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

DOCS=( BLURB TODO CHANGELOG )

PATCHES=(
	"${FILESDIR}"/queue-repair-0.9.0-python3.patch
)

src_install() {
	python_newscript queue_repair.py queue-repair.py
	dosym queue-repair.py /usr/bin/queue-repair
	einstalldocs
}
