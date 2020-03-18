# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="Red Hat crash utility; used for analyzing kernel core dumps"
HOMEPAGE="https://people.redhat.com/anderson/"
SRC_URI="https://people.redhat.com/anderson/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="-* ~alpha ~amd64 ~arm ~ia64 ~ppc64 ~s390 ~x86"
IUSE=""
# there is no "make test" target, but there is a test.c so the automatic
# make rules catch it and tests fail
RESTRICT="test"
