# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd toolchain-funcs

DESCRIPTION="SSH tarpit that slowly sends and endless banner"
HOMEPAGE="https://github.com/skeeto/endlessh"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/skeeto/${PN}.git"
else
	SRC_URI="https://github.com/skeeto/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ppc64 x86"
fi

LICENSE="Unlicense"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""
BDEPEND=""

src_prepare() {
	default

	tc-export CC

	sed -i \
		-e 's/^CC/CC?/' \
		-e 's/^CFLAGS  =/CFLAGS  +=/' \
		-e 's/ -Os//' \
		-e 's/^LDFLAGS/LDFLAGS?/' \
		-e 's/^PREFIX/PREFIX?/' \
		Makefile || die

	sed -i -e "/^ExecStart=/ s:=/opt/endlessh:=${EPREFIX}/usr/bin:" \
		util/endlessh.service || die
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install

	einstalldocs

	newinitd "${FILESDIR}"/endlessh.initd-r2 endlessh
	newconfd "${FILESDIR}"/endlessh.confd-r2 endlessh

	systemd_dounit util/endlessh.service

	insinto /usr/share/"${PN}"
	doins util/{pivot.py,schema.sql}
}

pkg_postinst() {
	elog "Log parsing script installed to ${EPREFIX}/usr/share/${PN}"
	elog "Install dev-python/pyrfc3339 if you are going to use it"
}
