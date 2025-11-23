# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Scmxlate is a configuration tool for software packages written in Scheme"
HOMEPAGE="http://www.ccs.neu.edu/home/dorai/scmxlate/scmxlate.html"
SRC_URI="http://evalwhen.com/scmxlate/scmxlate.tar.bz2
	-> ${P}.tar.bz2"
S="${WORKDIR}"/${PN}

LICENSE="freedist" # license doesn't grant the right for modifications
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README )

src_compile() {
	:
}

src_install() {
	insinto /usr/share/${PN}/
	doins *.cl *.scm

	einstalldocs
}
