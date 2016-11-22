# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-single-r1

DESCRIPTION="A toolkit for dealing with the qmail queue directory structure"
HOMEPAGE="http://pyropus.ca/software/queue-repair/"
SRC_URI="http://pyropus.ca/software/queue-repair/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="${PYTHON_DEPS}"
REQURIED_USE="${PYTHON_REQUIRED_USE}"
DOCS=( BLURB TODO CHANGELOG )

src_install () {
	python_newscript queue_repair.py queue-repair.py
	dosym /usr/bin/queue-repair.py /usr/bin/queue-repair
	einstalldocs
}
