# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 bash-completion-r1

DESCRIPTION="Entropy Package Manager server-side tools"
HOMEPAGE="http://www.sabayon.org"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+matter"

SRC_URI="mirror://sabayon/sys-apps/entropy-${PV}.tar.bz2"

S="${WORKDIR}/entropy-${PV}/server"

RDEPEND="~sys-apps/entropy-${PV}[${PYTHON_USEDEP}]
	matter? ( ~app-admin/matter-${PV}[entropy] )
	${PYTHON_DEPS}
	"
DEPEND="app-text/asciidoc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	emake DESTDIR="${D}" install
	newbashcomp "${S}/eit-completion.bash" eit

	python_optimize "${D}/usr/lib/entropy/server"
}
