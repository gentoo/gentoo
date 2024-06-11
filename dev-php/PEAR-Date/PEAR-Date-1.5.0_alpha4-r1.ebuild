# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PEAR_PV=${PV/_alpha/a}
inherit php-pear-r2

KEYWORDS="amd64 arm ~hppa ppc64 ~s390 sparc x86"

DESCRIPTION="Date and Time Zone classes"
LICENSE="BSD"
SLOT="0"
IUSE=""
DOCS=( README docs/TODO )
HTML_DOCS=( docs/examples/example.php )
