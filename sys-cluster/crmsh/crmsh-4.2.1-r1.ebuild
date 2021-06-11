# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

AUTOTOOLS_AUTORECONF=true
SRC_URI=""

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/crmsh/crmsh"
	inherit git-3
	S="${WORKDIR}/${PN}-${MY_TREE}"
else
	SRC_URI="https://github.com/crmsh/crmsh/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~hppa ~x86"
fi

inherit python-r1

DESCRIPTION="Pacemaker command line interface for management and configuration"
HOMEPAGE="https://crmsh.github.io/"

LICENSE="GPL-2"
SLOT="0"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	>=sys-cluster/pacemaker-1.1.9"
RDEPEND="${DEPEND}
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/parallax[${PYTHON_USEDEP}]
"

src_configure() {
	./autogen.sh || die
	econf
}

src_install() {
	emake DESTDIR="${D}" install
	python_foreach_impl python_optimize
}
