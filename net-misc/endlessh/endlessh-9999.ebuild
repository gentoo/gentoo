# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

inherit python-single-r1 systemd toolchain-funcs

DESCRIPTION="SSH tarpit that slowly sends and endless banner"
HOMEPAGE="https://github.com/skeeto/endlessh"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/skeeto/${PN}.git"
else
	SRC_URI="https://github.com/skeeto/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Unlicense"
SLOT="0"
IUSE="tools"
REQUIRED_USE="tools? ( ${PYTHON_REQUIRED_USE} )"

DEPEND=""

RDEPEND="${DEPEND}
	tools? (
		${PYTHON_DEPS}
		dev-db/sqlite
		dev-python/pyrfc3339[${PYTHON_USEDEP}]
	)
"

BDEPEND=""

pkg_setup() {
	use tools && python-single-r1_pkg_setup
}

src_prepare() {
	default

	tc-export CC

	sed -i \
		-e 's/^CC/CC?/' \
		-e 's/^CFLAGS  =/CFLAGS  +=/' \
		-e 's/ -Os//' \
		-e 's/^LDFLAGS/LDFLAGS?/' \
		Makefile || die

	sed -i -e "/^ExecStart=/ s:=/opt/endlessh:=${EPREFIX}/usr/bin:" \
		util/endlessh.service || die
}

src_install() {
	dobin endlessh

	newinitd "${FILESDIR}"/endlessh.initd endlessh
	newconfd "${FILESDIR}"/endlessh.confd endlessh

	systemd_dounit util/endlessh.service

	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotated" endlessh

	einstalldocs
}
