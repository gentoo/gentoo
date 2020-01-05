# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

AUTOTOOLS_AUTORECONF=true
KEYWORDS=""
SRC_URI=""

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/crmsh/crmsh"
	inherit git-2
	S="${WORKDIR}/${PN}-${MY_TREE}"
else
	SRC_URI="https://github.com/crmsh/crmsh/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~hppa ~x86"
fi

inherit eutils python-r1

DESCRIPTION="Pacemaker command line interface for management and configuration"
HOMEPAGE="https://crmsh.github.io/"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	>=sys-cluster/pacemaker-1.1.9"
RDEPEND="${DEPEND}
	dev-python/lxml[${PYTHON_USEDEP}]"

src_configure() {
	./autogen.sh
	econf
}

src_install() {
	emake DESTDIR="${D}" install
}
